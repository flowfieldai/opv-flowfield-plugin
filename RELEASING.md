# Releasing Flowfield: OPV

Canonical source: `plugins/opv-flowfield` in private `flowfieldai/flowfield`.
Public distribution: `flowfieldai/opv-flowfield-plugin`. Do not author changes
in the distribution mirror or push plugin changes directly to either main branch.

1. Change canonical source on a branch; bump plugin, marketplace and installer
   release references together. Update the root internal marketplace version.
2. Validate JSON, run installer tests, `claude plugin validate .`, and package
   archives with `scripts/package-release.sh VERSION ABSOLUTE_OUTPUT_DIR`.
3. Open, review and merge the canonical version-bump PR.
4. Copy only this canonical plugin directory to a branch of the public mirror.
   Open, review and merge its version-bump PR. This initial distribution uses
   an explicit operator-driven mirror PR; no cross-repository secret is needed.
5. The public GitHub workflow validates and creates the tag/release/assets after
   merge using its repository-scoped GitHub token. Verify remote versions and
   asset checksums. Never equate a release with marketplace sync or user sign-in.

No secrets, source data, custom MCP headers, or tenant permission overrides belong
in this package. Future changes follow `skills/publish-plugin-updates/SKILL.md`
in the canonical repository.
