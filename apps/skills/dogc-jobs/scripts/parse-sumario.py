#!/usr/bin/env python3
import json
import os
import subprocess
import shutil
import sys

NFS_SERVER = "192.168.1.241"
NFS_EXPORT = "/volume1/kubernetes"

_nfs_cat_bin: str | None = None
_nfs_ls_bin: str | None = None


def _init_nfs() -> None:
    global _nfs_cat_bin, _nfs_ls_bin
    if _nfs_cat_bin is not None:
        return
    if shutil.which("nfs-cat"):
        _nfs_cat_bin = "nfs-cat"
        _nfs_ls_bin = "nfs-ls"
        return
    try:
        r = subprocess.run(
            ["nix", "build", "--no-link", "--print-out-paths", "nixpkgs#libnfs"],
            capture_output=True, text=True, check=True, timeout=120,
        )
        pkg = r.stdout.strip().splitlines()[0]
        _nfs_cat_bin = f"{pkg}/bin/nfs-cat"
        _nfs_ls_bin = f"{pkg}/bin/nfs-ls"
    except Exception as e:
        print(f"Warning: libnfs unavailable: {e}", file=sys.stderr)
        _nfs_cat_bin = ""


def _is_nfs(path: str) -> bool:
    return path.startswith("nfs://")


def _nfs_join(base: str, *parts: str) -> str:
    return base.rstrip("/") + "/" + "/".join(p.strip("/") for p in parts)


def read_bytes(path: str) -> bytes:
    if _is_nfs(path):
        _init_nfs()
        cat = _nfs_cat_bin
        if not cat:
            raise RuntimeError("libnfs not available; install nixpkgs#libnfs or mount the NFS share")
        r = subprocess.run([cat, path], capture_output=True, check=True)
        return r.stdout
    with open(path, "rb") as f:
        return f.read()


def list_dir(path: str) -> list[str]:
    if _is_nfs(path):
        _init_nfs()
        ls = _nfs_ls_bin
        if not ls:
            raise RuntimeError("libnfs not available; install nixpkgs#libnfs or mount the NFS share")
        r = subprocess.run([ls, path], capture_output=True, text=True, check=True)
        entries = []
        for line in r.stdout.splitlines():
            line = line.strip()
            if not line or "closing service" in line:
                continue
            parts = line.split()
            if parts:
                entries.append(parts[-1])
        return entries
    return os.listdir(path)


JOB_KEYWORDS = {"treball", "personal", "ocupació", "convocatòria", "oposicions", "selecció", "càrrecs"}
JOB_SECTIONS = {"càrrecs i personal"}


def is_job_related(text: str) -> bool:
    t = text.lower()
    return any(k in t for k in JOB_KEYWORDS)


def extract_documents(documents: list, section: str, department: str, results: list) -> None:
    for doc in documents:
        results.append({
            "section": section,
            "department": department,
            "title": doc.get("title", ""),
            "link": doc.get("linkDownloadDocumentPDF", ""),
        })


def scan(sumario_path: str) -> list:
    data = json.loads(read_bytes(sumario_path).decode("utf-8"))
    results: list = []
    date = ""
    num = ""
    for sumari in data.get("sumaris", []):
        date = sumari.get("dateStringDOGC", "")
        num = sumari.get("numDOGC", "")
        for section in sumari.get("section", []):
            section_title = section.get("title", "")
            in_job_section = section_title.lower() in JOB_SECTIONS or is_job_related(section_title)
            for header in section.get("header", []):
                dept = header.get("title", "")
                in_job_dept = in_job_section or is_job_related(dept)
                for doc in header.get("document", []):
                    if in_job_dept or is_job_related(doc.get("title", "")):
                        extract_documents([doc], section_title, dept, results)
                for subheader in header.get("subheader", []):
                    subdept = f"{dept} > {subheader.get('title', '')}"
                    in_job_sub = in_job_dept or is_job_related(subheader.get("title", ""))
                    for doc in subheader.get("document", []):
                        if in_job_sub or is_job_related(doc.get("title", "")):
                            extract_documents([doc], section_title, subdept, results)

    print(f"# DOGC {num} — {date}\n")
    current_section = None
    current_dept = None
    for r in results:
        if r["section"] != current_section:
            current_section = r["section"]
            print(f"\n## {current_section}")
        if r["department"] != current_dept:
            current_dept = r["department"]
            print(f"\n### {current_dept}")
        print(f"- {r['title']}")
        if r["link"]:
            print(f"  {r['link']}")
    return results


def latest_date(base: str) -> str:
    import re
    date_re = re.compile(r"^\d{4}-\d{2}-\d{2}$")
    entries = [e for e in list_dir(base) if date_re.match(e)]
    return sorted(entries)[-1] if entries else ""


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "--latest-date":
        print(latest_date(sys.argv[2]))
    elif len(sys.argv) == 2:
        scan(sys.argv[1])
    else:
        print("Usage: parse-sumario.py <path/to/sumario.json>", file=sys.stderr)
        print("       parse-sumario.py --latest-date <base_dir|nfs://...>", file=sys.stderr)
        sys.exit(1)
