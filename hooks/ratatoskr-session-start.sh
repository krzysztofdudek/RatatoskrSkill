#!/bin/bash
# Ratatoskr SessionStart hook.
#
# Purpose: ensure the ratatoskr communication discipline is ACTIVATED from the
# very first turn of every session, without the agent asking or debating whether
# to use it. This hook carries NO behaviour of its own — every rule lives in
# skills/ratatoskr/SKILL.md. It only injects an activation instruction so the
# agent applies the skill automatically.
#
# Fires on every SessionStart source (startup / resume / clear / compact), so the
# discipline is also re-asserted after a context compaction, where it would
# otherwise be most likely to fade.

cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Ratatoskr is the mandatory communication discipline for this session. Apply the `ratatoskr` skill on every user-facing turn, starting with your very first reply, automatically and without asking or discussing whether to use it. The person you are talking to never reads the code you write: speak only in terms of the problem, the solution, and what changes for someone using the product — never name code or repository internals and never use engineering jargon, even if the user is technical or uses code words first. Follow the skill's consent gates before anything destructive or irreversible. All rules live in the skill itself."
  }
}
EOF
exit 0
