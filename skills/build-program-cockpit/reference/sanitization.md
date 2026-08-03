# Public-Safe Sanitization

Apply this checklist when the cockpit, skill, template, example, or verification output may be public.

## Never Publish

- Access, ID, refresh, session, API, or authorization tokens
- Passwords, client secrets, private keys, cookies, signed URLs, or credentials
- Terraform state, binary plans, unredacted plan output, secret values, or database dumps
- Private customer data, user data, support transcripts, or incident chat transcripts
- Internal account, tenant, cluster, hosted-zone, organization, or resource identifiers
- Private repository URLs, branch names, commit IDs, ticket IDs, incident IDs, email addresses, or personal names unless explicitly approved
- Internal hostnames, domains, IPs, VPN details, or architecture coordinates
- Proprietary source code or exact private configuration

## Replace With Stable Placeholders

Use:

- `<PROGRAM_NAME>`
- `<ORGANIZATION>`
- `<REPOSITORY_URL>`
- `<DEFAULT_BRANCH>`
- `<PR_NUMBER>`
- `<COMMIT_SHA>`
- `<ENVIRONMENT>`
- `<ACCOUNT_ID>`
- `<TENANT_ID>`
- `<DOMAIN>`
- `<RESOURCE_ID>`
- `<INCIDENT_URL>`
- `<TRACKER_URL>`
- `<OWNER_ROLE>`

Do not use realistic fake secrets. Use `<REDACTED_SECRET>`.

## Collection Rules

- Prefer links and summaries over copied bodies.
- Copy only the sections needed for offline context.
- Redact before writing to disk, not afterward.
- Preserve source provenance and capture limitations.
- Do not reconstruct deleted or unavailable evidence.
- Do not use a public cockpit as the execution ledger for a private program.

## Security Prose

- State observed facts separately from assessment.
- Use neutral terms such as finding, weakness, condition, or incident.
- Avoid attribution, intent claims, legal/compliance conclusions, and absolutes.
- Attribute a causal claim to its source when it has not been independently verified.
- Describe systems and processes, not personal fault.

## Automated Checks

The verifier checks text artifacts for common secret patterns, private keys, JWT-shaped strings, and caller-supplied forbidden literals. It warns on binary files that need manual review. It cannot prove sanitization.

Before release:

1. Run the verifier with every known private organization/domain/repository/customer literal via `--forbid`.
2. Search git history, not only the working tree.
3. Review generated files and attachments manually.
4. Check screenshots, PDFs, JSON, logs, and comments.
5. Confirm source URLs are public or intentionally omitted.
6. Have a second reviewer inspect the release diff.

If uncertain whether a value is sensitive, remove it or keep the artifact private.
