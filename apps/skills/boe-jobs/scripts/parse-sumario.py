#!/usr/bin/env python3
import io
import os
import subprocess
import shutil
import sys
import xml.etree.ElementTree as ET

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


def _parent(path: str) -> str:
    if _is_nfs(path):
        return path.rsplit("/", 1)[0]
    return os.path.dirname(path)


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


JOB_SECTIONS = {"2B"}

JOB_EPIGRAPHS = {
    "convocatoria", "convocatorias", "concurso", "concursos",
    "oposicion", "oposiciones", "empleo", "personal funcionario",
    "personal laboral", "libre designacion", "procedimientos de libre designacion",
}

SKIP_EPIGRAPHS = {"ceses", "jubilaciones", "situaciones", "nombramientos"}


def is_job_epigraph(name: str) -> bool:
    n = name.lower()
    if any(s in n for s in SKIP_EPIGRAPHS):
        return False
    return any(k in n for k in JOB_EPIGRAPHS)


def parse(sumario_path: str) -> list:
    root = ET.parse(io.BytesIO(read_bytes(sumario_path))).getroot()
    base_dir = _parent(sumario_path)

    # Cache directory listing once for fast existence checks
    dir_files = set(list_dir(base_dir))

    def xml_path(ident: str) -> str:
        filename = f"{ident}.xml"
        if filename not in dir_files:
            return ""
        return _nfs_join(base_dir, filename) if _is_nfs(base_dir) else os.path.join(base_dir, filename)

    diario = root.find(".//diario")
    numero = diario.get("numero", "?") if diario is not None else "?"
    fecha_el = root.find(".//fecha_publicacion")
    fecha_raw = fecha_el.text if fecha_el is not None else ""
    if fecha_raw and len(fecha_raw) == 8:
        fecha = f"{fecha_raw[6:8]}/{fecha_raw[4:6]}/{fecha_raw[:4]}"
    else:
        fecha = fecha_raw or "?"

    print(f"# BOE núm. {numero} — {fecha}\n")

    results = []
    for seccion in root.findall(".//seccion"):
        sec_cod = seccion.get("codigo", "")
        sec_name = seccion.get("nombre", "")
        in_job_section = sec_cod in JOB_SECTIONS

        for dept in seccion.findall("departamento"):
            dept_name = dept.get("nombre", "")
            for epig in dept.findall("epigrafe"):
                epig_name = epig.get("nombre", "")
                if not in_job_section and not is_job_epigraph(epig_name):
                    continue
                for item in epig.findall("item"):
                    ident_el = item.find("identificador")
                    titulo_el = item.find("titulo")
                    url_pdf_el = item.find("url_pdf")
                    ident = (ident_el.text or "") if ident_el is not None else ""
                    titulo = (titulo_el.text or "") if titulo_el is not None else ""
                    url_pdf = (url_pdf_el.text or "") if url_pdf_el is not None else ""
                    results.append({
                        "seccion": sec_name,
                        "dept": dept_name,
                        "epig": epig_name,
                        "ident": ident,
                        "titulo": titulo,
                        "url_pdf": url_pdf,
                        "local_xml": xml_path(ident),
                    })

    cur_sec = cur_dept = cur_epig = None
    for r in results:
        if r["seccion"] != cur_sec:
            cur_sec = r["seccion"]
            print(f"\n## {cur_sec}")
        if r["dept"] != cur_dept:
            cur_dept = r["dept"]
            print(f"\n### {cur_dept}")
        if r["epig"] != cur_epig:
            cur_epig = r["epig"]
            print(f"\n**{cur_epig}**")
        print(f"- [{r['ident']}] {r['titulo']}")
        if r["url_pdf"]:
            print(f"  PDF: {r['url_pdf']}")
        if r["local_xml"]:
            print(f"  XML: {r['local_xml']}")

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
        parse(sys.argv[1])
    else:
        print("Usage: parse-sumario.py <path/to/sumario.xml>", file=sys.stderr)
        print("       parse-sumario.py --latest-date <base_dir|nfs://...>", file=sys.stderr)
        sys.exit(1)
