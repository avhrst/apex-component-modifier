#!/usr/bin/env bash
# validate_export.sh — Automated checks on patched APEX export files
# Usage: bash validate_export.sh <file.sql> [file2.sql ...]
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

errors=0
warnings=0

check_pass() { echo -e "  ${GREEN}PASS${NC} $1"; }
check_fail() { echo -e "  ${RED}FAIL${NC} $1"; ((errors++)); }
check_warn() { echo -e "  ${YELLOW}WARN${NC} $1"; ((warnings++)); }

if [[ $# -eq 0 ]]; then
  echo "Usage: bash validate_export.sh <file.sql> [file2.sql ...]"
  exit 1
fi

for file in "$@"; do
  echo ""
  echo "=== Validating: $file ==="

  if [[ ! -f "$file" ]]; then
    check_fail "File not found: $file"
    continue
  fi

  # 1. begin/end balance
  begins=$(grep -cxF 'begin' "$file" || echo 0)
  ends=$(grep -cxF 'end;' "$file" || echo 0)
  if [[ "$begins" -eq "$ends" ]]; then
    check_pass "begin/end balanced ($begins blocks)"
  else
    check_fail "begin/end IMBALANCED: $begins begin vs $ends end;"
  fi

  # 2. / terminators
  terminators=$(grep -cxF '/' "$file" || echo 0)
  if [[ "$ends" -eq "$terminators" ]]; then
    check_pass "/ terminators match end; count ($terminators)"
  else
    check_warn "/ terminators ($terminators) != end; count ($ends) — check for orphaned or missing /"
  fi

  # 3. set define off
  if grep -q 'set define off' "$file"; then
    check_pass "set define off present"
  else
    check_warn "set define off not found (expected at top of file)"
  fi

  # 4. Unique p_id values
  pid_ids=$(grep -oP 'p_id\s*=>\s*wwv_flow_imp\.id\(\K[0-9]+' "$file" | sort || true)
  if [[ -n "$pid_ids" ]]; then
    pid_dupes=$(echo "$pid_ids" | uniq -d || true)
    pid_count=$(echo "$pid_ids" | wc -l)
    if [[ -z "$pid_dupes" ]]; then
      check_pass "All p_id values are unique ($pid_count component IDs)"
    else
      check_fail "Duplicate p_id values: $pid_dupes"
    fi
  else
    check_warn "No wwv_flow_imp.id() p_id values found"
  fi

  # 5. Cross-reference check
  all_pid_set=$(echo "$pid_ids" | sort -u || true)
  ref_ids=$(grep -oP '(?<!p_id\s)=>\s*wwv_flow_imp\.id\(\K[0-9]+' "$file" | sort -u || true)
  missing=""
  if [[ -n "$ref_ids" ]]; then
    while IFS= read -r rid; do
      if [[ -n "$rid" ]] && ! echo "$all_pid_set" | grep -qxF "$rid"; then
        missing="$missing $rid"
      fi
    done <<< "$ref_ids"
  fi
  if [[ -z "$missing" ]]; then
    check_pass "All cross-referenced IDs resolved (local or shared)"
  else
    check_warn "IDs not defined as p_id in this file (may be shared components):$missing"
  fi

  # 6. wwv_flow_string.join syntax
  join_count=$(grep -c 'wwv_flow_string\.join' "$file" || echo 0)
  if [[ "$join_count" -gt 0 ]]; then
    bad_joins=$(grep 'wwv_flow_string\.join' "$file" | grep -v 'wwv_flow_t_varchar2' || true)
    if [[ -z "$bad_joins" ]]; then
      check_pass "wwv_flow_string.join calls use wwv_flow_t_varchar2 ($join_count occurrences)"
    else
      check_warn "wwv_flow_string.join without wwv_flow_t_varchar2 — check syntax"
    fi
  fi
done

echo ""
echo "=== Summary ==="
echo -e "Errors: ${RED}${errors}${NC}  Warnings: ${YELLOW}${warnings}${NC}"
if [[ "$errors" -gt 0 ]]; then
  exit 1
else
  exit 0
fi
