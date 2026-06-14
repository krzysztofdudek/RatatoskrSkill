#!/bin/bash
# Ratatoskr session-start activation hook (multi-platform).
#
# Purpose: ensure the ratatoskr communication discipline is ACTIVATED from the
# very first turn of every session, without the agent asking or debating whether
# to use it. This hook carries NO behaviour of its own — every rule lives in
# skills/ratatoskr/SKILL.md. It only injects an activation instruction so the
# agent applies the skill automatically, and re-asserts it after a context
# compaction, where it would otherwise be most likely to fade.
#
# One script serves every platform we integrate with; only the JSON envelope
# the host expects on stdout differs. The platform is passed as $1:
#
#   claude | codex   -> {"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":...}}
#                       (Claude Code SessionStart; Codex reuses the same shape and
#                        sets CLAUDE_PLUGIN_ROOT for compatibility)
#   copilot          -> {"additionalContext":...}          (GitHub Copilot CLI sessionStart)
#   cursor           -> {"additional_context":...}         (Cursor sessionStart, snake_case)
#
# Default (no argument) is the Claude/Codex shape, so the existing Claude Code
# wiring keeps working unchanged.
#
# The message is a single line with no double-quotes or backslashes, so it embeds
# into JSON via printf without escaping. Keep it that way (and well under 10 KB,
# Copilot's additionalContext cap) if you edit it.

mode="${1:-claude}"

MESSAGE="Ratatoskr is the mandatory communication discipline for this session. Apply the ratatoskr skill (skills/ratatoskr/SKILL.md) on every user-facing turn, starting with your very first reply, automatically and without asking or discussing whether to use it — also re-apply it after any context compaction. Load the skill body and follow the rules defined there; this message only activates the skill and carries no rules of its own."

case "$mode" in
  copilot)
    printf '{"additionalContext":"%s"}\n' "$MESSAGE"
    ;;
  cursor)
    printf '{"additional_context":"%s"}\n' "$MESSAGE"
    ;;
  *)
    printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$MESSAGE"
    ;;
esac

exit 0
