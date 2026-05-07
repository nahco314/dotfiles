# dot_codex

chezmoi source for `~/.codex/` (OpenAI Codex CLI config).

## Known Issue: config.toml mixes global settings and machine-local trust entries

### Problem

`~/.codex/config.toml` serves two distinct purposes:

1. **Global user preferences** (model, personality, etc.) — portable, should be in dotfiles
2. **Project trust entries** (`[projects.*]`) — machine-local, written automatically by Codex when you approve a directory

Codex has no mechanism to split these into separate files. This is a known upstream issue:
- [Issue #14601](https://github.com/openai/codex/issues/14601): "Separate projects.trust_level from config.toml"
- [Issue #11061](https://github.com/openai/codex/issues/11061): "Easily share user preferences across machines"

### Workaround

`modify_config.toml` is a chezmoi [modify script](https://www.chezmoi.io/reference/source-state-attributes/) that:

- Emits the managed global settings (defined at the top of the script)
- Reads the current deployed `config.toml` and preserves any `[projects.*]`, `[plugins.*]`, and `[notice.*]` sections

This means `chezmoi apply` updates the global settings without wiping Codex-managed trust entries.

**To change global Codex settings**, edit `BASE` in `modify_config.toml` and run `chezmoi apply`.
**Do not run `chezmoi re-add ~/.codex/config.toml`** — the modify script is the source of truth.
