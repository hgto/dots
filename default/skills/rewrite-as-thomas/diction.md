# Diction

## The rule

*The Economist Style Guide*, first principle, adapted: **prefer the short word to the long one, and the familiar word to the fancy one.** In English that usually means the Germanic word beats the Latinate one — the word a reader learned early and reads without thinking.

Ask of every word longer than two syllables: is there a shorter word that means the same thing? If yes, use it. If the shorter word means something slightly different, keep the long one — precision wins over brevity every time.

This table is about **length and familiarity**. The `security-language` skill's `word-substitutions.md` is about **neutrality and legal exposure**. They serve different ends and don't conflict; where they somehow do, `security-language` wins.

## Substitutions

| Instead of | Write |
|---|---|
| utilize, leverage (verb) | use |
| facilitate | help, let, make easier |
| commence, initiate | start, begin |
| terminate | end, stop, kill |
| purchase | buy |
| endeavor, attempt | try |
| ascertain, determine | find out, work out |
| sufficient | enough |
| additional | more, extra |
| approximately | about, roughly |
| prior to | before |
| subsequent to, following | after |
| in order to | to |
| due to the fact that, owing to the fact that | because |
| at this point in time, currently, presently | now, today |
| in the event that | if |
| with regard to, in relation to, regarding | about, on |
| a number of | several, some, a few |
| the majority of | most |
| a small number of | a few |
| demonstrate | show |
| assist | help |
| obtain, acquire | get |
| provide | give |
| require (where "need" fits) | need |
| the remainder | the rest |
| methodology | method |
| functionality | features, what it does |
| individuals, personnel | people, staff, engineers |
| in close proximity to | near |
| is able to, has the ability to | can |
| is unable to | can't |
| in the near future | soon |
| on a monthly basis | monthly |
| a large proportion of | much of, most of |
| numerous | many |
| commence operation | go live, ship |
| render | make |
| exhibit | show, have |
| component | part, piece |
| implement (as a noun) | tool |
| modify | change |
| construct (verb) | build |
| utilization | use, load |
| optimal | best |
| leverage (noun, non-financial) | advantage, pull |

## Delete on sight

These phrases carry no information. Cut them and start the sentence at the next word.

- It is important to note that…
- It should be noted that…
- It's worth mentioning that…
- As previously mentioned…
- Needless to say…
- At the end of the day…
- In today's fast-paced world…
- When it comes to…
- The fact of the matter is…
- In terms of… (usually recoverable as "in" or "for")
- There is/are … that … ("There are three services that fail" → "Three services fail")

## Banned

Business filler:

going forward, learnings, ideate, operationalize, synergy, best-in-class, world-class, impactful, actionable insights, low-hanging fruit, move the needle, circle back, touch base, boil the ocean, north star, table stakes, drive alignment, socialize (a document), space (as in "the observability space" — say "market" or "field"), deep dive (as a noun), reach out (say "ask," "email," or "call").

LLM tells:

delve, tapestry, landscape (figurative), realm, navigate the complexities, unlock (figurative), empower, seamless, robust (unless it means fault-tolerant and you say so), holistic, game-changer, paradigm shift, testament to, at its core, stands as, plays a crucial role, "not just X, but Y" as a reflex, "it's not about X — it's about Y."

Empty intensifiers. Replace each with the number or scope it stands in for:

critical, massive, devastating, alarming, severe, dramatic, significant, substantial, considerable, extremely, incredibly, highly, very, really.

Downtoners. These weaken whatever follows, so they go only when the word they're softening goes too — see "Three kinds of qualifier" in `SKILL.md`:

quite, rather, somewhat, fairly, relatively, arguably, a bit.

"Significant" has a statistical meaning. Use it only when you mean that, and say so.

Two exceptions to the intensifier ban:

1. **Security prose.** `security-language` prescribes "significant" as the neutral replacement for "catastrophic," "devastating," and "massive." There, it wins, and "significant" is the right word.
2. **No number available.** An intensifier can't be deleted if nothing quantitative replaces it — that would weaken the claim, which the fidelity rules forbid. Keep the author's word and flag that the document needs a number.

## Carve-out: terms of art

The short-word rule targets needless length, not technical vocabulary. Keep a term that carries a defined meaning even when it's long. Substituting a shorter, vaguer word loses information, which the rule never asks for.

Keep as-is: authenticate, authorize, idempotent, provision, deprecate, remediate, ingress, egress, quorum, eventual consistency, least privilege, cardinality, reconciliation, attestation, entitlement, tenancy, federation, immutability.

Keep proper nouns exactly: CVE and CWE identifiers, CVSS scores, product names, RFC numbers, service names, account IDs.

Keep a term the reader's team already uses, even if it's jargon, when swapping it would make the document read as though it came from outside the team.

## Repetition

Say the same thing the same way. If a system is "the dev registry" in paragraph one, it's "the dev registry" in paragraph six — not "the development image store," not "said repository." Elegant variation makes readers wonder whether you mean something new. The Economist is firm on this and so is this skill.

The exception is a genuinely ugly repetition inside one sentence. Recast the sentence rather than reaching for a synonym.
