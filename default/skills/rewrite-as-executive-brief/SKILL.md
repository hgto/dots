---
name: rewrite-as-executive-brief
description: Use when the reader says they're lost, or asks to re-explain a complex analysis, decision, or prior conversation "from first principles", "in plain english", "start with the most important thing", or "as an executive brief". Restructures existing content into an Economist-style inverted-pyramid brief - a self-contained executive paragraph explaining the current state and proposed change, concise action bullets, then supporting first-principles appendices. Delivers as chat text, a markdown file, or a Notion page.
---

# Rewrite as Executive Brief

Restructure an existing analysis so a smart reader with **zero domain knowledge** understands the overall change from the first paragraph and everything they must know from the opening section. The summary explains the plan; the appendices supply detailed reasoning and evidence. A reader must not need an appendix to reconstruct what we're proposing.

This is a restructuring skill, not an analysis skill. It changes the order, register, and packaging of what was already concluded — never the conclusions.

## When this fires

- The reader says some form of "you've lost me", "back up", "explain like I know nothing".
- The reader asks for a brief/summary/one-pager of a long or technical exchange.
- You're about to deliver a long analysis to someone who asked a plain question.

The input is usually the preceding conversation itself; it can also be a file, a pasted block, or an argument. If more than one reading of "rewrite this" is plausible, ask. If you can't ask, pick the most likely reading, say which you picked, and carry on.

## The shape

Use these layers, in this order:

1. **Executive paragraph.** One short, self-contained paragraph: current state → proposed change → expected result → main trade-off → status. Name what happens today and what will replace it; don't lead with an isolated benefit or verdict. State the decision or recommendation at the source's strength. Use only source-supported elements; flag missing context rather than filling it in. A callout is optional, not a substitute for this paragraph.
2. **"What you need to know" or "What changes—and what stays."** Concise action bullets, usually 5–9; use numbering for sequences or decisions. Give each item a clear lead-in and enough context to understand the action, including short definitions or mechanisms where needed. End with a supporting pointer like *(Appendix B)*. Deadlines, hard tripwires, and irreversible steps each get their own item — never fold them into another. Order items by importance, not by topic.
3. **Standing caveat**, one line, when the domain warrants it (tax, legal, medical, security): what this document is not, and who to pay before acting.
4. **Appendices.** Lettered, each self-contained, carrying detailed argument, math, tables, and scenarios for the summary items that point to it. Pointers offer depth and provenance, not missing parts of the plan. Order appendices pedagogically, not by importance:
   - first appendix defines the objects from scratch ("what is an X"),
   - middle appendices carry the comparison, the strategy, the failure modes, the reader-specific constraints,
   - last appendix is **provenance**: where every number and factual claim came from, compressed to a paragraph or two.

No closing section. The document ends when the last appendix ends — the summary already did the summarizing.

## Procedure

1. **Find the input** and the reader's destination (chat, file path, Notion). Default to chat if unstated.
2. **Extract the single decision.** What is the reader choosing between, or what must they do? The whole brief is organized around it. If the source contains several decisions, lead with the primary one and demote the rest to appendix material — or ask which one matters.
3. **Inventory the source:** current state; proposed changes and what stays; expected results; main trade-offs; proposal, approval, and implementation status; the recommendation and its strength; every deadline and tripwire; every term of art; every number and where it came from.
4. **Write the opening first.** Connect today's setup to the proposed change in one paragraph, then write the action bullets. Keep short explanations needed to understand the plan; move detailed argument and evidence to appendices. Don't remove connective clauses merely because they contain "because", "since", or "which means". Define unfamiliar terms at first use in the opening too.
5. **Write the appendices assuming the reader knows nothing.** Define every term of art at first use, in a clause, in the same sentence ("the **strike price** — the fixed price your coupon locks in"). Build each concept from ones already defined. One analogy per concept at most, and only if it adds nothing false.
6. **Set the voice.** If a `rewrite-as-thomas` skill is available (Skill tool or on disk), apply its diction, mechanics, and fidelity rules on top. If not, these rules bind on their own: Economist style — short Germanic words, contractions, active voice, one idea per sentence, most sentences under ~22 words, no LLM tells (delve, robust, leverage, landscape, "it's worth noting").
7. **Check comprehension without appendices.** Read only the opening paragraph and bullets. Can a reader explain what happens today, what changes and stays, the expected result, what we give up, whether this is proposed/approved/implemented, and what must happen before proceeding? For any source-supported answer that's missing, revise the opening. For answers absent from the source, flag the gap; don't invent them.
8. **Deliver** (see below), then run the red-flag checklist and fix what it catches.

## Fidelity rules

These are hard. Break one and the brief is wrong, however clean it reads.

- **No new analysis.** Every conclusion, recommendation, number, and scenario must exist in the source. Restructuring is the entire mandate.
- Preserve every number, date, deadline, hedge, and caveat exactly. "Roughly", "likely", and "plausibly" are content, not padding — a verdict stated more confidently than the source stated it is a fabrication.
- If the source has no recommendation, the executive paragraph states the decision and any source-supported leading option *with its condition*, and you flag that the source never made a call. Don't choose an option on the source's behalf.
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

Today, we send full network-flow logs to CloudWatch Logs and record S3 object activity in CloudTrail. We propose sending new network-flow logs directly to S3 in Parquet—a format for querying stored data—while keeping all traffic records, saving an estimated $2,756.55 per 31 days. Excluding approved S3 metadata and listing operations from auditing saves an estimated additional $1,351.53 over that period. Together, these changes save about $4,108 per 31 days before replacement costs. Investigators will use a new query path for network records and lose request history for the excluded S3 operations. Implementation hasn't started.

**What you need to know**

- **Keep all network-flow records; change their destination.** Query new records in S3 with Athena or another Parquet-capable tool. Keep existing CloudWatch history at 365-day retention; no historical backfill is planned. *(Appendices A, C)*
- **Reduce only the approved S3 audit coverage.** Stop recording the selected metadata and listing operations; keep content reads and object-changing operations recorded. *(Appendix D)*
- **Test before stopping the old delivery path.** Verify delivery completeness, an investigation of accepted traffic, and existing alerts and consumers before cutover. *(Appendix F)*

This shortened example uses the AWS logging revision as a reference case. Its appendices would carry definitions, calculations, sampling limits, and implementation details. The opening already explains the plan without them; it doesn't claim finalized net savings or security approval.

## Red flags — stop and fix

- [ ] The opening gives a benefit or verdict without explaining today's setup and the proposed change.
- [ ] A reader must open an appendix to understand the plan, its main trade-off, or its status.
- [ ] I cut a definition or connective clause needed to understand an action, or left detailed argument in the summary.
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
| "The reader can reconstruct the plan from the appendices." | Reconstruction is the failure. The opening must explain the current state and overall change on its own. |
| "The reader probably knows this term." | They invoked this skill because they were lost. Defining it costs one clause; assuming it costs the whole document. |
| "While restructuring I noticed a better recommendation." | Then say so *outside* the brief, as yourself. Inside it, you're a typesetter, not an analyst. |
| "The appendices repeat the summary." | By design. The summary explains the plan; the appendices support it. Neither layer should depend on the reader remembering the other. |
| "Any explanation belongs in an appendix." | Essential context belongs in the opening. Detailed proof belongs in an appendix. Cut by purpose, not by conjunction. |
| "The source's hedge weakens the executive paragraph." | The hedge *is* the claim's calibration. A crisper lie is still a lie. |
