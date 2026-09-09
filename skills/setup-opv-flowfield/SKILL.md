---
name: setup-opv-flowfield
description: Install, connect, update or verify Flowfield OPV in Claude using Google sign-in.
---

# Set up Flowfield: OPV

Use supported Claude plugin and connector controls. Never edit caches, registries
or OAuth storage directly. Marketplace: `flowfieldai/opv-flowfield-plugin`.
Plugin ID: `opv-flowfield@flowfield-opv`. Display name: **Flowfield: OPV**.
Endpoint: `https://opv-mcp-469120274566.us-south1.run.app/mcp`.
No custom headers or client secrets are required.

In Desktop/Cowork/Chat, install the plugin from the repository marketplace,
open its connector, and connect with **josh@outperformventures.com**. Google may
require phone verification. Other team members are not provisioned yet. Google
may show the service hostname until separate brand verification is complete.

In Claude Code, inspect `claude plugin list --json` and `claude mcp list`.
Authenticate with `claude mcp login 'plugin:opv-flowfield:opv-flowfield'`.
Reload plugins or start a new session after an installation/update. Never ask
for a password or paste a bearer token into chat.

Discover the tools, then verify source status, one hybrid search, a returned
read, and a literal text search under the authenticated identity. Include the
original human request in `prompt_origin` for every call. Report installation,
authentication and successful tool checks separately. If phone verification is
pending, state that authentication has not yet been verified.
