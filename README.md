# academic CLI

The `academic` CLI is a research workflow tool for managing projects, references, notes, experiments, datasets, paper builds, and submission packaging from one command surface.

It is designed around reproducibility and low-friction daily use:

- Scaffold consistent project structures.
- Keep notes, references, and experiments organized.
- Build LaTeX papers with sensible fallbacks.
- Track dataset checksums and environment snapshots.
- Package anonymized or arXiv-ready outputs.
- Use the same capabilities through CLI, TUI, and local web UI.

## Table Of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Authentication (Browser Login)](#authentication-browser-login)
- [How Project Detection Works](#how-project-detection-works)
- [User Configuration](#user-configuration)
- [Environment Variables](#environment-variables)
- [Command Reference](#command-reference)
- [Common Workflows](#common-workflows)
- [Troubleshooting](#troubleshooting)
- [Development](#development)

## Installation

### Homebrew (recommended)

```bash
brew tap academic/tap
brew install academic
academic version
```


## Quick Start

```bash
# 1) Set your defaults once
academic config set author "Jane Doe"
academic config set email "jane@example.edu"
academic config set license "MIT"

# 2) Create a project
academic init my-paper --template paper --examples
cd my-paper

# 3) Verify local setup
academic doctor

# 4) Start writing and collecting references
academic note today
academic ref search diffusion models
academic ref add 10.1145/3292500.3330701

# 5) Run an experiment and capture environment
academic exp new baseline
academic exp run
academic env snapshot

# 6) Build and package your paper
academic paper build
academic share arxiv
```

## Authentication (Browser Login)

`academic login` implements a browser callback flow:

1. Starts a temporary local callback server on `127.0.0.1` with a random port.
2. Generates a one-time `state` token.
3. Builds a login URL (default: `https://academic.io/login`) with callback and state parameters.
4. Opens your browser unless `--no-open` is set.
5. Waits for callback query params (`token`, `state`, optional `email`, optional `expires_at`).
6. Validates state, then saves a local auth session file.

Commands:

```bash
academic login
academic login --no-open
academic login --timeout 5m
academic login --login-url "https://academic.io/login"

academic logout
```

Session storage defaults to:

- `~/.config/academic/auth.yaml` (or `$XDG_CONFIG_HOME/academic/auth.yaml`)
- Override with `ACADEMIC_AUTH_PATH`

Notes:

- `logout` removes the session file.
- If login times out, rerun with a higher `--timeout`.

## How Project Detection Works

Many commands (notes, refs, data, experiments, paper, sharing) require being inside an academic project.

Project root detection:

- The CLI walks upward from current directory.
- First directory containing `.academic/` is treated as project root.
- Local metadata is read from `.academic/config.yaml`.

If no root is found, commands that need project context return:

`not inside an academic project (no .academic/config.yaml found)`

## User Configuration

User config file path:

1. `ACADEMIC_CONFIG` (if set)
2. `$XDG_CONFIG_HOME/academic/config.yaml`
3. `~/.config/academic/config.yaml`

Supported keys:

- `author`
- `email`
- `orcid`
- `license`
- `editor`

Examples:

```bash
academic config list
academic config path

academic config set author "Jane Doe"
academic config set editor "code -w"
academic config get author
academic config unset orcid
```

How config is used:

- `init` uses configured `author`, `email`, and `license` defaults.
- `note` uses configured `editor` if `ACADEMIC_EDITOR` is not set.

## Environment Variables

| Variable | Purpose | Default |
|---|---|---|
| `ACADEMIC_CONFIG` | Absolute path for user config file | `$XDG_CONFIG_HOME/academic/config.yaml` or `~/.config/academic/config.yaml` |
| `ACADEMIC_AUTH_PATH` | Absolute path for auth session YAML | `$XDG_CONFIG_HOME/academic/auth.yaml` or `~/.config/academic/auth.yaml` |
| `ACADEMIC_LOGIN_URL` | Default login page URL for `academic login` | `https://academic.io/login` |
| `ACADEMIC_EDITOR` | Preferred editor command for note open actions | Falls back to config key `editor`, then `VISUAL`, then `EDITOR` |
| `VISUAL` | Editor fallback | none |
| `EDITOR` | Editor fallback | none |
| `ACADEMIC_NO_AUTO_INSTALL` | Disable automatic Tectonic download in `paper build` | auto-install enabled |
| `ACADEMIC_CACHE_DIR` | Custom cache root; used for engine cache (`engines/`) | system user cache directory |
| `XDG_CONFIG_HOME` | XDG config root for config/auth files | `~/.config` |

## Command Reference

### Top-Level Command Tree

```text
academic
  anonymize
  citation
    init
    update
  completion
  config
    get
    list
    path
    set
    unset
  data
    fetch
    list
    verify
  doctor
  env
    snapshot
  exp
    diff
    list
    new
    run
  greet
  init
  login
  logout
  note
    link
    list
    new
    search
    today
  paper
    build
    clean
    figures
      sync
    new
    wordcount
  ref
    add
    check
    cite
    export
    list
    search
  share
    arxiv
  tui
  update
  version
  web
```

### Project Setup And Health

#### `academic init <project-name>`

Scaffolds a project from built-in templates.

Templates:

- `paper` (default): LaTeX-oriented research layout.
- `minimal`: lightweight Markdown-oriented layout.

Important flags:

- `-t, --template`: template name.
- `-d, --dir`: target directory (default `./<project-name>`).
- `--author`, `--email`, `-l, --license`.
- `--examples`: include starter examples.
- `--no-git`: skip `git init`.
- `--force`: allow non-empty target directory.
- `--list-templates`: print template names and exit.

Examples:

```bash
academic init thesis-2026 --template paper --author "Jane Doe" --license MIT
academic init notes --template minimal --no-git
academic init my-study --examples
```

#### `academic doctor`

Checks external tools and project structure.

- Required tool: `git`.
- Optional tools checked: `go`, LaTeX engines, `biber`, `pandoc`, `python`, `R`, `jupyter`, `texcount`.
- Project checks include presence/type of common files and directories.
- If bibliography exists, performs parse + structural validation.

Flags:

- `--tools-only`
- `--project-only`

#### `academic config`

Subcommands:

- `config get <key>`
- `config set <key> <value>`
- `config unset <key>`
- `config list`
- `config path`

### Authentication

#### `academic login`

Flags:

- `--login-url` (default from `ACADEMIC_LOGIN_URL` or `https://academic.io/login`)
- `--timeout` (default `3m`)
- `--no-open`

Behavior details:

- Binds callback on `127.0.0.1:0`.
- Saves YAML session with token, email, and timestamps.

#### `academic logout`

- Removes the saved session file.
- Safe to run when no session exists.

### Notes

#### `academic note today`

- Creates or opens `notes/daily/YYYY-MM-DD.md`.
- Writes frontmatter on first creation.
- Opens editor unless `--no-edit`.

#### `academic note new <title>`

- Creates `notes/YYYY-MM-DD-<slug>.md`.
- Supports repeatable tags via `-t, --tag`.
- Opens editor unless `--no-edit`.

#### `academic note list`

- Recursively lists Markdown files under `notes/`.

#### `academic note search <query>`

- Case-insensitive substring search across notes.
- Output format: `path:line: content`.
- Optional filters:
  - `-t, --tag` (frontmatter line contains any tag)
  - `-C, --context <n>`

#### `academic note link <from> <to>`

- Resolves note IDs via path/date/slug matching.
- Appends wiki link `[[target-slug]]` under `## Links`.
- Deduplicates existing link.
- `-b, --bidirectional` adds reverse link.

Editor resolution order for note commands:

1. `ACADEMIC_EDITOR`
2. `config.editor`
3. `VISUAL`
4. `EDITOR`

### References

#### `academic ref add <identifier>`

Accepts:

- DOI (`10.xxxx/...`, `doi:...`, or DOI URL)
- arXiv ID (`1706.03762`, `arXiv:...`, arXiv abs URL)
- ISBN (`isbn:...` or compact/hyphenated)

Behavior:

- Fetches entry metadata from Crossref, arXiv, or Open Library.
- Appends to bibliography file.
- Refuses duplicate citation key.

Flags:

- `--bib <path>`
- `--print` (stdout only)

#### `academic ref check`

Checks:

- Duplicate keys.
- Missing required fields by entry type.
- Optional DOI reachability when `--doi` is set.

Flags:

- `--bib <path>`
- `--doi`

#### `academic ref list`

- Prints key, entry type, and title summary.

#### `academic ref cite <key>`

- Prints best-effort APA-style citation for one key.

#### `academic ref search <query>`

- Queries Crossref works API.
- Prints DOI, year, authors, and title.

Flag:

- `-n, --limit` (default `10`)

#### `academic ref export [keys...]`

- Export selected keys or all entries (`--all`).
- Supported formats: `bibtex`, `csl-json`, `ris`.
- Writes to stdout or `--out` file.

Flags:

- `-f, --format` (default `bibtex`)
- `--all`
- `-o, --out`
- `--bib`

Bibliography path resolution:

- If `--bib` is provided, relative path is resolved from project root when possible.
- Otherwise first existing file is chosen from:
  - `paper/refs.bib`
  - `refs.bib`
  - `references.bib`
  - `bibliography.bib`
- If none exists, default target becomes `paper/refs.bib`.

### Data

#### `academic data fetch [url]`

Downloads data and records manifest metadata.

Capabilities:

- Direct URL fetch.
- DOI-based fetch via DataCite with `--doi`.
- SHA-256 computation and file size capture.
- Upsert to `data/manifest.json`.

Flags:

- `--doi <doi>`
- `--to <project-relative-path>`
- `--force`

#### `academic data list`

- Lists manifest entries (`sha-prefix size path`).

#### `academic data verify`

- Re-hashes files listed in manifest.
- Reports `OK`, `MISSING`, or checksum mismatch.
- Returns non-zero exit on any failure.

### Experiments And Reproducibility

#### `academic exp new <name>`

Creates `experiments/YYYY-MM-DD-<slug>/` with:

- `config.yaml`
- `NOTES.md`
- `run.sh` (executable)
- `results/.gitkeep`
- `.gitignore` scoped to experiment results

Includes current git SHA when available.

#### `academic exp list`

- Lists experiment directories sorted by name.

#### `academic exp run [name]`

- Runs chosen experiment `run.sh`.
- If omitted, runs latest experiment.
- Captures stdout/stderr to `results/run.log`.
- Writes runtime metadata to `results/env.txt`.

#### `academic exp diff <a> <b>`

- Compares:
  - `config.yaml`
  - `results/env.txt`
  - file sets and sizes under each `results/`

#### `academic env snapshot [experiment]`

Captures environment details into `results/env.txt`, including:

- timestamp, OS, architecture
- git SHA/branch/dirty state
- tool versions (if present)
- `pip freeze`
- `go.mod`
- `requirements.txt`
- truncated `renv.lock` when present

Flag:

- `--stdout` to print instead of writing file

### Paper Authoring

#### `academic paper build`

Build order:

1. `latexmk -pdf`
2. `tectonic`
3. `pdflatex`

If no builder is found:

- Auto-installs a cached Tectonic binary by default.
- Disable auto-install with `--no-auto-install` or `ACADEMIC_NO_AUTO_INSTALL=1`.

Flags:

- `--main <path>` (default lookup starts with `paper/main.tex`)
- `--no-auto-install`

#### `academic paper clean`

- Removes common LaTeX artifacts (`.aux`, `.bbl`, `.log`, etc.).

Flag:

- `--main`

#### `academic paper wordcount`

- Uses `texcount` when available.
- Falls back to approximate parser over included TeX files.

Flag:

- `--main`

#### `academic paper figures sync`

- Mirrors figure assets from source to destination.
- Uses SHA-256 to avoid copying unchanged files.
- Optional delete of destination files absent in source.

Flags:

- `--src` (default `results/figures`)
- `--dst` (default `paper/figures`)
- `--delete`
- `--dry-run`

#### `academic paper new <name>`

Scaffolds standalone paper directory templates:

- `ieee`
- `acm`
- `elsevier`
- `springer`
- `thesis`

Flags:

- `-t, --template` (default `ieee`)
- `-d, --dir` (default `paper-<name>`)
- `--force`

Generated files include `main.tex`, `refs.bib`, `README.md`, `sections/`, and `figures/`.

### Sharing And Metadata

#### `academic citation init`

- Creates `CITATION.cff` from project metadata.
- Uses best-effort author name split into `given-names` and `family-names`.

Flag:

- `--force`

#### `academic citation update`

- Rewrites citation metadata and updates release date.

#### `academic anonymize`

For blind submission, rewrites LaTeX content by removing or replacing common identity-bearing fields:

- `\author{}`
- `\affil{}` / `\affiliation{}` / `\institute{}`
- `\thanks{}`
- `\email{}` / `\orcid{}`
- `\address{}`
- acknowledgements sections/environments

Flags:

- `--main`
- `--out`
- `--in-place`

Default output is `<main>.anon.tex`.

#### `academic share arxiv`

Builds a `.tar.gz` containing paper source and needed assets while skipping PDF/build artifacts.

Flags:

- `--main`
- `--out` (default `dist/arxiv-YYYYMMDD.tar.gz`)

### Interactive Interfaces

#### `academic tui`

- Bubble Tea terminal UI.
- Presents common actions for project, refs, notes, experiments, data, paper, and sharing.
- Executes the same `academic` binary commands under the hood.

#### `academic web`

- Starts local web UI server (default `127.0.0.1:8765`).
- Scans root directory for projects (`.academic/` folders).
- Exposes command execution, file tree browsing, and basic file editing.

Flags:

- `--addr <host:port>`
- `--root <directory>`

### Utility Commands

#### `academic completion [bash|zsh|fish|powershell]`

Generate completion scripts.

Examples:

```bash
# bash
source <(academic completion bash)

# zsh
source <(academic completion zsh)

# fish
academic completion fish | source
```

#### `academic update`

- Self-updates from GitHub releases.
- Works only for non-dev builds (version must not be `dev`).

#### `academic version`

- Prints CLI version.

#### `academic greet <name>`

- Simple greeting command.
- `-u, --upper` for uppercase output.

## Common Workflows

### Workflow: New Paper Project

```bash
academic config set author "Jane Doe"
academic config set email "jane@example.edu"

academic init causality-paper --template paper --examples
cd causality-paper

academic note today
academic ref add 10.1038/nature14539
academic paper build
```

### Workflow: Data Integrity + Experiment Reproducibility

```bash
academic data fetch --doi 10.5281/zenodo.1234567
academic data verify

academic exp new baseline
academic exp run baseline
academic env snapshot baseline
academic exp diff baseline baseline
```

### Workflow: Blind Submission + arXiv Package

```bash
academic anonymize --main paper/main.tex --out paper/main.blind.tex
academic share arxiv --main paper/main.tex
academic citation update
```

## Troubleshooting

### "not inside an academic project"

- Run `academic init <name>` first, or
- `cd` into a folder containing `.academic/config.yaml`.

### `paper build` cannot find a LaTeX engine

- Allow auto-install (default), or
- Install `latexmk`, `tectonic`, or `pdflatex` manually, or
- Pass `--no-auto-install` only if you already have a local engine.

### `login` times out

- Increase timeout: `academic login --timeout 10m`.
- Use `--no-open` and open printed URL manually.

### `ref add` duplicate key error

- Existing key already in bibliography.
- Use `ref list`/`ref check` to inspect current entries and resolve conflicts.

### `data verify` reports mismatch

- File contents changed since original fetch.
- Re-fetch with `--force` or intentionally update manifest by fetching again.

### Notes do not open in editor

- Set one of:
  - `ACADEMIC_EDITOR`
  - `academic config set editor "<command>"`
  - `VISUAL` / `EDITOR`
- Use `--no-edit` if you only want file creation.

## Development

### Build And Test

```bash
go build ./...
go test -race ./...
```

### Run Locally

```bash
go run . --help
go run . init demo
```

### Release Notes

- CI builds multi-platform artifacts on release publication.
- Homebrew formula template is in `academic.rb`.
- `update` relies on versioned (non-dev) binaries.

## Notes

- `academic` is intentionally command-first. TUI and web UI are wrappers over the same command actions.
- For command-level details, run `academic <command> --help`.
