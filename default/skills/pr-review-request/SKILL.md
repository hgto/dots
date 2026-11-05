---
name: pr-review-request
description: Share a pull request in Traversal's eng-pr-review Slack channel with reviewer mentions when the user asks to request or post a review.
---

Get the current branch's PR with `gh pr view --json number,title,url`, unless
the user supplied a different PR. Use the connected Slack tools to resolve
`eng-pr-review` and the requested reviewers. Ask for reviewers only if the user
has not named them or requested an unassigned review. Resolve ambiguous names
before mentioning anyone; do not rely on cached user IDs.

Post through the available Slack messaging tool only when the user has asked
to share the PR. Use Slack mrkdwn and the exact shape:

```text
<PR_URL|PR_title> <@REVIEWER_ID> <@ANOTHER_REVIEWER_ID>
```

Omit mentions for an unassigned review. Add no prose after the title beyond
reviewer mentions. Preserve the PR title, escaping Slack control characters
where necessary. Return the posted message link or confirm the sent content
only after the tool reports success. If no Slack tool is connected, return
the copy-ready message and explain that it was not sent.
