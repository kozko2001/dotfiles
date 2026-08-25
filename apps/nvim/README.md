# nvim-latest

A minimal Neovim **0.12.4** config built on native APIs: `vim.pack` for
plugin management, `vim.lsp.config`/`vim.lsp.enable` for LSP, native LSP
completion, native LSP folding, and `vim.diagnostic.jump`. Only 6 plugins
are used, for things core Neovim genuinely doesn't provide: a fuzzy
finder, a directory-as-buffer file manager, treesitter (+textobjects),
mini.nvim (pairs/statusline/etc. as a library), and catppuccin.

No AI/LLM integration of any kind.

## Install

This config lives in its own directory so it doesn't touch your existing
Neovim config. Run it with:

```sh
NVIM_APPNAME=nvim-latest nvim
```

Add an alias if you like:

```sh
alias nvl='NVIM_APPNAME=nvim-latest nvim'
```

On first launch, `vim.pack.add` clones the 4 plugins automatically. Update
them later with `:lua vim.pack.update()`.

## External dependencies

| Purpose | Binary | Install |
|---|---|---|
| Fuzzy finder | `fzf`, `ripgrep` (`rg`) | your package manager, e.g. `brew install fzf ripgrep` |
| Python LSP | `pyright` | `npm i -g pyright` |
| Python lint/format | `ruff` | `pipx install ruff` (or `brew install ruff`) |
| TypeScript/JS LSP | `typescript-language-server`, `typescript` | `npm i -g typescript typescript-language-server` |
| Lua LSP | `lua-language-server` | `brew install lua-language-server` (or see [its releases](https://github.com/LuaLS/lua-language-server)) |
| Lua format | `stylua` | `cargo install stylua` |
| Go LSP | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| Go lint | `golangci-lint` | `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest` |
| Zig LSP | `zls` | build/download matching your Zig version: https://github.com/zigtools/zls |
| Rust LSP | `rust-analyzer` | `rustup component add rust-analyzer` |
| Rust lint | `clippy` | `rustup component add clippy` |
| Markdown LSP | `marksman` | `brew install marksman` (or its [releases](https://github.com/artempyanykh/marksman/releases)) |

Make sure everything above is on `$PATH`. Check `:checkhealth lsp` inside
Neovim once installed.

## Colorscheme

[catppuccin](https://github.com/catppuccin/nvim) (mocha flavor), loaded
in `lua/config/plugins.lua` right after `vim.pack.add`. Change the flavor
(`latte` / `frappe` / `macchiato` / `mocha`) in the `setup({ flavor = ... })`
call there.

## LSP

Configured in `lua/lsp/init.lua` using Neovim's native `vim.lsp.config` /
`vim.lsp.enable` (no nvim-lspconfig, no mason). Every server — `pyright`,
`ruff`, `ts_ls`, `lua_ls`, `gopls`, `rust_analyzer`, `zls`, `marksman` — has
its full `cmd`/`filetypes`/`root_markers` defined explicitly in that file: this
Neovim build doesn't ship pre-filled default configs (no
`$VIMRUNTIME/lsp/*.lua`), only the `vim.lsp.config`/`vim.lsp.enable`
mechanism itself, so nothing would attach without these definitions.

Keymaps (buffer-local, set on `LspAttach`):

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | References |
| `gs` | Signature help |
| `K` | Hover (Neovim 0.11+ built-in default, no custom mapping) |
| `<F2>` | Rename |
| `<F3>` | Format buffer |
| `<F4>` | Code action (normal + visual) |
| `<leader>ih` | Toggle inlay hints (only when the server supports them) |
| `]d` / `[d` | Next/prev diagnostic |
| `]e` / `[e` | Next/prev **error** |
| `<leader>e` | Show diagnostic under cursor |
| `<leader>q` | Diagnostics to location list |
| `<leader>ud` | Toggle diagnostics on/off |
| `<leader>uv` | Toggle diagnostic virtual text |

Neovim 0.11+ also ships default LSP mappings alongside these: `grr`
(references), `gra` (code action), `grn` (rename), `gri` (implementation),
`gO` (document symbols). Native `gc`/`gcc` commenting (0.10+) works too —
no plugin needed.

When the server supports `textDocument/documentHighlight`, all references
to the symbol under the cursor are highlighted on `CursorHold` and cleared
when the cursor moves.

`ruff` runs as a second LSP client alongside `pyright` for Python — it
gives lint diagnostics and formatting without a separate linter plugin.
Its hover provider is disabled so `K` always comes from pyright.
`rust_analyzer` runs `cargo clippy` on save via its native `check.command`
setting.

Format-on-save is enabled globally (`lua/config/autocmds.lua`) via
`vim.lsp.buf.format()`; it's skipped for buffers with no formatting-capable
LSP client. Disable it with `:let g:disable_autoformat = 1` (global) or
`:let b:disable_autoformat = 1` (buffer — handy in a project `.nvim.lua`).

Folding uses treesitter's foldexpr — no folding plugin, no LSP required.

### Code action indicator ("lightbulb")

`lua/lightbulb.lua` shows a 💡 sign in the sign column whenever a code
action is available at the cursor line — native, no nvim-lightbulb plugin.
It checks on `CursorHold` in normal mode (so it follows `updatetime`, 250ms
by default) and only queries the LSP when the line actually has
diagnostics. The sign clears as soon as the cursor moves. Press `<F4>` to
actually run the action.

The indicator only counts `quickfix`/`refactor` actions (requested via
`context.only`, with a client-side fallback filter). Whole-file `source.*`
actions — e.g. pyright/ruff's "organize imports" or "fix all", which
servers offer unconditionally at every cursor position — are deliberately
excluded, otherwise the lightbulb would light up everywhere and stop being
useful. `<F4>` still shows those when you explicitly ask for an action.

## Completion

Native, no completion plugin. On `LspAttach`,
`vim.lsp.completion.enable(..., { autotrigger = true })` turns on an
auto-popping LSP completion menu as you type. Insert-mode `<C-Space>`
opens the menu on demand — LSP completion when a server is attached,
built-in buffer-word completion in files without one. Built-in buffer-word
completion (`<C-n>` / `<C-p>`) is always available as a fallback/complement,
and `<C-x><C-o>` triggers the LSP omnifunc on demand.

Want fancier UX (ghost text, a dedicated docs pane, better fuzzy sorting)?
Add `blink.cmp` to `lua/config/plugins.lua`'s `vim.pack.add` list and wire
it up in `lua/completion.lua` — this native setup is deliberately swappable.

## Finding files

[fzf-lua](https://github.com/ibhagwan/fzf-lua), needs `fzf` + `ripgrep`.
`vim.ui.select` is routed through fzf-lua too, so `<F4>` code actions and
`z=` spell suggestions use the fuzzy UI instead of a numbered list.

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep word under cursor |
| `<leader>ft` | Grep TODO/FIXME/HACK |
| `<leader>fb` | Find buffer |
| `<leader>fo` | Find recent file |
| `<leader>fh` | Find help |
| `<leader>fr` | Resume last picker |
| `<leader>fd` | Buffer diagnostics |
| `<leader>fD` | Workspace diagnostics |
| `<leader>fs` | Document symbols |
| `<leader>fS` | Workspace symbols |
| `<leader>fk` | Keymaps |
| `<leader>fm` | Marks |
| `<leader>f"` | Registers |

## File manager

[oil.nvim](https://github.com/stevearc/oil.nvim). Press `-` to open the
parent directory of the current file as an editable buffer. Edit it like
text (add/rename/delete lines) and `:wq` to apply the changes to disk.
Press `-` again to go up a directory.

## mini.nvim modules

One plugin ([mini.nvim](https://github.com/echasnovski/mini.nvim)) used
as a library (`lua/mini_modules.lua`). Not used: mini.surround,
mini.sessions.

- **mini.pairs** — automatic bracket/quote pairing.
- **mini.statusline** — statusline (with `laststatus=3`): mode, git
  branch, diagnostics count, filename, attached LSP client, fileinfo,
  location.
- **mini.bufremove** — powers `<leader>bd` (delete buffer, keep the
  window layout) and `<leader>bD` (force wipe).
- **mini.bracketed** — `]x` / `[x` navigation for buffers (`]b`), quickfix
  (`]q`), location list (`]l`), windows (`]w`), indents (`]i`) and old
  files (`]o`). Targets that would clash with the textobject maps
  (`]f`/`]c`/`]a`) and diagnostic maps (`]d`/`]e`) are disabled; tabs
  (`]t`/`[t`/`]T`/`[T`) are mapped natively in `lua/config/keymaps.lua`.

## Code movement (treesitter textobjects)

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) +
[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects).

| Key | Action |
|---|---|
| `if` / `af` | Select inner/around function |
| `ic` / `ac` | Select inner/around class |
| `ia` / `aa` | Select inner/around argument |
| `]f` / `[f` | Next/prev function |
| `]c` / `[c` | Next/prev class |
| `]a` / `[a` | Next/prev argument |

Parsers auto-install on first launch for: bash, json, markdown,
markdown_inline, vim, vimdoc, query, python, typescript, tsx, javascript,
lua, go, gomod, gowork, gosum, zig, rust.

## Running tests & lint

`lua/runner.lua` has a small per-filetype table of test/lint commands
(pytest/ruff, go test/golangci-lint, cargo test/clippy, npm test/eslint,
zig build test, busted/luacheck).

| Key | Action |
|---|---|
| `<leader>tt` | Run tests |
| `<leader>tf` | Run tests for the current file |
| `<leader>tl` | Run lint |

**tmux-aware**: if `$TMUX` is set, the first run opens a tmux split below
the current pane; later runs reuse that pane (send `C-c` + the new
command) instead of stacking splits. The pane is recreated if it was
closed. Outside tmux, commands run in a `:terminal` split — press
`<Esc><Esc>` to leave terminal mode.

`<leader>tf` substitutes `{file}` with the current file's path relative
to the project (`pytest {file}` for Python). Languages without a per-file
command fall back to the project-wide test command.

Override the command per-project (see below) or globally per filetype:

```lua
vim.g.test_cmd_python = "pytest -k my_marker"
```

## Markdown

- Soft-wrapped (`wrap` + `linebreak`), spell check on, `conceallevel=2`
  hides markup markers where the treesitter conceal query supports it —
  set in a `FileType` autocmd (`lua/config/autocmds.lua`).
- `<leader>us` toggles spell anywhere; `z=` suggests fixes through the
  fzf-lua UI.
- The `marksman` LSP (if installed) provides heading/link completion,
  references, rename and go-to-definition across notes in a project.

## Project-specific configuration

Neovim's native `'exrc'` option is enabled (with `'secure'`, so you get a
one-time trust prompt). Drop a `.nvim.lua` in a project root and it's
auto-sourced whenever you open Neovim there:

```lua
-- .nvim.lua at the root of a project
vim.b.test_cmd = "pytest -k slow --maxfail=1"
vim.b.test_file_cmd = "pytest {file} -k slow"
vim.b.lint_cmd = "ruff check . --select=ALL"

-- extra LSP root markers, filetype options, etc. also go here
vim.opt_local.shiftwidth = 4
```

## Other defaults worth knowing

- Leader: `<space>`, localleader: `,`
- `relativenumber`, `signcolumn=yes`, `scrolloff=8`, `clipboard=unnamedplus`
- `undofile` (persistent undo), no swapfile/backup
- 2-space indent by default (override per-filetype/project as needed)
- `virtualedit=block` — edit past end-of-line in visual-block mode
- `splitkeep=screen` — no view jump when splits open/close/resize
- `laststatus=3` — single global statusline (mini.statusline)
- `winborder=rounded` — all floating windows (hover, diagnostics,
  completion docs) get a border for free
- `inccommand=split` — live preview for `:s` and friends
- `<C-h/j/k/l>` window navigation (works from terminal mode too)
- `<M-h/j/k/l>` window resize
- `<leader>qq` toggle quickfix window, `<leader>bd`/`<leader>bD` delete
  buffer (keep window / force wipe)
- `<leader>e` show diagnostic, `<leader>q` diagnostics to loclist
