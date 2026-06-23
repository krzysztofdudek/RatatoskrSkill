<img width="1376" height="768" alt="Ratatoskr — the courier between you and your codebase: it reads your request back in your own words and waits for an explicit yes before anything ships" src="https://github.com/user-attachments/assets/5e4562fa-5b42-4d30-bc96-7d7279fdd96d" />

# Ratatoskr

**A translator between you and your codebase.** You can prompt an AI coding agent without knowing what a function is. You ask for something in plain words, the agent turns it into code, and you can't read the diff to check it built what you meant. Ratatoskr sits in the middle. It reads your request back in your own words, so you see what the agent understood before it builds. And it explains what the system does back to you the same way. You check the meaning, not the code.

```
/plugin marketplace add krzysztofdudek/RatatoskrSkill
/plugin install ratatoskr@ratatoskr-marketplace
```

Run both, then `/reload-plugins` to activate it in this session. No config, no API key. The skill engages on its own when a request arrives in product terms, or when an operation could be destructive or reach users other than you.

> MIT licensed · single markdown file · works with any agent that reads skills · part of the [Yggdrasil family](#the-yggdrasil-family) · [full skill body](skills/ratatoskr/SKILL.md)

---

## See it

**You:** *"add 'remember me' to the login page"*

That phrase has two reasonable readings, so the agent — after silently researching the codebase — does not guess. It asks one question first, then proposes.

> **One thing first:** "remember me" can mean two different things. Which do you want?
>
> 1. Keep people signed in between browser sessions, so they don't re-enter their password every time (a checkbox on the login form).
> 2. Just pre-fill the email field next time, but still ask for the password.
>
> I'd default to (1) — flag if not.

**You:** *"yeah, option 1"*

Now it returns the proposal, and only this shape:

> **What I think you're asking for:** A way for people to stay signed in between browser sessions so they don't have to enter their password every time.
>
> **What I would change:** Add a "Keep me signed in" checkbox under the login form. If checked, the sign-in lasts 30 days. If unchecked, the person is signed out when they close the browser.
>
> **What I would NOT change:** How passwords are stored, the "forgot password" flow, or two-factor sign-in.
>
> **Who's affected:** Anyone who signs in.
>
> **Reversibility:** Easy to undo.
>
> **Compliance / data notes:** Stores a longer-lived sign-in cookie on the device. People on shared computers should leave the box unchecked — I'd add a short hint near the checkbox.
>
> **How to check it afterward:** Sign in with the box checked, close the browser, reopen, visit the site — you should still be signed in. Repeat with the box unchecked — you should be signed out.
>
> **Before I do anything: confirm above?**

**Note the last line.** It stops and waits. Nothing runs yet. You see the scope, the blast radius, and the 30-day default it picked *before* a line of code is written. Veto, adjust a bullet, or say go.

Notice what's *not* there: no "this'll take a couple hours," no jargon, no "rolled out a JWT refresh flow." Just what changes, who it touches, and how you check it. Those bold labels are the literal section headers from the skill's proposal template — see [`SKILL.md`](skills/ratatoskr/SKILL.md) (Phase B).

---

## The features are the bans

Most of what makes Ratatoskr useful is what it *refuses* to do:

| It will not | Because |
|---|---|
| Give you a time or effort estimate — ever | Agent "estimates" are pulled from training data of human-team work, with overheads an agent doesn't have. A confabulated "~2 days" carries the authority of "the system said so" and lands in your real budget and roadmap calls. It bans them in every form, even under "just ballpark it." |
| Ship a destructive op on one yes | Permanent or compliance-relevant operations need **two separate yes turns** — first you confirm the proposal, then in a distinct turn it restates the permanence in concrete terms (file counts, what becomes irrecoverable, and dollar/API cost when it can actually compute it) and asks again. A combined "warning + ask" in one turn does not count. |
| Use jargon without translating it | An explicit forbidden list — schema, endpoint, JWT, migration, webhook, RBAC, PII, deploy, and dozens more — each banned unless translated to product words (page, button, account, password, notification) on first use, and not used bare again in the same conversation. So a non-engineer can veto without a dictionary. |
| Bundle scope you didn't confirm | A new idea mid-flight is named as a new ask, not folded in silently. "Quick is a feeling, not a reason." |
| Build a parallel feature when one already exists | If research finds an existing feature that fits, the proposal *opens* with it — you have to name a concrete gap before it proposes building anything new. |
| Over-ceremony a trivial ask | Low-stakes, easy-to-undo, affects-only-you requests collapse to a single paragraph. No compliance theater for a button-color change. |

The skill is also required to name any default it picks out loud — *"I'd default to X — flag if not"* — so you can veto a choice (a 30-day window, a 7-day link) you'd otherwise never see. And it **holds the gate under pressure**: "Just do it" / "I'm the CTO" / "meeting in 8 minutes" don't bypass anything. One polite hold, one closed question, then it ships (non-destructive) or holds the line (destructive). No lecturing, no policy citation.

---

## When it fires

The skill engages when:

- The request comes in product terms instead of a precise spec — `"add a button so people stay logged in"` fires; `"set the session cookie max-age to 30 days"` does not (that's already a spec).
- The operation **deletes or removes** something (`rm`, `delete`, `drop`, `truncate`, `purge`).
- It touches **personal data, payments, retention, audit, or accessibility**.
- It **affects users other than you** — a group, everyone, external recipients.
- There's **no written spec** to follow verbatim.

If it's unsure, it fires anyway. The cost of asking once too often is one turn. The cost of asking too few times is what got shipped.

For pure questions and explanations ("how does X work?", "why does the system do Y?"), it skips the full ceremony but still answers in plain language, asks one decision at a time, and never invents a timeline.

---

## How it works

Five phases run when you ask for a change. Each one closes a specific way agents quietly ship the wrong thing:

| Phase | What happens | What it prevents |
|---|---|---|
| **A. Silent research** | It works out what the request touches and classifies reversibility, blast radius, compliance, and money first — and doesn't make you read the research | Guessing intent from one line of product-speak |
| **B. Structured proposal** | Replies starting with the literal words *"What I think you're asking for:"* and the template above | Building before you've read back what it heard |
| **C. Halt for confirmation** | Stops dead. "Sounds good" on a vague ask isn't consent; it asks one closed question instead | Treating an enthusiastic shrug as a green light |
| **D. Locked-scope build** | Does exactly what was confirmed. Mid-flight "while you're in there" extras are named as new asks, not bundled | Silent scope creep |
| **E. Plain-language close** | *Done. What changed / How to check (steps you run in the product) / To undo / Noticed but did NOT change* | "Done!" with no way for you to verify |

---

## Install

### Claude Code plugin (recommended)

Two slash commands. The first registers this repo as a marketplace; the second installs the plugin from it.

```
/plugin marketplace add krzysztofdudek/RatatoskrSkill
/plugin install ratatoskr@ratatoskr-marketplace
```

Then run `/reload-plugins` to activate it in the current session (or restart Claude Code). No config, no API key.

To upgrade later, refresh the marketplace and reinstall:

```
/plugin marketplace update ratatoskr-marketplace
/plugin install ratatoskr@ratatoskr-marketplace
```

### GitHub Copilot CLI plugin

The same repo is also a [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli) marketplace. Register it, then install the plugin:

```
copilot plugin marketplace add krzysztofdudek/RatatoskrSkill
copilot plugin install ratatoskr@ratatoskr-marketplace
```

To upgrade later: `copilot plugin update ratatoskr`. The same skill body powers both Claude Code and Copilot — nothing changes in how it behaves.

### Codex CLI plugin

Codex reads the same skill. Register this repo as a marketplace, then install:

```
codex plugin marketplace add krzysztofdudek/RatatoskrSkill
codex plugin install ratatoskr@ratatoskr-marketplace
```

To upgrade later: `codex plugin marketplace upgrade ratatoskr-marketplace`. Or drop the single file into `~/.agents/skills/ratatoskr/SKILL.md` (user-level) or `.agents/skills/ratatoskr/SKILL.md` (project-level).

### Cursor plugin

Cursor auto-discovers the skill from the plugin manifest at the repo root. Install it locally:

```
git clone https://github.com/krzysztofdudek/RatatoskrSkill.git
ln -s "$(pwd)/RatatoskrSkill" ~/.cursor/plugins/local/ratatoskr
```

Then reload Cursor (**Developer: Reload Window**). Or drop the single file into `~/.cursor/skills/ratatoskr/SKILL.md` (user-level) or `.cursor/skills/ratatoskr/SKILL.md` (project-level).

### Single-file drop-in (any agent)

The whole skill is one frontmatter-tagged markdown file: [`skills/ratatoskr/SKILL.md`](skills/ratatoskr/SKILL.md). Copy it into your agent's skill directory.

- **Claude Code, user-level:** `~/.claude/skills/ratatoskr/SKILL.md`
- **Claude Code, project-level:** `.claude/skills/ratatoskr/SKILL.md` in your repo
- **Other agents:** wherever your tool reads markdown skills

Nothing else in this repo affects behavior — all of it lives in that one file.

---

## FAQ

<details>
<summary><b>Won't every interaction get long and annoying?</b></summary>

Only when the stakes warrant it. Low-stakes asks — easy to undo, only affects you, no compliance, no money, no hidden branches — collapse to a single paragraph. The full read-back comes out for anything harder. Ceremony is proportional to stakes.
</details>

<details>
<summary><b>Does it work for technical users too?</b></summary>

Yes. The plain-language proposal isn't dumbing things down — it keeps the change in product terms so you can veto it without mentally re-deriving the diff, and the check at the end is something you run in the actual product, not a log grep. The full protocol applies regardless of seniority: "I'm the CTO" and "I know what this is" don't skip a gate, which is the point — that's exactly when a missed irreversible op hurts most.
</details>

<details>
<summary><b>Is one "yes" enough for a destructive operation?</b></summary>

No. Permanent or compliance-relevant operations require two separate exchanges. You confirm the proposal. Then, in a *new* turn, the agent restates the permanence in concrete terms — file counts, what becomes irrecoverable, and cost when it can compute it — and you say yes again. The second turn exists so you get a beat to reconsider after seeing it in plain numbers. A combined "warning + ask" in one turn does not count.
</details>

<details>
<summary><b>What if I pressure the agent to just do it?</b></summary>

On a reversible op, it holds the gate politely and asks once or twice more for the one clear yes; if you keep pushing, it names its default and ships. On something permanent or compliance-relevant, it holds: *"I can't ship this one without the yes — it's permanent."* No lecturing, no policy citation. "The user clearly knows what they want" is the exact rationalization the gate exists to catch.
</details>

<details>
<summary><b>Why no estimates? Isn't a rough number better than nothing?</b></summary>

No — a confabulated number is worse than silence, because it carries the authority of "the system said so" and lands in real budget and prioritization calls. It will instead describe scope, name what's unknown, or honor a time-box *you* set. It can still give you dollar/API-call costs it can actually compute, and a fixed reversibility reading (Easy to undo / Hard to undo / Permanent — that's undo cost, not build time).
</details>

<details>
<summary><b>Does it conflict with Urd, TDD, or debugging?</b></summary>

No — they compose. Urd handles intent-to-code (asking when the spec runs out). Ratatoskr handles user-to-intent — it's upstream. TDD and debugging are about *how* you build or fix. Ratatoskr is about *what* you build and whether you confirmed it.
</details>

<details>
<summary><b>Will it remember our last session?</b></summary>

No, and it says so plainly rather than confabulating. If you reference a prior chat, it admits it carries nothing over and offers to read the code to recover where things stand.
</details>

---

## What it doesn't claim

Ratatoskr is a protocol for *capturing and confirming* intent — not a guarantee the agent read your mind. The read-back exists precisely because it might be wrong, and gives you the chance to catch it. It reduces the risk of irreversible mistakes; it can't eliminate them if the agent fails to recognize a destructive op or can't see the relevant code. It flags compliance surfaces (GDPR, PCI, HIPAA, accessibility) — it does not give legal advice. And it has no memory between chats. It flags; it doesn't promise.

---

## The Yggdrasil family

Four tools, one thesis: **make an AI coding agent prove correctness, stage by stage.** Because "done" isn't done. Each is a checkpoint at a different point in the pipeline, where the agent has to show its work before it continues.

| Tool | Stage | What it makes the agent prove |
|---|---|---|
| **Ratatoskr** (this one) | request → intent | Reads your request back in plain words so you see what it understood before it builds. |
| **[Urd](https://github.com/krzysztofdudek/UrdSkill)** | intent → code | When the spec is ambiguous, it consults the source of truth and asks — it doesn't guess. |
| **[Yggdrasil](https://github.com/krzysztofdudek/Yggdrasil)** | code → architecture | Every change satisfies the rules that govern it, checked before the agent moves on. |
| **[Researcher](https://github.com/krzysztofdudek/ResearcherSkill)** | code → measured result | Point it at a metric and it runs experiments — hypotheses kept and discarded. |

## License

MIT © [Krzysztof Dudek](https://github.com/krzysztofdudek)

---

<div align="center">
  <img src="yggdrasil.svg" alt="Yggdrasil" width="150" />
</div>
