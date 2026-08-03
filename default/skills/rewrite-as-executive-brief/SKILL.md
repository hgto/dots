---
name: rewrite-as-executive-brief
description: Use when the reader says they're lost, or asks to re-explain a complex analysis, decision, or prior conversation "from first principles", "in plain english", "start with the most important thing", or "as an executive brief". Restructures existing content into an Economist-style inverted-pyramid brief - verdict first, a short assertion-only summary with appendix pointers, then self-contained first-principles appendices that assume zero domain knowledge. Delivers as chat text, a markdown file, or a Notion page.
---

# Rewrite as Executive Brief

Restructure an existing analysis so a smart reader with **zero domain knowledge** gets the verdict in the first line, everything they must know in one screen, and the reasoning only if they go looking for it. The summary asserts; the appendices argue. Nothing is justified inline.

This is a restructuring skill, not an analysis skill. It changes the order, register, and packaging of what was already concluded — never the conclusions.

## When this fires

- The reader says some form of "you've lost me", "back up", "explain like I know nothing".
- The reader asks for a brief/summary/one-pager of a long or technical exchange.
- You're about to deliver a long analysis to someone who asked a plain question.

The input is usually the preceding conversation itself; it can also be a file, a pasted block, or an argument. If more than one reading of "rewrite this" is plausible, ask. If you can't ask, pick the most likely reading, say which you picked, and carry on.

## The shape

Every brief has exactly these layers, in this order:

1. **Verdict callout.** One or two sentences at the very top: the decision or recommendation, at the source's strength — then a fragment of why, at most one clause. Format as a callout/blockquote so it can't be missed.
2. **"What you need to know."** 5–9 numbered items. Each is one plain-English assertion the reader can act on, with **zero justification**, ending with a pointer like *(Appendix B)*. Deadlines, hard tripwires, and irreversible steps each get their own item — never fold them into another. Order items by importance, not by topic.
3. **Standing caveat**, one line, when the domain warrants it (tax, legal, medical, security): what this document is not, and who to pay before acting.
4. **Appendices.** Lettered, each self-contained, each carrying all the argument, math, tables, and scenarios for the summary items that point to it. Order them pedagogically, not by importance:
   - first appendix defines the objects from scratch ("what is an X"),
   - middle appendices carry the comparison, the strategy, the failure modes, the reader-specific constraints,
   - last appendix is **provenance**: where every number and factual claim came from, compressed to a paragraph or two.

No closing section. The document ends when the last appendix ends — the summary already did the summarizing.

## Procedure

1. **Find the input** and the reader's destination (chat, file path, Notion). Default to chat if unstated.
2. **Extract the single decision.** What is the reader choosing between, or what must they do? The whole brief is organized around it. If the source contains several decisions, lead with the primary one and demote the rest to appendix material — or ask which one matters.
3. **Inventory the source:** the recommendation and its strength; every assertion the reader must know; every deadline and tripwire; every term of art; every number and where it came from.
4. **Write the summary first.** Apply the assertion test to each item: if it contains "because", "since", "which means", or any argument, cut the clause and move it to the appendix the item points to. An item that survives is a bare claim plus a pointer.
5. **Write the appendices assuming the reader knows nothing.** Define every term of art at first use, in a clause, in the same sentence ("the **strike price** — the fixed price your coupon locks in"). Build each concept from ones already defined. One analogy per concept at most, and only if it adds nothing false.
6. **Set the voice.** If a `rewrite-as-thomas` skill is available (Skill tool or on disk), apply its diction, mechanics, and fidelity rules on top. If not, these rules bind on their own: Economist style — short Germanic words, contractions, active voice, one idea per sentence, most sentences under ~22 words, no LLM tells (delve, robust, leverage, landscape, "it's worth noting").
7. **Deliver** (see below), then run the red-flag checklist and fix what it catches.

## Fidelity rules

These are hard. Break one and the brief is wrong, however clean it reads.

- **No new analysis.** Every conclusion, recommendation, number, and scenario must exist in the source. Restructuring is the entire mandate.
- Preserve every number, date, deadline, hedge, and caveat exactly. "Roughly", "likely", and "plausibly" are content, not padding — a verdict stated more confidently than the source stated it is a fabrication.
- If the source has no recommendation, the verdict callout states the decision and the leading option *with its condition*, and you flag that the source never made a call.
- Plain English may simplify a mechanism only until just before it changes what the reader would do. When a simplification would change the action, keep the complexity and spend the sentences.
- If a summary-worthy claim has no support anywhere in the source, don't invent an appendix for it — flag the gap.

## Rendering numbers for a novice

A bare figure is jargon too. Attach meaning at first use: "~50% — about half of every dollar"; "$58k — roughly two months of your gross pay". Derive the comparison only from facts in the source; if the source gives no anchor, leave the number bare rather than invent one.

## Delivery

- **Notion:** create a single page with the brief as its content. With no parent specified, create it as a **workspace-level private page** and return the URL. If the workspace plausibly belongs to an employer or team and the content is personal, say so and suggest exporting.
- **File:** write markdown to the given path.
- **Chat:** output the full brief as the final message.

**Sensitive content:** these briefs often exist because the underlying topic is personal (money, health, employment, legal exposure). Deliver only to a destination the requester controls. Never post to a shared space, channel, or page without an explicit ask.

## Micro-example (shape only)

> **The short version: migrate with the dual-write approach, start the backfill this week, and don't cut over until the counts reconcile.**

**What you need to know**

1. You're choosing between two ways of moving the same data; only the failure modes differ. *(Appendix A)*
2. Pick dual-write. Its worst case is the other option's best case. *(Appendix B)*
3. The backfill must start before the retention window closes on the 14th — that deadline, not the launch date, is the real clock. *(Appendix C)*

…each appendix then defines the terms, carries the comparison table, and argues the timing — none of which appears above.

## Red flags — stop and fix

- [ ] The verdict paragraph builds up to the call instead of opening with it.
- [ ] A summary item contains "because", "since", "which means", or any justification clause.
- [ ] A summary item has no appendix pointer.
- [ ] A deadline or tripwire is buried in an appendix and missing from the summary.
- [ ] An appendix uses a term of art before defining it, or defines it in a different section than first use.
- [ ] I added a fact, number, comparison anchor, or recommendation that isn't in the source.
- [ ] The verdict is stated more (or less) confidently than the source stated it.
- [ ] There's a closing paragraph restating the summary.
- [ ] The brief went to a shared destination, or an employer-visible one, without flagging it.
- [ ] An LLM tell survived.

## Rationalizations

| Rationalization | Counter |
|---|---|
| "The summary reads bare without a why." | Bare is the feature. The why is one pointer away, and the reader who wanted it lost was drowning in whys. |
| "The reader probably knows this term." | They invoked this skill because they were lost. Defining it costs one clause; assuming it costs the whole document. |
| "While restructuring I noticed a better recommendation." | Then say so *outside* the brief, as yourself. Inside it, you're a typesetter, not an analyst. |
| "The appendices repeat the summary." | By design. The summary asserts, the appendices argue; the same claim appearing in both layers is the mechanism, not redundancy. |
| "A short justification in item 3 makes it more persuasive." | Persuasion lives in the appendix. The summary's job is to be actionable in under a minute, and every inline why taxes that. |
| "The source's hedge weakens the verdict callout." | The hedge *is* the verdict's calibration. A crisper lie is still a lie. |
