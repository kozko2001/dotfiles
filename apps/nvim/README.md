# nvim-latest

A minimal Neovim **0.12.4** config built on native APIs: `vim.pack` for
plugin management, `vim.lsp.config`/`vim.lsp.enable` for LSP, native LSP
completion, native LSP folding, and `vim.diagnostic.jump`. Only 4 plugins
are used, for things core Neovim genuinely doesn't provide: a fuzzy
finder, a directory-as-buffer file manager, and treesitter (+textobjects).

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

Make sure everything above is on `$PATH`. Check `:checkhealth lsp` inside
Neovim once installed.

## LSP

Configured in `lua/lsp/init.lua` using Neovim's native `vim.lsp.config` /
`vim.lsp.enable` (no nvim-lspconfig, no mason). Every server — `pyright`,
`ruff`, `ts_ls`, `lua_ls`, `gopls`, `rust_analyzer`, `zls` — has its full
`cmd`/`filetypes`/`root_markers` defined explicitly in that file: this
Neovim build doesn't ship pre-filled default configs (no
`$VIMRUNTIME/lsp/*.lua`), only the `vim.lsp.config`/`vim.lsp.enable`
mechanism itself, so nothing would attach without these definitions.

`ruff` runs as a second LSP client alongside `pyright` for Python — it
gives lint diagnostics and formatting without a separate linter plugin.
`rust_analyzer` runs `cargo clippy` on save via its native `check.command`
setting.

Keymaps (buffer-local, set on `LspAttach`):

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | References |
| `gs` | Signature help |
| `K` | Hover |
| `<F2>` | Rename |
| `<F3>` | Format buffer |
| `<F4>` | Code action (normal + visual) |
| `]d` / `[d` | Next/prev diagnostic |
| `]e` / `[e` | Next/prev **error** |
| `<leader>e` | Show diagnostic under cursor |
| `<leader>q` | Diagnostics to location list |

Format-on-save is enabled globally (`lua/config/autocmds.lua`) via
`vim.lsp.buf.format()`; it's a no-op for servers that don't support
formatting.

Folding uses native LSP folding (`vim.lsp.foldexpr`) — no folding plugin.

### Code action indicator ("lightbulb")

`lua/lightbulb.lua` shows a 💡 sign in the sign column whenever a code
action is available at the cursor line — native, no nvim-lightbulb plugin.
It checks on `CursorHold`/`CursorHoldI` (so it follows `updatetime`, 250ms
by default). Press `<F4>` to actually run the action.

The indicator only counts `quickfix`/`refactor` actions (requested via
`context.only`, with a client-side fallback filter). Whole-file `source.*`
actions — e.g. pyright/ruff's "organize imports" or "fix all", which
servers offer unconditionally at every cursor position — are deliberately
excluded, otherwise the lightbulb would light up everywhere and stop being
useful. `<F4>` still shows those when you explicitly ask for an action.

## Completion

Native, no completion plugin. On `LspAttach`,
`vim.lsp.completion.enable(..., { autotrigger = true })` turns on an
auto-popping LSP completion menu as you type. Built-in buffer-word
completion (`<C-n>` / `<C-p>`) is always available as a fallback/complement,
and `<C-x><C-o>` triggers the LSP omnifunc on demand.

Want fancier UX (ghost text, a dedicated docs pane, better fuzzy sorting)?
Add `blink.cmp` to `lua/config/plugins.lua`'s `vim.pack.add` list and wire
it up in `lua/completion.lua` — this native setup is deliberately swappable.

## Finding files

[fzf-lua](https://github.com/ibhagwan/fzf-lua), needs `fzf` + `ripgrep`.

Actio
| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffer |
| `<leader>fh` | Find help |
| `<leader>fr` | Resume last picker |

## File manager

[oil.nvim](https://github.com/stevearc/oil.nvim). Press `-` to open the
parent directory of the current file as an editable buffer. Edit it like
text (add/rename/delete lines) and `:wq` to apply the changes to disk.
Press `-` again to go up a directory.

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

Parsers auto-install on first launch for: bash, json, markdown, vim,
vimdoc, query, python, typescript, tsx, javascript, lua, go, zig, rust.

## Running tests & lint

`lua/runner.lua` has a small per-filetype table of test/lint commands
(pytest/ruff, go test/golangci-lint, cargo test/clippy, npm test/eslint,
zig build test, busted/luacheck).

| Key | Action |
|---|---|
| `<leader>tt` | Run tests |
| `<leader>tl` | Run lint |

**tmux-aware**: if `$TMUX` is set, the command runs in a new tmux split
below the current pane. Outside tmux, it runs in a `:terminal` split.

Override the command per-project (see below) or globally per filetype:

```lua
vim.g.test_cmd_python = "pytest -k my_marker"
```

## Project-specific configuration

Neovim's native `'exrc'` option is enabled (with `'secure'`, so you get a
one-time trust prompt). Drop a `.nvim.lua` in a project root and it's
auto-sourced whenever you open Neovim there:

```lua
-- .nvim.lua at the root of a project
vim.b.test_cmd = "pytest -k slow --maxfail=1"
vim.b.lint_cmd = "ruff check . --select=ALL"

-- extra LSP root markers, filetype options, etc. also go here
vim.opt_local.shiftwidth = 4
```

## Other defaults worth knowing

- Leader: `<space>`, localleader: `,`
- `relativenumber`, `signcolumn=yes`, `scrolloff=8`, `clipboard=unnamedplus`
- `undofile` (persistent undo), no swapfile/backup
- 2-space indent by default (override per-filetype/project as needed)
- `winborder=rounded` — all floating windows (hover, diagnostics,
  completion docs) get a border for free
- `inccommand=split` — live preview for `:s` and friends
- `<C-h/j/k/l>` window navigation
- `<leader>e` show diagnostic, `<leader>q` diagnostics to loclist
