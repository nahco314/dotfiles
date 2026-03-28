# dotfiles (chezmoi)

This repository manages machine configuration via chezmoi.
A coding agent reading this file can understand the full picture of the machine setup.

## Repository Structure

```
~/dotfiles/   (= this repository)
├── CLAUDE.md                      # this file
├── dot_config/
│   ├── fish/                      # Fish shell config
│   │   ├── config.fish            # main config (starship/atuin/mise init)
│   │   ├── fish_plugins           # fisher plugin list
│   │   ├── fish_variables         # fish variables (PATH etc.)
│   │   ├── conf.d/                # auto-loaded configs (atuin.env, uv.env)
│   │   ├── completions/           # completion scripts
│   │   └── functions/             # function definitions (fisher etc.)
│   ├── mise/
│   │   └── config.toml            # runtime version management via mise
│   ├── atuin/
│   │   └── private_config.toml    # Atuin shell history config
│   ├── alacritty/
│   │   └── alacritty.toml         # Alacritty terminal config
│   ├── ghostty/
│   │   └── config                 # Ghostty terminal config
│   └── starship.toml              # Starship prompt config
└── scripts/
    ├── detect-new-commands.sh     # new binary detection + atuin reverse lookup
    ├── cargo-tools.txt            # tools managed via cargo install
    ├── uv-tools.txt               # tools managed via uv tool install
    └── bun-packages.txt           # packages managed via bun install -g
```

## Tool Management

| Tools | Managed by | Config |
|---|---|---|
| Node.js, Go, Zig, Bun, npm tools | mise | `dot_config/mise/config.toml` |
| Python tools (ruff, mypy, etc.) | uv tool | `scripts/uv-tools.txt` |
| Rust tools (bat, eza, etc.) | cargo install | `scripts/cargo-tools.txt` |
| JS global packages | bun install -g | `scripts/bun-packages.txt` |
| Rust toolchain | rustup | (outside chezmoi, auto-installed) |
| System packages | apt | (outside chezmoi) |

## Machine Environment

- OS: Ubuntu 22.04
- Shell: Fish
- Terminal: Ghostty (primary), Alacritty
- Prompt: Starship (Gruvbox Dark theme)
- Shell history: Atuin

## Sync Workflow

When the user asks to "sync dotfiles", run the following steps.

### 1. Reflect dotfile changes into chezmoi

```bash
chezmoi status
# re-add any modified managed files
chezmoi re-add <changed files>
```

### 2. Check mise changes

```bash
cat ~/.config/mise/config.toml
# if versions changed, re-add
chezmoi re-add ~/.config/mise/config.toml
```

### 3. Detect new binaries and update manifests

```bash
bash ~/dotfiles/scripts/detect-new-commands.sh
```

Read the generated report and append each new command to the appropriate manifest:
- `cargo install` → `scripts/cargo-tools.txt`
- `uv tool install` → `scripts/uv-tools.txt`
- `bun install -g` → `scripts/bun-packages.txt`
- other (curl|sh etc.) → add as a comment in the relevant manifest

### 4. git commit & push

```bash
cd ~/dotfiles
git add -A
git commit -m "sync: <summary of changes>"
git push
```

## Adding a New File to chezmoi

```bash
chezmoi add ~/.config/<new-file>
cd ~/dotfiles && git add . && git commit -m "add: <file>"
```

## Notes

- Manifests under `scripts/` are **records of what the user actually installed**, not reproduction scripts. The intent matters more than exact reproducibility.
- The snapshot used by `detect-new-commands.sh` is stored at `~/.local/state/dotfiles-tracker/commands-snapshot.txt`.
- atuin reverse lookup is imperfect (failed commands and `--help` invocations may appear). The coding agent should use judgment to filter these out.
- Commit messages should be in English.
