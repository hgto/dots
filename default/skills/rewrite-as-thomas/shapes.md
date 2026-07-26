# Shapes by register

Voice stays constant across registers. Rhythm, permitted fragments, and how much scaffolding survives all change. Pick the register before rewriting.

**These shapes are targets for a document being drafted, not a checklist a rewrite must satisfy.** When you're rewriting, a section the source doesn't supply stays absent. Reorder and re-title what's there; note what's missing in `Flags`. Writing a scope exclusion, an alternatives table, or a cost line the author never wrote means inventing facts, which the fidelity rules forbid outright.

If the document already follows a house template, keep the template's sections and headings exactly. Rewrite inside them. Never reorganize someone's template to match a shape below.

---

## 1. Decision document

An RFC, design doc, proposal, or memo where a named group has to agree to something.

**Shape**

1. **Opening.** What's true today. Why that's a problem, in one or two sentences. What this proposes.
2. **The ask**, as a numbered list. Each item is a decision, phrased so a reviewer can say yes or no to it alone. Semicolons between clauses, "; and" before the last.
3. **Scope exclusion.** One line: what this doesn't cover.
4. **The design**, in imperative mood. Concrete identifiers throughout.
5. **Alternatives**, each with a one-word verdict and a clause of reasoning.
6. **What's sharp**, numbered — the parts most likely to go wrong.
7. **Cost**, in numbers, split between build cost and running cost.

Rules specific to this register:

- Requirements get a bold lead-in label and a period, then the explanation.
- Every rejected alternative gets a reason that names a mechanism, not a preference. "Rejected — the shared signing key means tokens stay cross-valid" beats "Rejected — doesn't meet our needs."
- Sequencing is explicit and ordered: "dev, then staging, then production."
- If a decision is reversible, say how. If it isn't, say that louder.

**Before**

> It is important to note that our current architecture presents a number of significant challenges with respect to environment separation. All of our environments are currently configured to share a single signing key, and consequently a token which has been minted in the development environment will be cryptographically valid in the production environment. At this point in time, the only thing preventing this from being exploitable is an application-layer lookup. We are considering the implementation of a per-environment tenant approach, with each environment utilizing its own distinct key, although it should be noted that there are cost implications of approximately $21,000 per annum which will grow with each additional deployment, and which will need to be carefully evaluated by relevant stakeholders. It is also worth mentioning that this proposal does not encompass fine-grained access control. We would appreciate the team's approval of this approach, or alternatively guidance as to whether other vendors should be evaluated, and we would additionally like to confirm the organization's long-term commitment to the current vendor given the sensitivity of the migration involved.

**After**

> Every environment shares one signing key, so a token minted in dev is cryptographically valid in production. Today only an application-layer lookup stops it from working.
>
> This proposes one tenant per environment, each with its own key. It asks the team to:
>
> 1. confirm our long-term commitment to the current vendor, given how sensitive this migration is; and
> 2. either approve this approach, at a cost of about $21,000 a year that grows with each new deployment, or point us at other vendors to evaluate.
>
> This doesn't cover fine-grained access control.

**Changes**

- Opened on the state of the world — shared key, dev token valid in production — and cut the frame that announced challenges before naming one.
- Split the single 90-word sentence carrying the proposal, the cost, and both asks into a proposal sentence and a two-item ask list.
- Restored the fork the source buried: approve, or send us to look at other vendors.
- Moved the scope exclusion out of a mid-sentence aside and onto its own line.
- Diction: utilizing → with, at this point in time → today, approximately → about, per annum → a year, implementation of → dropped. Contractions throughout.

**Flags**

- No design section. How the tenants get created, and in what order environments cut over, isn't in the source.
- No alternatives with verdicts. The source names no option other than per-environment tenants.
- Nothing on what's sharp. A key rotation forces re-authentication somewhere; the source doesn't say where.
- Cost isn't split between build and running. The $21,000 reads as recurring, but the engineering cost of the migration is absent.
- "Relevant stakeholders" is unnamed. Who signs off, and by when?

Every fact in the "After" traces back to the "Before." Nothing was added: not the key, not the lookup, not the dollar figure, not the scope line, not either half of the ask. What changed is order, length, and word choice. Everything the shape wanted and the source lacked went to `Flags` instead of getting written. If you can't trace a rewritten clause back to a source clause, you've written something new.

---

## 2. Working notes

A mindmap, a running assessment, a landscape review, a page you keep adding to. The reader is you in three weeks, or a colleague catching up.

**Shape**

Nested bullets under topic headings. Depth carries structure; prose carries judgment.

Rules specific to this register:

- Labels do the work. `Opportunity:`, `Issue:`, `Compensating control:`, `My take:`, `Action item:`, `Solved:`. Pick a small set and use them consistently down the page.
- Fragments are fine. Articles can drop. Verbs can't.
- Attribute every position to a person: "Ravi says GDPR is the top priority; Dana says we're not ready. My take: start preparing now."
- Pair each problem with what's currently holding the line, even when that's nothing. An issue with no compensating control should say so explicitly.
- Mark the shelf life of a judgment: "acceptable now because deployments are small and hand-held. Won't scale."
- Keep the unresolved bits visible. "(unclear what's in them — action item to check)" is more useful than silence.

---

## 3. Public post

An announcement, a launch note, a LinkedIn post, a blog intro. Written in first person, read by people outside the company.

**Shape**

1. The news, in one sentence.
2. What the thing is, in plain language a non-specialist gets.
3. The problem it solves, made real by one specific story or scene.
4. A short line that turns the corner.
5. The people, by name.
6. The ask or the pointer, if there is one.

Rules specific to this register:

- One concrete anecdote beats three abstractions. A scene with people in it, told in a couple of sentences.
- Warm, not gushy. Enthusiasm shows in what you chose to describe, not in adjectives.
- Credit people by name, and say what they actually did.
- A one-line paragraph is allowed here as a hinge. Once.
- No hashtags, no emoji, no exclamation marks.
- Trademarks and product names exactly as the company writes them.

---

## 4. Short form

Slack, PR descriptions, issue comments, commit bodies, review replies.

**Shape**

Answer first. Context only if the answer doesn't stand alone.

Rules specific to this register:

- Lead with the verdict or the answer, then the reason. "Rejected — this reuses the shared key." "Yes, but not before the soak finishes."
- One paragraph. If it needs three, it needs a document, and the message should link to one.
- Bullets only for genuinely parallel items.
- No greeting, no sign-off, no "hope this helps."
- A question is a question mark and nothing else: "Which account?" not "I was wondering if you could clarify which account this refers to?"
- Contractions and clipped syntax are more welcome here than anywhere else. Don't clip so far that a reader has to reconstruct the subject.
