# Flowfield: OPV

Official Claude plugin for Outperform Ventures knowledge. The sources are
Slack and Gmail, including extracted attachments. Drive and Notion are
not yet enabled. This package contains no customer content or credentials.

## Install in Claude Desktop, Cowork, or Chat

1. Open **Customize → Plugins → Add marketplace → Add from a repository**.
2. Enter `flowfieldai/opv-flowfield-plugin`.
3. Install **Flowfield: OPV**.
4. Open its connector and select **Connect**.
5. Sign in with **josh@outperformventures.com** and complete Google's verification.

The initial pilot is Josh-only. Installing the plugin does not grant access to
other users or to private conversations outside the signed-in user's policy.
Google may display the service hostname until its separate brand verification.

If prompted for a connector name, use **Flowfield: OPV**. The endpoint is
`https://opv-mcp-469120274566.us-south1.run.app/mcp`. No custom headers are needed.
An existing connection may be reused by Claude; do not create duplicate entries.

## Tools

Four read-only tools: `hybrid_search`, `search_text`, `read_document`, and
`get_source_status`. Every call requires the original human request in
`prompt_origin`. The bundled skills explain the current OPV schemas, source and
date filters, exhaustive pagination, citations, and Central Time freshness.

Try: “Use Flowfield: OPV to check Slack freshness, search for an investment
conversation, and read the most relevant result with its Slack source link.”

## Claude Code

```sh
curl --proto '=https' --tlsv1.2 -fsS https://raw.githubusercontent.com/flowfieldai/opv-flowfield-plugin/v0.1.1/install-claude-code.sh | sh
```

Reload plugins or start a new session afterward. The installer uses normal OAuth
and never asks for a password or token. Release downloads also include `.plugin`,
`.zip`, and SHA-256 checksums.

## Updates and security

Package updates ship through merged version-bump pull requests. Marketplace sync,
installation, and connector sign-in are separate steps; a release does not prove
that an existing user's installation updated. Runtime improvements can ship
without a plugin release. Authentication and source permissions remain enforced
by the hosted OPV service. All four tools are read-only.
