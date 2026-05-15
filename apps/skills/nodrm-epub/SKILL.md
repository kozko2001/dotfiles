---
name: nodrm-epub
description: |
  Remove DRM from an Adobe ADEPT encrypted ePub borrowed from a library (e.g. Barcelona's biblioteca.ebiblio.cat).
  Use this skill when the user provides an .acsm file, says "download library book", "remove drm", "decrypt epub",
  "acsmdownloader", or asks to process a borrowed ebook from a library service.
  Handles the full workflow: ADEPT activation, downloading the DRM epub, decrypting it, and returning the loan.
allowed-tools:
  - Bash
  - Read
---

# nodrm-epub

Automate the full library-epub DRM removal workflow given an `.acsm` file path.

## Inputs

- `ACSM_FILE`: path to the `.acsm` file downloaded from the library website
- `OUTPUT_EPUB`: desired output path for the DRM-free epub (default: same dir as acsm, with `.epub` extension)

Derive these from the user's message or ask if not provided.

## Steps

### 1. Ensure ADEPT activation exists

```bash
ls ~/.config/adept/activation.xml
```

If missing, activate an anonymous account:

```bash
nix-shell -p libgourou --run "adept_activate -a"
```

### 2. Download the DRM-encrypted epub

```bash
nix-shell -p libgourou --run "acsmdownloader '$ACSM_FILE'"
```

This produces an `.epub` file in the current directory. Note the filename — it is the `INPUT_EPUB`.

### 3. Remove the DRM

```bash
nix-shell -p python313Packages.pycryptodome --run \
  "python $HOME/.claude/skills/nodrm-epub/scripts/rmdrm-epub.py \
   ~/.config/adept/activation.xml '$INPUT_EPUB' '$OUTPUT_EPUB'"
```

### 4. Report success

Tell the user the DRM-free epub is at `OUTPUT_EPUB`.

### 5. Return the loan (automatic)

```bash
# Find the loan ID
nix-shell -p libgourou --run "adept_loan_mgt"
```

Read the ID for this book, then return it immediately:

```bash
nix-shell -p libgourou --run "adept_loan_mgt -r $LOAN_ID"
```

Tell the user the loan has been returned.

## Notes

- All `nix-shell` commands may take a moment on first run (downloading packages).
- The script at `scripts/rmdrm-epub.py` is bundled with this skill — no separate installation needed.
- If activation already exists, skip step 1.
