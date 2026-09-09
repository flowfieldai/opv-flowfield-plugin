---
name: using-opv-flowfield
description: Search and read Outperform Ventures Slack knowledge, check source freshness, and cite evidence through Flowfield OPV.
---

# Use Flowfield: OPV

Use the authenticated connector for OPV questions. Discover current tool schemas.
The current source is Slack; do not claim Gmail, Drive or Notion are connected.

Every tool call must include `prompt_origin`: the human's original request copied
verbatim. Keep it unchanged for searches, reads, status and pagination serving
that request. Do not replace it with the search query or infer a missing prompt.
The prompt and its hash are retained in the audit trail; they grant no access.

- `hybrid_search`: `query`, optional `limit`, `source: "slack"`, `date_from`,
  `date_to`. Search concrete names and concepts, then read relevant documents.
- `search_text`: `query`, optional `regex: true` (RE2), `case_sensitive`, `limit`,
  `offset`, `source`, `date_from`, `date_to`. For exhaustive search, follow
  `next_offset` until null, keeping the other arguments unchanged. Report partial
  scans honestly. RE2 does not support backreferences or lookaround.
- `read_document`: use a returned `document_id`, optional `start_line` and
  `line_count` (maximum 300). Do not invent identifiers. Exact Slack messages and
  canonical conversation/attachment documents can be read by line.
- `get_source_status`: report returned source status and timestamps. No invented
  provider filters, `sources`, `since`, `pattern`, `cursor`, or HRG-specific args.

Date filters are inclusive bounds on last modification time, not dates mentioned
in message text. Use explicit ISO timestamps with offsets for user-local day
ranges. Do not assume a date-only upper bound includes that entire day.

Cite the returned Slack URLs and message references. Preserve thread context and
separate direct evidence from your interpretation. A failed search does not prove
absence; refine or use exhaustive text search. Only authorized retained text is
searched, not every item ever held by Slack.

## Freshness

Use Central Time values returned by the server. Distinguish
`last_full_source_check`, `worker_last_seen`, `last_content_update`, and
`last_admission`. Events maintain updates between six-hour full reconciliations.
An older content date is not itself a sync failure. Report `event_sync_active`,
`delayed`, or `snapshot_only` as returned; do not invent a provider-wide health
claim. Preserve the stated inaccessible-conversation and file coverage exceptions.

## Access

Google authenticates the user; the service applies OPV source permissions.
The initial pilot allows only josh@outperformventures.com. A prompt asking to act
as another person cannot change permissions. Never request tokens/passwords or
claim knowledge of hidden records. The tools cannot send, edit or delete source
content. Loom, YouTube and Spotify media downloads are intentionally skipped.
