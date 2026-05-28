# Hibernation Setup (Framework Laptop)

The Framework uses a **swapfile** (`/swapfile`) for hibernation. Two values must be correct in `framework/configuration.nix` for resume to work:

1. `boot.resumeDevice` — UUID of the root partition (where `/swapfile` lives).
2. `resume_offset` in `boot.kernelParams` — physical sector offset of the swapfile on disk.

## When to update

Anytime you resize, recreate, or move the swapfile — the offset changes and must be recalculated.

## Steps

**1. Get the new physical offset:**

```bash
sudo filefrag -v /swapfile | head -5
```

Look at the first `physical_offset` value in the table, e.g.:

```
ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    2047:    2379776..   2381823:   2048:
```

The offset here is `2379776`.

**2. Update `framework/configuration.nix`:**

```nix
boot.resumeDevice = "/dev/disk/by-uuid/5a73add8-4982-4155-82c4-bd0fa7f38ad2";
boot.kernelParams = [ "resume_offset=XXXXXXX" ];
```

Replace `XXXXXXX` with the value from step 1. The UUID is the root partition — don't change it unless the root partition itself changes (check `framework/hardware-configuration.nix` line 19).

**3. Rebuild:**

```bash
sudo nixos-rebuild switch
```

**4. Test:**

```bash
systemctl hibernate
```

Session should restore on next boot. If it boots fresh instead, the offset is wrong — redo step 1.

## Current values (last updated 2026-05-28)

| Setting | Value |
|---|---|
| `boot.resumeDevice` UUID | `5a73add8-4982-4155-82c4-bd0fa7f38ad2` |
| `resume_offset` | `2379776` |
| Swapfile path | `/swapfile` |
| Swapfile size | 16 GB |

## Lid close behavior

Configured in `framework/configuration.nix`:
- Lid close → suspend-then-hibernate (hibernates after 5 minutes of suspend)
- Lid close while docked → ignored
- Lid close on external power → ignored
