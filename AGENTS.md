# AGENTS.md

## Purpose

This file guides AI coding agents working in `docsmod`.
All work must follow best practices and industry standards where
applicable.

## Scope

This file covers repository-wide expectations for code, docs, and git
work.
It does not replace verified instructions in source files, tooling
configs, or release automation.

## Formatting Rules

- Keep lines at 80 characters or fewer when practical.
- Allow longer lines only for URLs, code blocks, hashes, or commands
  that cannot be wrapped cleanly.

## Quick Start

- Read `README.md` first for project context and setup notes.
- Run `git status --short --branch` before editing to confirm repo
  state.
- Run `git diff --stat` before committing to review the change scope.
- Source `./cbc-module.sh` to load the shell workflow helpers.
- Run `docbuild` from anywhere inside the target repository; it switches
  to the repo root before building.

## Environment

- Git is required for day-to-day work in this repository.
- Python is required for `zensical`; CI installs it with
  `actions/setup-python@v5` using `python-version: 3.x`.
- Node.js with npm is required for Husky and commitlint in
  `package.json` and `package-lock.json`.
- The local docs workflow expects `.venv/bin/activate` to exist and to
  provide `zensical`.
- When `pretty` is not already loaded, `docbuild` auto-loads the sibling
  CBC module at `../prettiermod/cbc-module.sh`.
- `docbuild` uses `gum confirm` for non-repo confirmation when `gum` is
  available and falls back to a shell prompt otherwise.
- Verification needed: pin the exact local Python and Node.js versions.

## Repository Overview

- `.github/`: GitHub Actions workflows including docs deployment.
- `.husky/`: Git hooks for commit-message linting.
- `docs/`: Markdown source files for the generated docs site.
- `site/`: Generated static site output committed for deployment.
- Root files: shell helpers, Zensical config, package metadata, and
  repo policies.

## Tracked Files Overview

- `.github/workflows/docs.yml`: GitHub Pages build and deploy workflow.
- `.gitignore`: Ignore rules for `.cache/`, `node_modules/`, and
  `.venv/`.
- `.husky/commit-msg`: Commit-message hook that runs commitlint.
- `AGENTS.md`: Repository-wide AI agent instructions.
- `cbc-module.sh`: Shell helper definitions including `docbuild`.
- `commitlint.config.cjs`: Conventional Commit lint configuration.
- `docs/AGENTS.md`: Published docs copy of the agent instructions.
- `docs/README.md`: Docs source for the project overview page.
- `done.txt`: Root completed task list placeholder for bootstrap
  workflows.
- `inbox.txt.tuxedo-lock`: Blank Tuxedo inbox lock file beside
  `todo.txt`.
- `LICENSE`: Project license text.
- `package-lock.json`: npm lockfile for Husky and commitlint.
- `package.json`: npm metadata plus Husky and commitlint dependencies.
- `README.md`: Primary repository overview and setup notes.
- `site/`: Generated docs site committed for GitHub Pages deployment.
- `todo.txt`: Root task list placeholder that agents must not touch.
- `zensical.toml`: Zensical site configuration.

## Architecture

- `docs/` holds the Markdown source content.
- `docs/AGENTS.md` is published into the generated site.
- `zensical.toml` configures the Zensical build.
- `cbc-module.sh` wraps the local rebuild, format, commit, and push
  workflow.
- `zensical build --clean` renders the docs into `site/`.
- `.github/workflows/docs.yml` uploads `site/` to GitHub Pages on pushes
  to `main` and `master`.

## Commands

- `git status --short --branch`: show the current branch and worktree
  state.
- `git diff --stat`: review the size and spread of pending changes.
- `git log --oneline --decorate -5`: inspect recent commit history.
- `source ./cbc-module.sh`: load the `docbuild` shell function.
- `docbuild`: if run inside a git repo, switch to the repo root,
  activate `.venv/`, run `zensical build --clean`, run
  `pretty all -d site -- --no-error-on-unmatched-pattern`, commit only
  `site/`, and push the current branch.
- `docbuild`: if run outside a git repo, warn, confirm with `gum` when
  available, fall back to a shell prompt otherwise, and proceed in the
  current directory.
- `source .venv/bin/activate && zensical build --clean`: build the docs
  site manually from the repo root.
- `pretty all -d site -- --no-error-on-unmatched-pattern`: format the
  generated docs output.
- `npm install`: install Husky and commitlint for local git-hook use.

## Testing

- No automated test suite is defined for this repository.
- `npm test` is a placeholder command in `package.json` that exits with
  status 1.
- Do not claim coverage, test gates, or suites that are not verified.

## Linting and Formatting

- `pretty all -d site -- --no-error-on-unmatched-pattern` formats the
  generated docs output.
- `.husky/commit-msg` runs commitlint against the commit message file.
- `commitlint.config.cjs` extends
  `@commitlint/config-conventional`.
- Keep changes minimal and consistent with the existing code style.

## CI and Release

- Use Conventional Commits for every commit. Prefer a scope when it
  adds clarity.
- `.github/workflows/docs.yml` builds the docs with `zensical build
  --clean` and deploys `site/` to GitHub Pages on pushes to `main` and
  `master`.
- Never create, edit, or update `CHANGELOG.md` manually.
- `CHANGELOG.md` is generated and maintained by release tooling only.
- If release automation adds or changes generated files, let the
  tooling own those updates.

## Conventions

- Use small, correct changes that fit the existing project structure.
- Verify behavior from the actual codebase before documenting or
  changing it.
- Agents must never read, create, edit, delete, move, stage, commit, or
  otherwise touch `todo.txt`; only the user may modify it manually.
- Prefer amending small, related corrections into the relevant current
  branch commit instead of creating separate fixup, chore, or cleanup
  commits.
- Keep `AGENTS.md` as instructions, not as a changelog, diary, or work
  log.
- Do not add update notes, status logs, or change summaries to
  `AGENTS.md`.

## Security and Compliance

- Never commit secrets, credentials, tokens, or private keys.
- Verify new dependencies, automation, and scripts before trusting
  them.

## Dependencies and Services

- GitHub Pages hosts the generated `site/` output.
- Zensical is the Python docs generator used by local builds and CI.
- npm dev dependencies provide Husky and commitlint for local git
  workflows.
- No database, queue, or other runtime service is defined in the repo.

## Troubleshooting

- If repo behavior is unclear, inspect tracked files and git history
  before making assumptions.
- If a generated or managed file changes unexpectedly, verify which
  tool owns it before editing.
- If `docbuild` fails immediately, verify the chosen working directory
  contains `.venv/bin/activate`.
- If `zensical` or `pretty` is missing, activate `.venv/` and confirm
  the required commands are installed on `PATH`.
- If `pretty` is still missing, verify the sibling
  `../prettiermod/cbc-module.sh` module exists and can be sourced.
- If you run `docbuild` outside a git repo, it prompts before
  proceeding and skips git commit or push.
- If the commit hook fails, run `npm install` to restore the local
  commitlint tooling.

## Refining Existing AGENTS.md

- Re-check every statement against the repository before keeping it.
- Remove stale, duplicated, or vague guidance.
- Replace placeholders with exact commands, paths, and verified
  workflows.
- Update the tracked file list when tracked files or generated-output
  directories change.
- Keep bullets short and easy for AI agents to scan.
- Preserve this section order when improving the file.

## Maintenance

- After any code, config, or doc change, verify that `AGENTS.md` still
  matches the repository.
- Re-scan tracked files, commands, and deployment workflows during each
  self-audit loop.
- When `AGENTS.md` needs an update, make it in a separate `docs`
  Conventional Commit such as `docs(agents): update repo instructions`.
- Keep `AGENTS.md` out of mixed code commits whenever possible.
- Remove stale instructions instead of appending historical notes.
