#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.boto3
"""Update all A records in coscolla.net and allocsoc.net to the current public IP."""

import argparse
import subprocess
import sys
import urllib.request

DOMAINS = ["coscolla.net", "allocsoc.net"]
DEFAULT_ENTRY = "AWS/route53-ddns"
DEFAULT_KDBX = "/home/kozko/keepass/keepass.kdbx"


def get_public_ip():
    for url in ["https://ifconfig.me", "https://ipinfo.io/ip"]:
        try:
            with urllib.request.urlopen(url, timeout=5) as r:
                return r.read().decode().strip()
        except Exception:
            pass
    print("ERROR: could not detect public IP", file=sys.stderr)
    sys.exit(1)


def get_credentials_from_kdbx(kdbx_path, entry):
    print(f"Reading credentials from KeePass entry '{entry}' — enter your master password when prompted.")
    try:
        result = subprocess.run(
            ["keepassxc-cli", "show", "-s", kdbx_path, entry],
            capture_output=True, text=True, check=True,
        )
    except FileNotFoundError:
        print("ERROR: keepassxc-cli not found — install keepassxc", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"ERROR: keepassxc-cli failed: {e.stderr.strip()}", file=sys.stderr)
        sys.exit(1)

    access_key = secret_key = None
    for line in result.stdout.splitlines():
        if line.startswith("UserName:"):
            access_key = line.split(":", 1)[1].strip()
        elif line.startswith("Password:"):
            secret_key = line.split(":", 1)[1].strip()

    if not access_key or not secret_key:
        print("ERROR: could not parse UserName/Password from kdbx entry", file=sys.stderr)
        sys.exit(1)

    print(f"Credentials loaded: Access Key ID = {access_key[:8]}... (secret key retrieved)")
    return access_key, secret_key


def update_domains(access_key, secret_key, new_ip, dry_run):
    import boto3

    r53 = boto3.client(
        "route53",
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
        region_name="us-east-1",
    )

    paginator_zones = r53.get_paginator("list_hosted_zones")
    all_zones = [z for page in paginator_zones.paginate() for z in page["HostedZones"]]

    for domain in DOMAINS:
        fqdn = domain + "."
        matched = [z for z in all_zones if z["Name"] == fqdn]
        if not matched:
            print(f"{domain}: no hosted zone found — skipping")
            continue

        zone_id = matched[0]["Id"].split("/")[-1]
        paginator = r53.get_paginator("list_resource_record_sets")
        all_a_records = []
        for page in paginator.paginate(HostedZoneId=zone_id):
            all_a_records.extend(r for r in page["ResourceRecordSets"] if r["Type"] == "A")

        alias_records = [r["Name"] for r in all_a_records if "AliasTarget" in r]
        a_records = [r for r in all_a_records if "AliasTarget" not in r]

        if alias_records:
            print(f"{domain}: skipping {len(alias_records)} alias record(s): {', '.join(alias_records)}")

        if not a_records:
            print(f"{domain}: no plain A records found — skipping")
            continue

        current_ips = {v["Value"] for rec in a_records for v in rec.get("ResourceRecords", [])}
        if current_ips == {new_ip}:
            print(f"{domain}: already set to {new_ip} — skipping")
            continue

        changes = [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    **rec,
                    "ResourceRecords": [{"Value": new_ip}],
                },
            }
            for rec in a_records
        ]

        names = [r["Name"] for r in a_records]
        if dry_run:
            print(f"{domain}: [dry-run] would update {len(changes)} A record(s) → {new_ip}")
            for n in names:
                print(f"  {n}")
        else:
            r53.change_resource_record_sets(
                HostedZoneId=zone_id,
                ChangeBatch={"Comment": "update-r53-home-ip", "Changes": changes},
            )
            print(f"{domain}: updated {len(changes)} A record(s) → {new_ip}")
            for n in names:
                print(f"  {n}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    creds = parser.add_mutually_exclusive_group(required=True)
    creds.add_argument("--kdbx", metavar="FILE", help="path to KeePass .kdbx file")
    creds.add_argument("--access-key", metavar="KEY", help="AWS Access Key ID")
    parser.add_argument("--entry", default=DEFAULT_ENTRY,
                        help=f"KeePass entry path (default: {DEFAULT_ENTRY})")
    parser.add_argument("--secret-key", metavar="KEY", help="AWS Secret Access Key (with --access-key)")
    parser.add_argument("--ip", metavar="ADDR", help="IP to set (default: auto-detect)")
    parser.add_argument("--dry-run", action="store_true", help="show what would change without applying")
    args = parser.parse_args()

    if args.access_key and not args.secret_key:
        parser.error("--access-key requires --secret-key")

    if args.kdbx:
        import os
        kdbx = os.path.expanduser(args.kdbx)
        if not os.path.exists(kdbx):
            parser.error(f"kdbx file not found: {kdbx}")
        access_key, secret_key = get_credentials_from_kdbx(kdbx, args.entry)
    else:
        access_key, secret_key = args.access_key, args.secret_key

    new_ip = args.ip or get_public_ip()
    print(f"Public IP: {new_ip}")

    update_domains(access_key, secret_key, new_ip, args.dry_run)


if __name__ == "__main__":
    main()
