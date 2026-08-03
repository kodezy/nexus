#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
claude_skills="${HOME}/.claude/skills"
skills_src="${repo_root}/skills"
hermes_soul_src="${repo_root}/examples/hermes/soul.md"
hermes_profile="${NEXUS_HERMES_PROFILE:-nexus}"

usage() {
    cat <<'EOF'
Install Nexus into local agent harnesses.

Usage:
  ./scripts/install.sh           # install all detected targets
  ./scripts/install.sh cursor    # ~/.cursor/plugins/local/nexus → this repo
  ./scripts/install.sh codex     # add this checkout as a local Codex marketplace
  ./scripts/install.sh claude    # ~/.claude/skills/<skill> → this repo skills
  ./scripts/install.sh hermes    # Hermes profile (default: nexus) skills + SOUL
  ./scripts/install.sh --help

Hermes profile name: set NEXUS_HERMES_PROFILE (default nexus). Use default for ~/.hermes.

Cursor and Claude skill symlinks update live. Reopen the relevant host after
changing a plugin manifest or hook.
EOF
}

skill_excluded() {
    local name="$1"
    local skip
    shift
    for skip in "$@"; do
        [[ "${name}" == "${skip}" ]] && return 0
    done
    return 1
}

links_to() {
    local dest="$1"
    local source="$2"
    local target

    [[ -L "${dest}" ]] || return 1
    target="$(cd "$(dirname "${dest}")" && cd "$(readlink "${dest}")" && pwd -P)" || return 1
    [[ "${target}" == "$(cd "${source}" && pwd -P)" ]]
}

link_or_refuse() {
    local dest="$1"
    local source="$2"
    local label="$3"

    if [[ -e "${dest}" || -L "${dest}" ]]; then
        if links_to "${dest}" "${source}"; then
            echo "  ${label}: already linked ${dest} -> ${source}"
            return 0
        fi
        echo "error: ${dest} already exists and is not this Nexus source; remove or rename it manually first" >&2
        return 1
    fi

    ln -s "${source}" "${dest}"
    echo "  ${label}: ${dest} -> ${source}"
}

link_skill_tree() {
    local dest_root="$1"
    local label="$2"
    shift 2
    local skill_dir name dest

    mkdir -p "${dest_root}"

    if [[ ! -d "${skills_src}" ]]; then
        echo "error: skills source not found: ${skills_src}" >&2
        return 1
    fi

    for skill_dir in "${skills_src}"/*/; do
        [[ -d "${skill_dir}" ]] || continue
        [[ -f "${skill_dir}SKILL.md" ]] || continue
        name="$(basename "${skill_dir}")"
        if skill_excluded "${name}" "$@"; then
            continue
        fi
        dest="${dest_root}/${name}"
        if [[ -e "${dest}" || -L "${dest}" ]] && ! links_to "${dest}" "${skill_dir%/}"; then
            echo "error: ${dest} already exists and is not this Nexus source; remove or rename it manually first" >&2
            return 1
        fi
    done

    for skill_dir in "${skills_src}"/*/; do
        [[ -d "${skill_dir}" ]] || continue
        [[ -f "${skill_dir}SKILL.md" ]] || continue
        name="$(basename "${skill_dir}")"
        if skill_excluded "${name}" "$@"; then
            echo "  ${label}: skip ${name}"
            continue
        fi
        dest="${dest_root}/${name}"

        link_or_refuse "${dest}" "${skill_dir%/}" "${label}"
    done
}

hermes_home_for_profile() {
    local profile="$1"
    if [[ "${profile}" == "default" ]]; then
        echo "${HERMES_HOME:-${HOME}/.hermes}"
    else
        echo "${HOME}/.hermes/profiles/${profile}"
    fi
}

ensure_hermes_profile() {
    local profile="$1"
    local hermes_home="$2"

    if [[ -d "${hermes_home}" ]]; then
        return 0
    fi
    if [[ "${profile}" == "default" ]]; then
        echo "error: Hermes home not found: ${hermes_home}" >&2
        return 1
    fi
    hermes profile create "${profile}" --no-skills \
        --description "Production coding with the Nexus harness"
}

install_hermes_soul() {
    local hermes_home="$1"
    local target="${hermes_home}/SOUL.md"
    if [[ ! -f "${hermes_soul_src}" ]]; then
        echo "error: Hermes SOUL template not found: ${hermes_soul_src}" >&2
        return 1
    fi
    if [[ -f "${target}" ]] && ! grep -Fqx "# Nexus" "${target}"; then
        echo "error: ${target} exists and is not Nexus-managed; refusing to overwrite it" >&2
        return 1
    fi
    cp "${hermes_soul_src}" "${target}"
    echo "  Hermes: ${target} <- examples/hermes/soul.md"
}

install_hermes_write_approval() {
    local profile="$1"
    if [[ "${profile}" == "default" ]]; then
        hermes config set skills.write_approval true
    else
        hermes -p "${profile}" config set skills.write_approval true
    fi
    echo "  Hermes: skills.write_approval=true"
}

install_cursor() {
    local dest="${HOME}/.cursor/plugins/local/nexus"
    mkdir -p "$(dirname "${dest}")"
    link_or_refuse "${dest}" "${repo_root}" "Cursor"
    chmod +x "${repo_root}/hooks/session-start" 2>/dev/null || true
    echo "  Live. Reload Window after hook/manifest changes."
}

install_codex() {
    if ! command -v codex >/dev/null 2>&1; then
        echo "error: codex CLI not found; install Codex first" >&2
        return 1
    fi

    codex plugin marketplace add "${repo_root}"
    cat <<'EOF'

  Open /plugins, install Nexus, then review and trust its SessionStart hook in /hooks.
  Start a new session after installing or changing the plugin.
EOF
}

install_claude() {
    echo "Claude Code skills (symlink, live):"
    link_skill_tree "${claude_skills}" "Claude"
    cat <<EOF

  Optional plugin install (hooks + compact core policy):
    /plugin marketplace add ${repo_root}
    /plugin install nexus@nexus

  Skills above already track this checkout without that step.
  New session after hook/manifest changes if using the plugin.
EOF
}

install_hermes() {
    local profile="${hermes_profile}"
    local hermes_home

    if ! command -v hermes >/dev/null 2>&1; then
        echo "error: hermes CLI not found; install Hermes Agent first" >&2
        return 1
    fi

    hermes_home="$(hermes_home_for_profile "${profile}")"
    ensure_hermes_profile "${profile}" "${hermes_home}"

    echo "Hermes profile '${profile}' skills (symlink, live):"
    # Hermes reserves /memory for built-in memory approval — skip Nexus memory skill.
    link_skill_tree "${hermes_home}/skills" "Hermes" memory
    install_hermes_soul "${hermes_home}"
    install_hermes_write_approval "${profile}"

    if [[ "${profile}" == "default" ]]; then
        echo "  Start: hermes chat"
    else
        echo "  Start: hermes -p ${profile} chat   (or: ${profile} chat)"
    fi
    echo "  Re-run install after pull; new Hermes session picks up SOUL/skill changes."
}

target="${1:-all}"

case "${target}" in
    -h|--help|help) usage; exit 0 ;;
    cursor) install_cursor ;;
    codex) install_codex ;;
    claude) install_claude ;;
    hermes) install_hermes ;;
    all)
        if [[ -d "${HOME}/.cursor" ]] || command -v cursor >/dev/null 2>&1; then
            install_cursor
        else
            echo "Cursor: skipped (not detected)"
        fi
        if command -v codex >/dev/null 2>&1; then
            install_codex
        else
            echo "Codex: skipped (not detected)"
        fi
        if [[ -d "${HOME}/.claude" ]] || command -v claude >/dev/null 2>&1; then
            install_claude
        else
            echo "Claude: skipped (not detected)"
        fi
        if command -v hermes >/dev/null 2>&1; then
            install_hermes
        else
            echo "Hermes: skipped (not detected)"
        fi
        ;;
    *)
        echo "error: unknown target: ${target}" >&2
        usage >&2
        exit 1
        ;;
esac
