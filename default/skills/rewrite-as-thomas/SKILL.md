---
name: rewrite-as-thomas
description: Use when asked to rewrite, edit, tighten, or restyle prose in Thomas's voice — RFCs, design docs, decision memos, working notes, announcements, PR descriptions, or Slack posts. Also use before delivering any long-form prose Thomas will publish under his own name. Applies Economist-style diction in American English, contractions, and a lead-with-the-ask structure.
---

# Rewrite as Thomas

Rewrite prose so it reads as though Thomas wrote it: plain, direct, concrete, and short-worded. The authority on diction is *The Economist Style Guide*, rendered in American English. Where the Economist is silent or distinctly British, fall back to *The New York Times Manual of Style and Usage*.

This is an editing skill, not a writing skill. It changes how something is said, never what is said.

## Files in this skill

| File | Purpose |
|---|---|
| `diction.md` | Word-level substitutions, banned phrases, and the Germanic-first rule |
| `mechanics.md` | American English orthography, punctuation, numbers, headings |
| `shapes.md` | Rhetorical shapes by register: decision doc, working notes, public post |

## Precedence

1. **Fidelity beats style.** See "Fidelity rules" below. A prettier sentence that changes a claim is a failure.
2. **`security-language` beats this skill.** This skill only sets voice, diction, and rhythm on top. See "Security prose" below for the trigger test and the conflict resolutions.
3. **The Economist beats house habits**, in American English.
4. **NYT breaks ties** the Economist doesn't settle.

## Security prose

**Trigger test.** The text is security prose if any sentence characterizes a weakness, an incident, an actor, a control's effectiveness, or a risk to the business. One such sentence is enough. Genre doesn't matter — a design doc with a threat paragraph counts, for that paragraph and anything downstream of it.

When it triggers, load `security-language` first, and `write-security-executive-summary` too if the reader is leadership. Use the Skill tool if they're registered; read the files directly if they're on disk but unregistered. If neither skill is available, these rules still bind, and they're enough to work from:

- Separate observed fact from assessment. An assessment carries a likelihood term and a confidence level.
- No "attacker," "hacker," "breach," "stolen," "leak," or "unauthorized access." No "vulnerability" for an unconfirmed issue.
- No absolutes: impossible, guaranteed, fully eliminated, 100% secure.
- No legal or compliance verdicts: illegal, violation, non-compliant. State the condition; flag it for counsel.
- Blameless. Findings attach to systems, configurations, and processes.

**Conflict resolutions**, so "be blunt" doesn't get misread:

| This skill says | `security-language` says | Resolution |
|---|---|---|
| Be blunt | Qualify assessments | Blunt syntax, calibrated claim. Never drop a likelihood or confidence term to shorten a sentence. |
| Short, punchy sentences | No absolutes | A punchy sentence is not an absolute one. "Impossible" and "guaranteed" stay banned. |
| Name the concrete thing | Use roles, not names | Both hold. Attribute a *stated position or decision* to a named person — that's the point of attribution. Never attribute a *fault, error, or finding* to one. |
| One-word verdicts: Rejected | No legal verdicts | Engineering verdicts are in voice. "Illegal" and "violation" are not verdicts you get to render. |
| `diction.md` bans "significant" | Substitute "significant" for "catastrophic" | In security prose, `security-language` wins and "significant" is fine. Elsewhere the ban holds. |
| Never add what the author didn't write | Every assessment carries a likelihood term and a confidence level | Fidelity wins — precedence rule 1. You don't know how sure they were. Never manufacture "we assess with moderate confidence." Keep the uncalibrated sentence and flag it: the assessment needs a likelihood and a confidence level from the author. |

## Procedure

1. **Find the input.** An argument, a file path, a pasted block, or the draft just produced. If more than one reading is plausible, ask. If you can't ask — no user channel, running as a subagent — pick the most likely reading, say which one you picked, and carry on.
2. **Name the register** — decision doc, working notes, public post, or short-form chat. Read the matching section of `shapes.md`. Rhythm and permitted fragments differ by register.
3. **Run the security-prose trigger test.** See "Security prose" above.
4. **Rewrite in full.** Apply the voice rules below, then `diction.md`, then `mechanics.md`.
5. **Run the red-flag checklist.** Fix what it catches.
6. **Deliver.** Output the rewritten text in full, then two lists:
   - `Changes` — up to five bullets, substantive moves only. Not a diff.
   - `Flags` — unbounded. Anything you couldn't preserve cleanly, every passage too vague to rewrite without guessing, and every element the register's shape wants that the source doesn't supply. One line each.

   When editing a file, edit in place and give the same two lists.

## Fidelity rules

These are hard. Break one and the rewrite is wrong, however well it reads.

- Preserve every fact, number, identifier, path, URL, name, and date exactly. If a number looks wrong, flag it; don't fix it. Re-rendering `3` as "three" per `mechanics.md` isn't changing a number.
- Preserve every hedge. "Likely," "we assess," "roughly," and "to be confirmed" are content, not padding.
- Never raise or lower the strength of a claim. If tightening a sentence makes it sound more certain, it's too tight.
- Never add a fact, cause, benefit, or example that isn't in the source. Concreteness comes from the source's own detail, not from invention. A missing section stays missing and goes in `Flags`.
- Never delete an explicit scope exclusion, a caveat, an attribution, or a dissent.
- **Don't upgrade the ask.** "We'd like feedback" stays a request for feedback. Sharpen an ask that already exists; never convert a discussion into an approval request, or a proposal into a decision. That's a change to what's said.
- If a passage is too vague to rewrite without guessing, keep it and flag it. Say what's missing.

**Three kinds of qualifier.** They look alike and the rules pull opposite ways, so sort them before touching any of them:

- *Calibrators* say how sure or how approximate the claim is: roughly, about, likely, possibly, up to, at least. **Keep every one.** They're content.
- *Intensifiers* say how strongly the writer feels: critical, severe, massive, dramatic, alarming. **Replace each with the number or scope it stands in for.**
- *Downtoners* weaken the word they modify: fairly, somewhat, quite, rather, relatively. **Delete them only along with the intensifier they're softening**, never on their own — cutting "fairly" from "fairly critical" raises the claim, which the rule above forbids.

**When there's no number to substitute**, the intensifier can't go. Dropping it weakens the claim; a bare downtoner strengthens it. Keep the author's phrase whole, exactly as written, and flag it: the document needs a number there. This holds for every intensifier including "critical," and it overrides the "critical" row in the rationalization table, which assumes a number is available.

## Voice

**Lead with the state of the world, then the problem, then the ask.** No warm-up, no throat-clearing, no restating the title. The first sentence says what's true today. The second says why that's a problem.

**State the ask as decisions.** If the document already asks for something, close the opening with a numbered list where each item is a call someone can actually make. Join the clauses with semicolons and end the last one with "; and". Sharpen the ask that's there — don't invent a stronger one. See "Don't upgrade the ask" in the fidelity rules.

**Show the fork.** When there's a tradeoff, write it as a choice, not a recommendation with the alternative buried: "either accept X, or redirect to Y." Give the recommendation too, but don't hide what it costs.

**Bound the scope out loud.** One line saying what this doesn't cover. It prevents the review from wandering. If the source doesn't say what's out of scope, don't guess at it — flag that the line is missing.

**Ground abstractions on the spot.** An abstract claim gets "For example," and a concrete case in the same paragraph, or it gets cut.

**Name the concrete thing.** Account IDs, repo paths, hostnames, dollar figures, dates, tool names. Specificity is the whole argument. "A registry" is weaker than the registry's actual URL.

**Attribute opinions to people.** "Priya says we're not ready; my take is we should start preparing anyway." Never launder one person's view as consensus, and never hide your own view as though it were a finding. "My take:" is the right label for it.

**Date your judgments.** A call that's true now and false later says so: "This is fine today because the deployments are small and hand-held. It won't scale."

**Spell causal chains to the end state.** Not "this is risky" but "this would let a party who's captured internal credentials push an image into the cluster, get arbitrary code execution, and take full cluster control." Follow the chain until it lands somewhere a reader cares about.

**Verdicts are one word.** Recommended. Rejected. Consider. Solved. Issue. Put the reason after an em dash, in a clause, not a paragraph.

**Directives are imperative.** In a design section, write "Keep state in the global bucket. Don't enable enhanced scanning." Not "it is recommended that state be kept."

**Contractions, always.** We'll, don't, it's, can't, won't, doesn't, there's. They read faster. This deliberately overrides the Economist's formality; it does not override anything else in the Economist.

**Blunt, never dramatic.** "This is a footgun for customers" is in voice. "This is a catastrophic risk" is not — it's an intensifier standing in for a number.

## Rhythm

- One idea per sentence. Most sentences under about 22 words.
- Vary the length. After three medium sentences, a short one lands. Use that deliberately, not on a schedule.
- Active voice with a named actor. Passive only when the actor is genuinely unknown or genuinely irrelevant.
- Present tense for what's true, future for the plan, past for what happened. Don't drift.
- Bold lead-in labels end with a period, then the sentence continues: "**Total isolation.** Customer environments aren't under our control, so…"
- Numbered lists for sequence and for asks. Bullets for sets. Roman numerals for standing principles, if the document has them.
- Paragraphs run two to five sentences. A one-sentence paragraph is an emphasis tool; use it once per document at most. The scope-exclusion line doesn't count against that budget.

## Red flags — stop and fix

- [ ] The first paragraph builds up to the point instead of opening with it.
- [ ] The document asks for something but never states the ask as a decision.
- [ ] The source names a tradeoff and I buried the alternative instead of putting it in the fork.
- [ ] I added a section, example, or figure the source didn't have, instead of flagging it as missing.
- [ ] I turned a request for feedback into a request for approval.
- [ ] An abstract claim runs a full paragraph with no concrete example or identifier.
- [ ] An opinion is stated as a finding, or a finding is softened into an opinion.
- [ ] A risk stops at "this is dangerous" without following the chain to an outcome.
- [ ] I used a long Latinate word where a short Germanic one works — check `diction.md`.
- [ ] I expanded a contraction.
- [ ] I left an intensifier standing — critical, massive, significant, severe, dramatic — when the source had a number I could have used instead.
- [ ] I cut a downtoner on its own, or dropped an intensifier the source gave me no number to replace.
- [ ] I used an LLM tell: delve, landscape, realm, seamless, robust, leverage, tapestry, "it's worth noting that," "in today's fast-paced."
- [ ] I wrote a closing paragraph that restates what's already been said.
- [ ] I changed a number, dropped a hedge, or strengthened a claim.
- [ ] It's security prose and I didn't load `security-language`.

## Rationalizations

| Rationalization | Counter |
|---|---|
| "The original is vague, so I'll fill in a plausible detail." | You'd be inventing a fact under someone else's name. Keep the vagueness and flag it. A flagged gap is useful; a fabricated specific is a liability. |
| "This hedge is clutter — the sentence is stronger without it." | The hedge is the claim's calibration. Removing it makes an assessment read as a fact. That's the one edit this skill can't make. |
| "Contractions look unprofessional in a formal RFC." | They read faster, and reading speed is the point. This is an explicit, deliberate override of Economist formality, and it applies to formal documents too. |
| "Short words dumb it down." | Short words are the Economist's core rule, and its readers are not a simple audience. Long words signal effort, not thought. Terms of art are exempt — see the carve-out in `diction.md`. |
| "'Critical' conveys urgency better than a number." | It conveys the writer's feelings. A number conveys the situation. Swap it for the number when one is in the source. When none is — and this is the common case in a rewrite — keep the author's word and flag it. You're editing, not reporting; you don't have the number they didn't write. |
| "A summary paragraph at the end helps the reader." | The reader got the summary in the first paragraph, which is where it belongs. A second one implies the first didn't work. End on the last real point. |
