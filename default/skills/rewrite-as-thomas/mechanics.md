# Mechanics

American English throughout, with Economist judgment on what's worth saying and NYT convention where the Economist is British or silent.

## Spelling

American forms. Organize, analyze, defense, license (verb and noun), color, behavior, center, meter, traveled, canceled, catalog, gray, program (including a TV program).

Keep British spelling only inside a proper noun or a quotation: `Programme for X`, a quoted sentence, a config key named `colour`.

Technical spellings that beat both style guides because the field settled them: cache, disk (not disc), sync, config, repo, auth. Don't expand an abbreviation the reader's team never expands.

## Punctuation

**Serial comma: use it.** "Diagnose, remediate, and prevent." It removes ambiguity and it's the dominant American convention.

**Quotation marks: double.** Single quotes only for a quote inside a quote. Periods and commas go inside the closing quote; colons and semicolons go outside. Question marks go inside only when the question is part of the quoted material.

**Em dash: spaced, sparing.** " — " for a verdict, a sharp aside, or a reversal. At most one per paragraph. Two in a sentence means the sentence wants to be two sentences.

**Semicolons** join independent clauses in a numbered ask, and separate list items that already contain commas. Nowhere else. A semicolon between two ordinary clauses usually wants to be a period.

**Colons** introduce a list, a verdict, or a labeled opinion: "My take: we should start preparing anyway."

**No exclamation marks.** None, including in Slack.

**Parentheses** for a genuine aside. If the content matters, it isn't an aside — promote it to a clause.

**Ampersand** is fine in a heading or a tight pairing where it reads as one thing: "dev & testing," "release & distribution." Not in running prose.

**Slashes**: avoid `and/or`. Pick one, or write "X, Y, or both."

## Numbers

- Spell out one through nine. Numerals from 10 up. "Three months of work," "nine repositories."
- Numerals override the spell-out rule when the number sits against a **measured or technical unit**, or inside money, a version, a percentage, a port, or an ID: 4 GB, 8 vCPU, $21,000, v2, 40%, port 443. A duration in prose is not a measured unit — "three months" — but a duration in an operational timeline is: "4–8 hours of degraded service."
- The two rules only collide in ranges. A range takes numerals throughout, even below 10: 4–8 hours, 2–3 engineers.
- Never start a sentence with a numeral. Recast the sentence rather than spelling out a large number.
- Money: `$21,000` in prose. `$21k` is fine in a table, a note, or a cost line where compactness helps. Say the currency the first time if it's ambiguous.
- Percent sign in technical writing: `40%`. Spell "percent" only in a public post.
- Ranges take an en dash with no spaces: 4–8 hours, 2024–26.
- Big round numbers can be words where precision isn't the point: "a million rows." Exact counts stay numeric: 1,048,576 rows.
- Multipliers: "10x", not "10 times" or "tenfold."

## Dates and times

- Technical documents and filenames: ISO. `2026-07-25`.
- Prose for a general reader: "July 25, 2026" — NYT order, with the comma after the year when the sentence continues.
- Times carry a zone, always. `02:14 UTC`. In an operational timeline, use 24-hour UTC and say so once at the top.
- Never use a bare relative date in a document that will be read later. "Last quarter" becomes "in Q2 2026."

## Capitalization

- **Sentence case for every heading**, including H1. "Alternatives considered," not "Alternatives Considered." Product names inside a heading keep their own capitals.
- Job titles are lowercase unless they precede a name: "the head of security," but "Head of Security Ada Chen."
- Team and environment names are lowercase unless they're proper nouns: dev, staging, production, the data platform team.
- Don't capitalize a common noun to make it feel important. "the registry," not "the Registry."
- Acronyms: define on first use unless the audience uses it daily. `SBOM` needs no gloss for a platform team; it does in a post for a general audience.

## Abbreviations

- Periods in `U.S.`, `U.K.`, `N.Y.T.` Not in acronyms pronounced as words or spelled out as letters: NATO, AWS, IAM, API.
- `e.g.` and `i.e.` take a comma after, and belong in parentheses. In running prose write "for example" and "that is."
- `etc.` is a confession that the list is unfinished. Either finish the list or write "and so on" and mean it.

## Links and code

- Link on the words that describe the destination, never on a bare URL in prose and never on "here" or "this link."
- A bare URL is acceptable in a references list, a table cell, or a config example.
- Backticks for anything typed literally: paths, commands, identifiers, field names, environment names when they're literal config values.
- Never bold a whole sentence. Bold is for a lead-in label or a one-word verdict, nothing else.
- Italics for a first-use term or a title. Not for emphasis — recast the sentence instead.

## Lists

- A list where every item is a full sentence: cap each item and end each with a period.
- A list of fragments: cap each item, no terminal punctuation, and keep every item grammatically parallel.
- Don't mix the two shapes in one list.
- A list under three items is usually a sentence. A list over about nine items usually wants a table or a subhead.

## Emoji

None, with one exception: keep emoji that an existing document template already uses in its section headers. Don't add them, don't remove them from a template, and never put one in running prose.
