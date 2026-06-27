# RatatoskrSkill

## Purpose

This repository exists solely so the author can develop and version the ratatoskr skill. The canonical file is `skills/ratatoskr/SKILL.md` — people install it as a Claude Code plugin (or copy that one file into their agent's skill dir). Nothing in this repo (CLAUDE.md, CHANGELOG.md, README.md, CI, etc.) may affect the skill's mechanics. All behavior must be self-contained in `skills/ratatoskr/SKILL.md`.

Ratatoskr is part of the Yggdrasil family of AI-coding-agent correctness tools: it is the family's **communication layer** — the courier that keeps the agent talking to the user in plain words, never in code. It governs how the agent communicates on every turn, not how the work is sequenced. Siblings: Urd (intent → code), Yggdrasil (architecture), Researcher.

## Plugin scaffolding

This repo is installable as a Claude Code plugin and as a GitHub Copilot CLI plugin. Layout mirrors the convention used by sibling repos (e.g. UrdSkill, ResearcherSkill):
- `.claude-plugin/plugin.json` — plugin manifest (name, version, description, keywords). `version` here MUST match the latest released version in `CHANGELOG.md` and is bumped together with it.
- `.claude-plugin/marketplace.json` — single-plugin marketplace listing for Claude Code, so the repo can be added via `/plugin install ratatoskr@ratatoskr-marketplace`.
- `.github/plugin/marketplace.json` — single-plugin marketplace listing for GitHub Copilot CLI (Copilot reads this path), so the repo can be added via `copilot plugin marketplace add krzysztofdudek/RatatoskrSkill` then `copilot plugin install ratatoskr@ratatoskr-marketplace`. Mirrors the Claude listing but additionally carries `version`, a `skills` array (`./skills/ratatoskr`), and a `hooks` field pointing at `./hooks/copilot-hooks.json` (the Copilot-format session-start hook). Its plugin `version` MUST be kept in lockstep with `plugin.json`.
- `.codex-plugin/plugin.json` — plugin manifest for OpenAI Codex CLI (Codex reads the plugin manifest only from `.codex-plugin/`). Bundles the skill via `"skills": "./skills/"`; Codex discovers the marketplace from the existing `.claude-plugin/marketplace.json` (its legacy-compatible path), so the repo installs via `codex plugin marketplace add krzysztofdudek/RatatoskrSkill` then `codex plugin install ratatoskr@ratatoskr-marketplace`. Its `version` MUST be kept in lockstep with `plugin.json`. Codex needs no hook wiring of its own: it auto-discovers the default `hooks/hooks.json`, reuses Claude's `SessionStart`/`hookSpecificOutput` schema, and sets `CLAUDE_PLUGIN_ROOT` for compatibility, so the bundled Claude hook fires under Codex unchanged.
- `.cursor-plugin/plugin.json` — plugin manifest for Cursor (single-plugin-at-root: manifest at the repo root, no Cursor marketplace file; components are auto-discovered, so `skills/ratatoskr/` is picked up automatically). Installed locally via `~/.cursor/plugins/local/` or published to the Cursor Marketplace. Carries a `hooks` field pointing at `hooks/cursor-hooks.json` (the Cursor-format session-start hook). Its `version` MUST be kept in lockstep with `plugin.json`.
- `hooks/` — **session-start activation hooks**, one per platform we integrate with. Activation-only: each injects a short instruction so the agent applies the skill from the first turn and re-asserts it after compaction; they encode no rules of their own, so the self-containment rule holds — all behavior still lives in `SKILL.md`. One shared script, `hooks/ratatoskr-session-start.sh`, emits the right stdout envelope based on its `$1` argument (`claude`/`codex` → `hookSpecificOutput.additionalContext`; `copilot` → flat `additionalContext`; `cursor` → snake_case `additional_context`). The per-platform configs: `hooks/hooks.json` (Claude `SessionStart`, also auto-discovered by Codex), `hooks/copilot-hooks.json` (Copilot `sessionStart`, wired via the `.github/plugin/marketplace.json` `hooks` field, uses `${PLUGIN_ROOT}`), and `hooks/cursor-hooks.json` (Cursor `sessionStart`, wired via the `.cursor-plugin/plugin.json` `hooks` field). The message lives once, in the script.
- `skills/ratatoskr/SKILL.md` — the canonical skill body. Editing this file IS editing the skill.

When bumping version, update the `version` in all of `.claude-plugin/plugin.json`, `.github/plugin/marketplace.json` (plugin entry), `.codex-plugin/plugin.json`, and `.cursor-plugin/plugin.json` in lockstep with the CHANGELOG section header.

## Versioning

This project uses [Semantic Versioning](https://semver.org/) and maintains a [CHANGELOG.md](CHANGELOG.md) following the [Keep a Changelog](https://keepachangelog.com/) format.

When the user says "bump version":
1. Move `[Unreleased]` entries in `CHANGELOG.md` into a new version section with today's date
2. Update the comparison links at the bottom of `CHANGELOG.md` (add the new `[X.Y.Z]: …compare/vA.B.C...vX.Y.Z` line and point `[Unreleased]` at the new version)
3. Update the `version` in `.claude-plugin/plugin.json`, `.github/plugin/marketplace.json` (plugin entry), `.codex-plugin/plugin.json`, and `.cursor-plugin/plugin.json` to match
4. Commit and tag with `v{version}`
