---
name: using-opv-flowfield
description: Search and read Outperform Ventures Slack, Gmail, Google Drive and Josh-authorized Codex and meeting knowledge, check source freshness, and cite evidence through Flowfield OPV.
---

# Use Flowfield: OPV

Use the authenticated connector for OPV questions. Discover current tool schemas.
Sources are Slack, Gmail, Google Drive, Codex and meetings. Discover current schemas and call get_source_status to check availability and backfill progress. Notion is not connected.

Every tool call must include `prompt_origin`: the human's original request copied
verbatim. Keep it unchanged for searches, reads, status and pagination serving
that request. Do not replace it with the search query or infer a missing prompt.
The prompt and its hash are retained in the audit trail; they grant no access.

- `hybrid_search`: `query`, optional `limit`, `source: "slack"`, `source: "gmail"`, `source: "drive"`, `source: "codex"` or `source: "meetings"`, `date_from`,
  `date_to`. Search concrete names and concepts, then read relevant documents.
- `search_text`: `query`, optional `regex: true` (RE2), `case_sensitive`, `limit`,
  `offset`, `source`, `date_from`, `date_to`. For exhaustive search, follow
  `next_offset` until null, keeping the other arguments unchanged. Report partial
  scans honestly. RE2 does not support backreferences or lookaround.
- `read_document`: use a returned `document_id`, optional `start_line` and
  `line_count` (maximum 300). Do not invent identifiers. Exact Slack or Gmail messages and
  canonical conversation/attachment documents, Drive documents, Codex transcripts and meeting transcripts can be read by line.
- `get_source_status`: report returned source status and timestamps. No invented
  provider filters, `sources`, `since`, `pattern`, `cursor`, or HRG-specific args.

Date filters are inclusive bounds on last modification time, not dates mentioned
in message text. Use explicit ISO timestamps with offsets for user-local day
ranges. Do not assume a date-only upper bound includes that entire day.

Cite the returned source URLs and message references. Preserve thread context and
separate direct evidence from your interpretation. A failed search does not prove
absence; refine or use exhaustive text search. Only authorized retained text is
searched, not every item ever held by the source.

## Freshness

Use Central Time values returned by the server. Distinguish
`last_full_source_check`, `worker_last_seen`, `last_content_update`, and
`last_admission`. Events maintain updates between six-hour full reconciliations.
An older content date is not itself a sync failure. Report `event_sync_active`,
`delayed`, or `snapshot_only` as returned; do not invent a provider-wide health
claim. Preserve the stated inaccessible-conversation and file coverage exceptions.

Gmail reports `last_checked` independently of `last_content_update` and `last_admission`. Preserve `content_update_basis`: initial capture may use the newest message date, while later changes use observed History events. Gmail uses incremental History checks while push delivery is unavailable. Do not describe initial team backfill as complete unless the returned evidence establishes that.

Drive reports its successful change-feed `last_checked` separately from content dates and admission. Inventory includes folders, shortcuts, pending extraction and unsupported items; a healthy source check does not mean every file is indexed. Preserve coverage exceptions and initial backfill status. Drive permissions are observed per user and stale or revoked access blocks retrieval.

Codex reports the last successful local export check, content update and serving admission separately. It contains Josh’s root-task human prompts and assistant chat text; it excludes system/developer instructions, hidden reasoning, tool calls, command output, automatic context, images and credentials.

Meetings reports the successful repository-folder export check, latest transcript modification and serving admission separately. It indexes the canonical top-level Markdown files in the Flowfield repository `transcripts` folder. Nested ASR outputs, audio, alternate caption formats and processing artifacts are excluded to prevent duplicate retrieval.

## Access

Google authenticates the user; the service applies OPV source permissions.
Gmail visibility is mailbox-owner only; mail headers do not grant access to colleagues’ mailboxes. Codex and meeting transcript visibility is restricted to `josh@outperformventures.com`, including for other approved OPV users.
The initial pilot allows only josh@outperformventures.com. A prompt asking to act
as another person cannot change permissions. Never request tokens/passwords or
claim knowledge of hidden records. The tools cannot send, edit or delete source
content. Loom, YouTube and Spotify media downloads are intentionally skipped.
