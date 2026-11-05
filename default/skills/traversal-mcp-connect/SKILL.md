---
name: traversal-mcp-connect
description: Connect or repair the Traversal investigation MCP in Codex using the official 1Password Environment mount, without persisting credentials.
---

Use only the official 1Password MCP. On this Mac its bundled executable is
`/Applications/1Password.app/Contents/MacOS/1password-mcp`; the `/usr/local/bin`
alias may be inaccessible. Read `1password://docs/getting-started` and
`1password://docs/environments-guide`, inspect available tool schemas, and call
`authenticate` before any Environment tools. If the official server is
unavailable or authentication fails, stop and report that blocker.

The Environment is `Traversal MCP prod saas`, ID
`nwzbs5o5mrypqhutmheg76amyi`. Use the authenticated account ID and the actual
`list_local_env_files` schema to verify its mount at
`~/.config/traversal-mcp/.env`. If a mount must be created, use the official
`create_local_env_file` tool. Verify it is a FIFO before any read. Never use
the `op` CLI, ask for a pasted key, or read a regular plaintext file.

Configure Codex's HTTP server at `https://api.prod.traversal.com/mcp/` with
`http_headers_helper` pointing to this skill's `headers-helper.py`. The helper
reads only the verified FIFO and returns header JSON directly to the MCP
client. Never print, log, or manually display its output. Do not configure
static headers or a literal token. The Environment must have been authenticated
and approved through the official MCP before consuming the FIFO.

Reconnect the server after authentication. Verify initialization and tool
discovery without dispatching an investigation. A continuing 401 after a
successful mount read means the stored credential needs repair through the
secret manager; do not request an exported value.

For investigations, use `wait=false` and poll the available status tool rather
than holding a blocking tool call open.
