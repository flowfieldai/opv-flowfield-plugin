#!/bin/sh
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/opv-flowfield-installer-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

cat >"$TEST_ROOT/claude-stub" <<'STUB'
#!/bin/sh
set -eu
STATE_DIR="${CLAUDE_STUB_STATE:?}"
printf '%s\n' "$*" >>"$STATE_DIR/calls.log"

case "$*" in
  "--version") printf '%s\n' "2.1.207 (Claude Code)" ;;
  "plugin marketplace list --json")
    if [ -f "$STATE_DIR/marketplace" ]; then
      printf '%s\n' '[{"name":"flowfield-opv"}]'
    else
      printf '%s\n' '[]'
    fi
    ;;
  "plugin marketplace add flowfieldai/opv-flowfield-plugin --scope user")
    : >"$STATE_DIR/marketplace"
    ;;
  "plugin marketplace update flowfield-opv") : ;;
  "plugin list --json")
    if [ -f "$STATE_DIR/plugin" ]; then
      printf '%s\n' '[{"id":"opv-flowfield@flowfield-opv","version":"0.1.4","scope":"user","enabled":true}]'
    else
      printf '%s\n' '[]'
    fi
    ;;
  "plugin install opv-flowfield@flowfield-opv --scope user")
    : >"$STATE_DIR/plugin"
    ;;
  "plugin update opv-flowfield@flowfield-opv --scope user") : ;;
  "mcp login plugin:opv-flowfield:opv-flowfield")
    if [ -f "$STATE_DIR/login-fail" ]; then
      exit 1
    fi
    : >"$STATE_DIR/logged-in"
    ;;
  "mcp list")
    if [ -f "$STATE_DIR/logged-in" ]; then
      printf '%s\n' 'plugin:opv-flowfield:opv-flowfield: Connected'
    else
      printf '%s\n' 'plugin:opv-flowfield:opv-flowfield: Needs authentication'
    fi
    ;;
  *)
    printf 'Unexpected Claude stub invocation: %s\n' "$*" >&2
    exit 64
    ;;
esac
STUB
chmod +x "$TEST_ROOT/claude-stub"

CLAUDE_STUB_STATE="$TEST_ROOT" CLAUDE_BIN="$TEST_ROOT/claude-stub" FLOWFIELD_INSTALLER_SKIP_OAUTH=1 sh "$REPO_ROOT/install-claude-code.sh" >/dev/null
grep -Fq 'plugin marketplace add flowfieldai/opv-flowfield-plugin --scope user' "$TEST_ROOT/calls.log"
grep -Fq 'plugin install opv-flowfield@flowfield-opv --scope user' "$TEST_ROOT/calls.log"

: >"$TEST_ROOT/calls.log"
CLAUDE_STUB_STATE="$TEST_ROOT" CLAUDE_BIN="$TEST_ROOT/claude-stub" FLOWFIELD_INSTALLER_SKIP_OAUTH=1 sh "$REPO_ROOT/install-claude-code.sh" >/dev/null
grep -Fq 'plugin marketplace update flowfield-opv' "$TEST_ROOT/calls.log"
grep -Fq 'plugin update opv-flowfield@flowfield-opv --scope user' "$TEST_ROOT/calls.log"

: >"$TEST_ROOT/calls.log"
CLAUDE_STUB_STATE="$TEST_ROOT" CLAUDE_BIN="$TEST_ROOT/claude-stub" sh "$REPO_ROOT/install-claude-code.sh" >/dev/null
grep -Fq 'mcp login plugin:opv-flowfield:opv-flowfield' "$TEST_ROOT/calls.log"
grep -Fq 'mcp list' "$TEST_ROOT/calls.log"

rm -f "$TEST_ROOT/logged-in"
: >"$TEST_ROOT/login-fail"
if CLAUDE_STUB_STATE="$TEST_ROOT" CLAUDE_BIN="$TEST_ROOT/claude-stub" sh "$REPO_ROOT/install-claude-code.sh" >/dev/null 2>&1; then
  printf '%s\n' "Installer unexpectedly accepted a failed OAuth command." >&2
  exit 1
fi

if CLAUDE_BIN="$TEST_ROOT/missing-claude" sh "$REPO_ROOT/install-claude-code.sh" >/dev/null 2>&1; then
  printf '%s\n' "Installer unexpectedly accepted a missing Claude executable." >&2
  exit 1
fi

printf '%s\n' "Flowfield OPV Claude Code installer tests passed."
