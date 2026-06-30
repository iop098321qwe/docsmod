#!/usr/bin/env bash

docbuild() {
  use_gum=0
  module_dir=""
  prettier_module=""
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null || printf '')"
  workdir="${PWD}"
  use_git=0

  module_dir="$(
    CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" 2>/dev/null && pwd
  )" || module_dir=""
  prettier_module="${module_dir}/../prettiermod/cbc-module.sh"

  if command -v gum >/dev/null 2>&1; then
    use_gum=1
  fi

  if [ -n "${repo_root}" ]; then
    workdir="${repo_root}"
    use_git=1
  else
    printf '%s\n' \
      'docbuild: warning: current directory is not in a git repository' >&2

    if command -v gum >/dev/null 2>&1; then
      if ! gum confirm "Proceed in ${workdir}?"; then
        printf 'docbuild: cancelled\n' >&2
        return 0
      fi
    else
      printf 'docbuild: gum is unavailable; proceed in %s? [y/N] ' \
        "${workdir}" >&2

      if ! IFS= read -r reply; then
        return 1
      fi

      case "${reply}" in
        [yY]|[yY][eE][sS])
          ;;
        *)
          printf 'docbuild: cancelled\n' >&2
          return 0
          ;;
      esac
    fi
  fi

  (
    set -eu

    run_git_step() {
      local title="$1"
      shift

      if [ "${use_gum}" -eq 1 ]; then
        gum spin --spinner dot --show-error --title "${title}" -- "$@"
      else
        "$@"
      fi
    }

    cd "${workdir}"

    if [ ! -f ".venv/bin/activate" ]; then
      printf 'docbuild: missing .venv/bin/activate in %s\n' \
        "${workdir}" >&2
      exit 1
    fi

    . ".venv/bin/activate"

    if ! command -v pretty >/dev/null 2>&1 && \
      [ -f "${prettier_module}" ]; then
      . "${prettier_module}"
    fi

    if ! command -v pretty >/dev/null 2>&1; then
      printf '%s\n' \
        'docbuild: missing pretty command; load prettiermod or install pretty' \
        >&2
      exit 1
    fi

    if ! command -v zensical >/dev/null 2>&1; then
      printf '%s\n' 'docbuild: missing zensical command in the active venv' \
        >&2
      exit 1
    fi

    zensical build --clean
    pretty all -d site -- --no-error-on-unmatched-pattern

    if [ "${use_git}" -eq 0 ]; then
      printf '%s\n' \
        'docbuild: not in a git repository; skipped site/ commit and push'
      exit 0
    fi

    if ! run_git_step "Staging site changes..." git add --all -- site/; then
      exit 1
    fi

    if git diff --cached --quiet -- site/; then
      printf 'docbuild: no site/ changes to commit\n'
      exit 0
    fi

    if ! run_git_step "Creating site build commit..." \
      git commit -m "build(site): build zensical docs site" -- site/; then
      exit 1
    fi

    if ! run_git_step "Pushing current branch..." git push; then
      exit 1
    fi
  )
}
