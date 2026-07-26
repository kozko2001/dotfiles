---
name: dogc-jobs
description: |
  Extract and summarize job opportunities from the DOGC (Diari Oficial de la Generalitat de Catalunya).
  Use this skill when the user asks about "ofertes de treball DOGC", "convocatòries DOGC",
  "feines DOGC", "oposicions DOGC", "job opportunities DOGC", "càrrecs i personal DOGC",
  or says "mostra'm les ofertes de treball", "quines feines hi ha al DOGC", etc.
  Reads the local scraper output (JSON index + summary PDF) for a given date and presents
  all job-related entries in Catalan.
allowed-tools:
  - Bash
  - Read
---

# dogc-jobs

Read a day's DOGC output and present all job opportunities found in it.

## Inputs

- `DATE`: the date to look up in `YYYY-MM-DD` format (default: most recent available date)

Derive from the user's message if provided; otherwise use the latest date folder.

## Steps

### 1. Resolve the date folder

```bash
DOGC_NFS="nfs://192.168.1.241/volume1/kubernetes/boe-scraper-boe-scraper-data-pvc-9fda44fb-5a3f-4dd0-a188-eee8e88570b1/output/dogc"
DATE=$(python3 ~/.claude/skills/dogc-jobs/scripts/parse-sumario.py --latest-date "$DOGC_NFS")
# override DATE with user-supplied date if given
echo "Using date: $DATE"
```

### 2. Parse the JSON index for job-related entries

Run the helper script to extract all documents from job-related sections
("Càrrecs i personal" and any header/document matching employment keywords):

```bash
python3 ~/.claude/skills/dogc-jobs/scripts/parse-sumario.py "$DOGC_NFS/$DATE/sumario.json"
```

This outputs a structured list grouped by section and department.

### 3. Extract text from the summary PDF for additional context

The summary PDF is ~800 KB and contains condensed content. Use `nix-cat` from
libnfs to pipe the PDF bytes to `pdftotext` via `nix shell`:

```bash
LIBNFS=$(nix build --no-link --print-out-paths 'nixpkgs#libnfs')
SUMARI_URL="$DOGC_NFS/$DATE/$(${LIBNFS}/bin/nfs-ls "$DOGC_NFS/$DATE/" 2>/dev/null | awk '{print $NF}' | grep '_sumari.pdf')"
${LIBNFS}/bin/nfs-cat "$SUMARI_URL" | nix shell nixpkgs#poppler_utils --command pdftotext - -
```

If `nix shell` is slow on first run (downloading poppler), inform the user it
may take a moment.

### 4. Present the results

Using the JSON-parsed entries (Step 2) as the primary source and the PDF text
(Step 3) for any extra detail (deadlines, reference numbers, requirements),
format the output in Catalan as follows for each job entry:

```
**[Type]** [Document title]
Organisme: [Department / body]
Secció: [Section name]
Referència: [resolution number or code if visible]
Termini: [deadline if mentioned]
Més info: [PDF link from JSON]
```

Group entries by section ("Càrrecs i personal", "Disposicions generals", etc.).
At the end, note the DOGC issue number and date for reference.

## Notes

- The section **"Càrrecs i personal"** is the primary source for public-sector job postings.
- Document types to watch for: RESOLUCIÓ (resolution/appointment), ANUNCI (announcement/advert), CONVOCATÒRIA (open call).
- If the user wants full details of a specific posting, point them to the `linkDownloadDocumentPDF` URL from the JSON or suggest running `pdftotext` on the full gazette PDF (`DOGC_XXXX.pdf`).
- Skill scripts live at `~/.claude/skills/dogc-jobs/scripts/`. In this dotfiles repo they are at `apps/skills/dogc-jobs/scripts/` and should be symlinked or copied to `~/.claude/skills/dogc-jobs/` on deployment.
