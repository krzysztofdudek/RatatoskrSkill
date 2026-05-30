# RatatoskrSkill

## Purpose

This repository exists solely so the author can develop and version the ratatoskr skill. The canonical file is `skills/ratatoskr/SKILL.md` — people install it as a Claude Code plugin (or copy that one file into their agent's skill dir). Nothing in this repo (CLAUDE.md, CHANGELOG.md, README.md, CI, etc.) may affect the skill's mechanics. All behavior must be self-contained in `skills/ratatoskr/SKILL.md`.

Ratatoskr (formerly "Liaison") is part of the Yggdrasil family of AI-coding-agent correctness tools: it owns the **user → intent** stage — the courier that reads a request back in plain words and holds consent gates before anything ships. Siblings: Urd (intent → code), Yggdrasil (architecture), Researcher.

## Plugin scaffolding

This repo is installable as a Claude Code plugin. Layout mirrors the convention used by sibling repos (e.g. UrdSkill, ResearcherSkill):
- `.claude-plugin/plugin.json` — plugin manifest (name, version, description, keywords). `version` here MUST match the latest released version in `CHANGELOG.md` and is bumped together with it.
- `.claude-plugin/marketplace.json` — single-plugin marketplace listing so the repo can be added via `/plugin install ratatoskr@ratatoskr-marketplace`.
- `skills/ratatoskr/SKILL.md` — the canonical skill body. Editing this file IS editing the skill.

When bumping version, update `.claude-plugin/plugin.json` `version` in lockstep with the CHANGELOG section header.

## Versioning

This project uses [Semantic Versioning](https://semver.org/) and maintains a [CHANGELOG.md](CHANGELOG.md) following the [Keep a Changelog](https://keepachangelog.com/) format.

When the user says "bump version":
1. Move `[Unreleased]` entries in `CHANGELOG.md` into a new version section with today's date
2. Update the comparison links at the bottom of `CHANGELOG.md` (add the new `[X.Y.Z]: …compare/vA.B.C...vX.Y.Z` line and point `[Unreleased]` at the new version)
3. Update `.claude-plugin/plugin.json` `version` to match
4. Commit and tag with `v{version}`
