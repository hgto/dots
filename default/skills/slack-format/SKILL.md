---
name: slack-format
description: Format existing content as a concise, copy-ready Slack message. Use when asked for Slack formatting, Slack markdown, a message to paste into Slack, or a nicely displayed Slack update. Uses Slack mrkdwn, bullets instead of tables, and preserves evidence and caveats.
---

# Copy-ready Slack formatting

Convert the supplied content; do not perform new research or post to Slack unless separately requested.

## Output

Return the message inside one fenced `text` block so the user can copy the literal formatting. The outer fence is a chat copy wrapper, not part of the Slack message. Do not surround the entire message with a code block inside Slack. Omit introductory commentary unless a clarification is necessary.

Slack's composer may handle pasted markup differently depending on its formatting settings. Do not promise automatic rich-text rendering. If markup remains literal, suggest enabling Slack's markdown composer preference or using its formatting toolbar; keep the same message structure.

## Formatting rules

- Use `*bold*`, not GitHub Markdown's `**bold**`.
- Prefer bold over italics for emphasis, labels, and caveats. Use `_italics_` sparingly, only where bold would be too heavy, such as a short aside within a sentence.
- Use backticks for identifiers or commands.
- Use a short bold title, then a bold bottom line or explicit ask.
- Use literal `•` bullets for lists. Put supporting details on the following indented line when useful.
- Separate sections and multi-line entries with blank lines. Avoid Markdown headings, pipe tables, HTML, and elaborate nested lists.
- Prefer readable dates. Give the timezone for timestamps and reporting windows; retain exact cutoffs when they affect interpretation.
- Keep each entry self-contained: subject, relevant identifier, result, and date or quantity.
- Use bold labels such as `*Audit window:*`, `*Coverage:*`, or `*Next step:*` only when relevant.
- For API mrkdwn payloads, use Slack link syntax `<https://example.com|Label>` and escape literal `&`, `<`, and `>` in text. For manual paste, prefer plain URLs. Do not invent mentions or IDs.
- No decorative emoji unless requested. Optimize for scanning on mobile.

## Preserve meaning

Keep verified counts, account states, dates, scope, pagination limits, uncertainty, and methodological caveats. Never turn “no recorded login” into “no activity,” or partial visibility into an organization-wide result. Do not imply an action was taken when it was only recommended.

Avoid adding facts, rounding across a decision threshold, or reproducing sensitive information that the audience does not need. Use generic placeholders in reusable templates; do not carry private audit results into the skill.

If drafting security findings, incident summaries, or other security prose, also apply the relevant security-language and writing skills. This skill changes presentation, not the evidence standard.

## Example shape

```text
*User activity audit — Month DD, YYYY*

*3 of 88 enabled users have no recorded login in the last 14 days.* All three accounts remain *ACTIVE*.

• *Example Person* — person@example.com
  Last login: Month DD, YYYY · *27 days ago*

*Audit window:* Start–end, ending at HH:MM UTC.
*Coverage:* All enabled accounts visible to the audit token; pagination completed.

*Note:* Based on the recorded last-login field, not a separate event-log reconciliation. Existing application sessions may still be in use. No accounts were changed.
```

Adapt the structure to the content; omit irrelevant sections rather than filling them with boilerplate.
