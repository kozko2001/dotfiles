---
name: boe-jobs
description: |
  Extract and summarize job opportunities and public employment calls from the BOE
  (Boletín Oficial del Estado, Spain's national gazette).
  Use this skill when the user asks about "ofertas de trabajo BOE", "oposiciones BOE",
  "convocatorias BOE", "empleo público BOE", "concursos BOE", "plazas BOE",
  or says "muéstrame las oposiciones del BOE", "qué convocatorias hay en el BOE", etc.
  Reads the local scraper output (sumario.xml + individual document XMLs) for a given
  date and presents all job-related entries grouped by section and body.
allowed-tools:
  - Bash
  - Read
---

# boe-jobs

Read a day's BOE output and present all job opportunities and personnel calls found in it.

## Inputs

- `DATE`: the date to look up in `YYYY-MM-DD` format (default: most recent available date)

Derive from the user's message if provided; otherwise use the latest date folder.

## Steps

### 1. Resolve the date folder

```bash
BOE_NFS="nfs://192.168.1.241/volume1/kubernetes/boe-scraper-boe-scraper-data-pvc-9fda44fb-5a3f-4dd0-a188-eee8e88570b1/output/boe"
DATE=$(python3 ~/.claude/skills/boe-jobs/scripts/parse-sumario.py --latest-date "$BOE_NFS")
# override DATE with user-supplied date if given
echo "Using date: $DATE"
```

### 2. Parse the sumario.xml index for job-related entries

Run the helper script to extract all documents from:
- Section `2B` ("II. Autoridades y personal. - B. Oposiciones y concursos") — always included
- Any epigraph in other sections matching employment keywords (convocatoria, concurso, oposición, etc.)

```bash
python3 ~/.claude/skills/boe-jobs/scripts/parse-sumario.py "$BOE_NFS/$DATE/sumario.xml"
```

This outputs a structured list grouped by section, department, and epigraph, with
the NFS path for each document's XML file.

### 3. Read individual XML files for detail (optional)

Each document has a local XML file (e.g. `BOE-A-2026-13132.xml`) that contains
full metadata: `<rango>`, `<departamento>`, `<materias>`, `<titulo>`, and the full
text inside `<texto>` elements. The `XML:` path shown in step 2 output is an NFS
URL you can read directly. Read these when titles are too generic.

```bash
# Example: read details for a specific document via NFS
python3 -c "
import io, subprocess, xml.etree.ElementTree as ET
LIBNFS = subprocess.run(['nix','build','--no-link','--print-out-paths','nixpkgs#libnfs'],
    capture_output=True, text=True, check=True).stdout.strip()
data = subprocess.run([LIBNFS+'/bin/nfs-cat', '$BOE_NFS/$DATE/BOE-A-2026-XXXXX.xml'],
    capture_output=True, check=True).stdout
root = ET.parse(io.BytesIO(data)).getroot()
for el in root.iter():
    if el.tag in ('titulo', 'p', 'nota') and el.text:
        print(el.text.strip()[:300])
" 2>/dev/null | head -40
```

### 4. Present the results

Using the sumario.xml parsed entries (Step 2) as the primary source, format results
grouped by section, then department. For each entry include:

```
**[Epígrafe]** [Identifier] — [Title]
Organismo: [Department]
Tipo: [document type if clear from title: convocatoria / concurso / oposición / libre designación / lista de admitidos]
PDF: [url]
```

Focus on **new calls** (convocatorias, concursos, libre designación) over procedural
updates (correcciones de errores, modificación de tribunales, listas de admitidos) —
flag the latter as "📋 Fase en curso" so the user can distinguish open vs in-progress.

At the end note the BOE issue number and date.

## Notes

- Section `2B` is the dedicated employment section; the local admin entries (`ADMINISTRACIÓN LOCAL`) are typically the bulk of it.
- BOE document IDs follow the pattern `BOE-A-YYYY-NNNNN` (sección A = general) or `BOE-B-YYYY-NNNNN` (sección B = private/other announcements).
- If the title says "para proveer una/varias plazas" without details, read the local XML body for the actual post name.
- Skill scripts live at `~/.claude/skills/boe-jobs/scripts/`. In this dotfiles repo they are at `apps/skills/boe-jobs/scripts/` and should be symlinked or copied to `~/.claude/skills/boe-jobs/` on deployment.
