#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
claude_skills="${HOME}/.claude/skills"
cursor_skills="${HOME}/.cursor/skills"
skills_src="${repo_root}/skills"

# Skills removed from Nexus — drop stale copies and broken symlinks on install.
REMOVED_SKILLS=(
    using-nexus
    memory
    architect
    frontend
    frontend-quality
    code-style
    code-cleanup
    log-writer
    readme-writer
    api-docs-writer
    spec-driven
    subagent-guide
    git-assistant
    structure
    conventions
)

usage() {
    cat <<'EOF'
Install Nexus into local agent harnesses.

Usage:
  ./scripts/install.sh           # install all detected targets
  ./scripts/install.sh cursor    # copy this repo to ~/.cursor/plugins/local/nexus
  ./scripts/install.sh codex     # add this checkout as a local Codex marketplace
  ./scripts/install.sh claude    # ~/.claude/skills/<skill> → this repo skills
  ./scripts/install.sh cleanup   # remove legacy Nexus skill copies/symlinks only
  ./scripts/install.sh --help

Cursor copies the plugin into ~/.cursor/plugins/local (external symlinks are
ignored by Cursor). Claude symlinks integrity-review and project-context.
Re-run install after pulling this repo. Reload the Cursor window after install.
EOF
}

links_to() {
    local dest="$1"
    local source="$2"
    local target

    [[ -L "${dest}" ]] || return 1
    target="$(cd "$(dirname "${dest}")" && cd "$(readlink "${dest}")" && pwd -P)" || return 1
    [[ "${target}" == "$(cd "${source}" && pwd -P)" ]]
}

is_removed_skill() {
    local name="$1"
    local skill

    for skill in "${REMOVED_SKILLS[@]}"; do
        if [[ "${skill}" == "${name}" ]]; then
            return 0
        fi
    done
    return 1
}

is_nexus_skill_path() {
    local target="$1"
    [[ "${target}" == "${skills_src}/"* ]] || [[ "${target}" == *"/nexus/skills/"* ]]
}

remove_skill_dest() {
    local dest="$1"
    local reason="$2"

    if [[ ! -e "${dest}" && ! -L "${dest}" ]]; then
        return 0
    fi

    if [[ -L "${dest}" ]]; then
        rm -f "${dest}"
    else
        rm -rf "${dest}"
    fi
    echo "  ${reason}: ${dest}"
}

cleanup_skill_dest() {
    local dest_root="$1"
    local name="$2"
    local dest="${dest_root}/${name}"

    if [[ ! -e "${dest}" && ! -L "${dest}" ]]; then
        return 0
    fi

    if is_removed_skill "${name}"; then
        if [[ -L "${dest}" ]]; then
            local target
            target="$(readlink "${dest}")"
            if [[ ! -e "${dest}" ]] || is_nexus_skill_path "${target}"; then
                remove_skill_dest "${dest}" "Removed legacy Nexus skill"
            fi
        else
            remove_skill_dest "${dest}" "Removed legacy Nexus skill copy"
        fi
        return 0
    fi

    if [[ "${name}" == "playwright" && -L "${dest}" && ! -e "${dest}" ]]; then
        remove_skill_dest "${dest}" "Removed broken playwright symlink"
        return 0
    fi

    if [[ "${name}" == "integrity-review" || "${name}" == "project-context" ]]; then
        if [[ -L "${dest}" ]]; then
            local target
            target="$(readlink "${dest}")"
            if links_to "${dest}" "${skills_src}/${name}"; then
                return 0
            fi
            if [[ ! -e "${dest}" ]] || is_nexus_skill_path "${target}"; then
                remove_skill_dest "${dest}" "Removed stale Nexus skill symlink"
            fi
        else
            remove_skill_dest "${dest}" "Removed stale Nexus skill copy"
        fi
    fi
}

cleanup_legacy_skills() {
    local dest_root="$1"
    local label="$2"
    local name

    if [[ ! -d "${dest_root}" ]]; then
        echo "  ${label}: ${dest_root} not found; skipped"
        return 0
    fi

    echo "${label} legacy skill cleanup:"
    for name in "${REMOVED_SKILLS[@]}" integrity-review project-context playwright; do
        cleanup_skill_dest "${dest_root}" "${name}"
    done
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
        echo "error: ${dest} already exists and is not this Nexus source; run ./scripts/install.sh cleanup first" >&2
        return 1
    fi

    ln -s "${source}" "${dest}"
    echo "  ${label}: ${dest} -> ${source}"
}

link_skill_tree() {
    local dest_root="$1"
    local label="$2"
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
        dest="${dest_root}/${name}"
        cleanup_skill_dest "${dest_root}" "${name}"
        if [[ -e "${dest}" || -L "${dest}" ]] && ! links_to "${dest}" "${skill_dir%/}"; then
            echo "error: ${dest} already exists and is not this Nexus source; run ./scripts/install.sh cleanup first" >&2
            return 1
        fi
    done

    for skill_dir in "${skills_src}"/*/; do
        [[ -d "${skill_dir}" ]] || continue
        [[ -f "${skill_dir}SKILL.md" ]] || continue
        name="$(basename "${skill_dir}")"
        dest="${dest_root}/${name}"
        link_or_refuse "${dest}" "${skill_dir%/}" "${label}"
    done
}

purge_cursor_managed_skills() {
    local name

    if [[ ! -d "${cursor_skills}" ]]; then
        return 0
    fi

    for name in integrity-review project-context; do
        remove_skill_dest "${cursor_skills}/${name}" "Removed Nexus skill from ~/.cursor/skills (plugin provides skills)"
    done
}

sync_tree_excluding_git() {
    local source="$1"
    local dest="$2"
    local label="$3"

    mkdir -p "${dest}"

    if command -v rsync >/dev/null 2>&1; then
        rsync -a --delete --exclude '.git/' "${source}/" "${dest}/"
    else
        rm -rf "${dest}"
        mkdir -p "${dest}"
        tar -C "${source}" --exclude='.git' -cf - . | tar -C "${dest}" -xf -
    fi

    echo "  ${label}: synced ${dest} from ${source}"
}

install_cursor() {
    purge_cursor_managed_skills
    cleanup_legacy_skills "${cursor_skills}" "Cursor"
    local dest="${HOME}/.cursor/plugins/local/nexus"
    mkdir -p "$(dirname "${dest}")"

    if [[ -L "${dest}" ]]; then
        if links_to "${dest}" "${repo_root}"; then
            echo "  Cursor: replacing legacy symlink with copy (Cursor ignores external symlinks)"
            rm -f "${dest}"
        else
            echo "error: ${dest} is a symlink to an unexpected target; remove it and re-run install" >&2
            return 1
        fi
    elif [[ -e "${dest}" && ! -d "${dest}" ]]; then
        echo "error: ${dest} exists and is not a directory; remove it and re-run install" >&2
        return 1
    fi

    sync_tree_excluding_git "${repo_root}" "${dest}" "Cursor"
    chmod +x "${dest}/hooks/session-start" 2>/dev/null || true
    cat <<'EOF'
  Enable Nexus in Customize (or Settings → Plugins), then Developer: Reload Window.
  Re-run ./scripts/install.sh cursor after pulling this repo.
EOF
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
    cleanup_legacy_skills "${claude_skills}" "Claude"
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

install_cleanup() {
    purge_cursor_managed_skills
    cleanup_legacy_skills "${cursor_skills}" "Cursor"
    cleanup_legacy_skills "${claude_skills}" "Claude"
    echo "Legacy Nexus skill cleanup complete."
}

target="${1:-all}"

case "${target}" in
    -h|--help|help) usage; exit 0 ;;
    cursor) install_cursor ;;
    codex) install_codex ;;
    claude) install_claude ;;
    cleanup) install_cleanup ;;
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
        ;;
    *)
        echo "error: unknown target: ${target}" >&2
        usage >&2
        exit 1
        ;;
esac
