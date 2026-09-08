<img width="1376" height="768" alt="Ratatoskr — the courier between you and your codebase: it makes the agent talk to you in plain language you can act on, never in code" src="https://github.com/user-attachments/assets/5e4562fa-5b42-4d30-bc96-7d7279fdd96d" />

# Ratatoskr

**A translator between you and your codebase.** You can prompt an AI coding agent without knowing what a function is. You ask for something in plain words, the agent turns it into code, and you can't read the diff to check it built what you meant. Ratatoskr sits in the middle — not in *how* the agent works, but in *how it talks to you*. It keeps the conversation in your own words: plain language, never code or jargon, no invented timelines, no process theater, a sharp question when your ask is unclear, and one clear yes before anything that can't be undone. You follow the meaning, not the code.

```
/plugin marketplace add krzysztofdudek/RatatoskrSkill
/plugin install ratatoskr@ratatoskr-marketplace
```

Run both, then `/reload-plugins` to activate it in this session. No config, no API key. It's a standing discipline: it applies to every user-facing turn about your codebase or product — change requests and plain questions alike — and it only governs what the agent says, never how it sequences the work.

> MIT licensed · single markdown file · works with any agent that reads skills · part of the [Yggdrasil family](#the-yggdrasil-family) · [full skill body](skills/ratatoskr/SKILL.md)

---

## See it

**You:** *"add 'remember me' to the login page"*

That phrase has two reasonable readings, so the agent doesn't guess. It asks one question first.

> **One thing first:** "remember me" can mean two different things. Which do you want?
>
> 1. Keep people signed in between browser sessions, so they don't re-enter their password every time (a checkbox on the login form).
> 2. Just pre-fill the email field next time, but still ask for the password.
>
> I'd default to (1) — flag if not.

**You:** *"yeah, option 1"*

Now it reads the request back in plain words — what changes, who it touches, and how you'll check it — before it gets to work:

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

Notice what's *not* there: no "this'll take a couple hours," no jargon, no "rolled out a JWT refresh flow." Just what changes for the people using the product, who it touches, the 30-day default it picked *out loud* so you can veto it, and how you check it yourself. That's the whole job — keep the conversation in terms you can act on. *How* it then builds the change is up to whatever workflow you run.

---

## The features are the bans

Most of what makes Ratatoskr useful is what it *refuses* to say:

| It will not | Because |
|---|---|
| Give you a time or effort estimate — ever | Agent "estimates" are pulled from training data of human-team work, with overheads an agent doesn't have. A confabulated "~2 days" carries the authority of "the system said so" and lands in your real budget and roadmap calls. It bans them in every form, even under "just ballpark it." |
| Speak in code | An agent never makes you hear engineering — schema, endpoint, JWT, migration, webhook, the users table — even if you used the word first or said you're technical. It says the product behavior instead (page, button, account, "gone for good and can't be brought back") so a non-engineer can follow and veto without a dictionary. |
| Run something irreversible without a clear heads-up | Before anything permanent — deleting accounts, purging data — it names exactly what is lost in plain, concrete terms ("once this runs, all 240 of those accounts are gone for good and can't be brought back") and gets one clear yes first. |
| Narrate its own machinery | No "invoking the proposal phase," no naming the skill, tool, or process. It says the real thing in plain words and does the internal work silently. |
| Hide a default it picked | It names any default out loud — *"I'd default to a 30-day window — flag if not"* — so you can veto a choice you'd otherwise never see. |
| Over-ceremony a trivial ask | Low-stakes, easy-to-undo, affects-only-you requests stay short. No compliance theater for a button-color change. |

And it **holds the line under pressure**: "Just do it" / "I'm the CTO" / "meeting in 8 minutes" don't buy a guessed number, and they don't skip the one clear yes before something irreversible. One polite hold, no lecturing, no policy citation.

---

## When it applies

Always — on every user-facing turn about your codebase or product, the moment it loads. It's a standing way of talking, not a tool tied to one kind of task:

- A change request in product terms — *"add a button so people stay logged in"* — gets read back in plain words.
- A plain question — *"how does the password reset flow work?"* — gets answered in plain language, one decision at a time, with no invented timeline.
- A pure internal rename, a spec to implement verbatim, an already-locked fix — it still talks to you in plain language; it just keeps the turn light.

What it does **not** do is tell you how to sequence or run the work. Brainstorm, write a spec, do TDD, run any workflow you like — Ratatoskr only governs how the agent talks to you while you do.

---

## What it does

A handful of rules, all about communication — not methodology:

| Rule | What it means |
|---|---|
| **Never speak in code** | Every reference is to what a person using the product sees, does, or experiences — never a code or repository artifact, never jargon. |
| **No time or effort estimates** | Describes scope and what's unknown; offers the smallest shippable piece or a time-box *you* set — never a confabulated duration. |
| **No ceremony, no machinery names** | Says what's actually happening in plain words; never narrates its process or names the skill/tool/step. |
| **Question discipline** | One real decision at a time, grounded in the code, options with their consequences, the recommended default named — never leading. |
| **One clear yes before anything irreversible** | Names the permanent effect concretely and waits for a single clear yes. |
| **Plain-language templates (optional)** | When restating a request or reporting a result, it has clean shapes for it — the read-back above, and a *Done / how to check / how to undo* close — used when they help, not as forced gates. |

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

No. It only governs *how* the agent talks, and it keeps that proportional. Low-stakes asks — easy to undo, only affects you, no compliance, no money — stay to a sentence or two. The fuller read-back comes out only when the impact is wider or harder to undo.
</details>

<details>
<summary><b>Does it work for technical users too?</b></summary>

Yes — and it doesn't switch into code just because you're technical. Keeping a change in product terms lets you judge *what* it does without re-deriving the diff, and the check at the end is something you run in the actual product, not a log grep. "I'm the CTO" and "I know what this is" don't buy a guessed estimate or skip the heads-up before something irreversible — that's exactly when a missed permanent op hurts most.
</details>

<details>
<summary><b>How does it handle deleting things?</b></summary>

Before anything that can't be undone, it names exactly what's lost in plain, concrete terms — *"once this runs, all 240 of those accounts are gone for good and can't be brought back"* — and waits for one clear yes. It doesn't run on a vague "sure," and it won't dress the warning up in jargon or ceremony.
</details>

<details>
<summary><b>What if I pressure the agent to just do it?</b></summary>

On something permanent it still wants the one clear yes: *"Once it's done it's done — I just need one clear yes on this first."* No lecturing, no policy citation. And no amount of pressure buys an invented time estimate. "The user clearly knows what they want" is the exact rationalization the rule exists to catch.
</details>

<details>
<summary><b>Why no estimates? Isn't a rough number better than nothing?</b></summary>

No — a confabulated number is worse than silence, because it carries the authority of "the system said so" and lands in real budget and prioritization calls. It will instead describe scope, name what's unknown, or honor a time-box *you* set. It can still give you dollar/API-call costs it can actually compute, and a fixed reversibility reading (Easy to undo / Hard to undo / Permanent — that's undo cost, not build time).
</details>

<details>
<summary><b>Does it conflict with Urd, TDD, brainstorming, or debugging?</b></summary>

No — it composes with all of them, by design. Ratatoskr is purely a communication layer: it governs *what the agent says to you and how*, never how the work is sequenced or run. Urd handles intent-to-code, TDD and debugging handle *how* you build or fix — Ratatoskr sits across all of them, keeping the conversation in plain language whatever methodology is driving the work.
</details>

<details>
<summary><b>Will it remember our last session?</b></summary>

No, and it says so plainly rather than confabulating. If you reference a prior chat, it admits it carries nothing over and offers to read the code to recover where things stand.
</details>

---

## What it doesn't claim

Ratatoskr governs how the agent *talks* to you — it is not a guarantee the agent read your mind, and it does not change what the agent builds or how. The plain-language read-back exists precisely because the agent might have it wrong, and gives you the chance to catch it. It reduces the risk of an irreversible mistake landing silently; it can't eliminate one if the agent fails to recognize a destructive op or can't see the relevant code. It flags compliance surfaces (GDPR, PCI, HIPAA, accessibility) in plain terms — it does not give legal advice. And it has no memory between chats. It flags; it doesn't promise.

---

## The Yggdrasil family

Four tools, one thesis: **make an AI coding agent prove correctness, stage by stage.** Because "done" isn't done. Each of the first four is a checkpoint at a different point in the pipeline, where the agent has to show its work before it continues.

| Tool | Stage | What it makes the agent prove |
|---|---|---|
| **Ratatoskr** (this one) | request → intent | Keeps the agent talking to you in plain words, not code, so you can follow what it's doing. |
| **[Urd](https://github.com/krzysztofdudek/UrdSkill)** | intent → code | When the spec is ambiguous, it consults the source of truth and asks, it doesn't guess. |
| **[Yggdrasil](https://github.com/krzysztofdudek/Yggdrasil)** | code → architecture | Every change satisfies the rules that govern it, checked before the agent moves on. |
| **[Researcher](https://github.com/krzysztofdudek/ResearcherSkill)** | code → measured result | Point it at a metric and it runs experiments, hypotheses kept and discarded. |

Two more sit alongside the chain rather than inside it, and they stack. **[Grain](https://github.com/krzysztofdudek/Grain)** reads a codebase's own code and history and writes the first architecture graph for it, then keeps telling Yggdrasil where practice has drifted from what the graph declares; it needs Yggdrasil and nothing else. **[Horde](https://github.com/krzysztofdudek/Horde)** sits on top of both: it needs Yggdrasil, uses Grain when it is installed, and is what you add when a mission needs more than one agent to move through all four stages at once, holding every agent it raises to the same standards. Each layer works without the ones above it, and none of them knows the ones above exist.
## License

MIT © [Krzysztof Dudek](https://github.com/krzysztofdudek)

---

<div align="center">
  <img src="yggdrasil.svg" alt="Yggdrasil" width="150" />
</div>
