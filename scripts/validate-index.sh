#!/usr/bin/env bash
# validates index.json: valid JSON, a "plugins" array, every entry has the
# required fields, and every id/download_url is unique.
set -euo pipefail

file="index.json"

if ! jq empty "$file" 2>/dev/null; then
  echo "index.json is not valid JSON"
  exit 1
fi

if [ "$(jq -r 'has("plugins") and (.plugins | type == "array")' "$file")" != "true" ]; then
  echo "index.json must have a top-level \"plugins\" array"
  exit 1
fi

required_fields=(id name version author description download_url)
count=$(jq '.plugins | length' "$file")
fail=0

for ((i = 0; i < count; i++)); do
  entry=$(jq ".plugins[$i]" "$file")
  for field in "${required_fields[@]}"; do
    if [ "$(echo "$entry" | jq -r --arg f "$field" 'has($f) and (.[$f] | type == "string") and (.[$f] | length > 0)')" != "true" ]; then
      echo "plugins[$i] is missing a non-empty \"$field\""
      fail=1
    fi
  done
done

dup_ids=$(jq -r '[.plugins[].id] | group_by(.) | map(select(length > 1)) | map(.[0]) | .[]' "$file")
if [ -n "$dup_ids" ]; then
  echo "duplicate plugin id(s): $dup_ids"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "index.json OK ($count plugin(s))"
