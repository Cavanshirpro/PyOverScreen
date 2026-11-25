#!/usr/bin/env bash
set -euo pipefail

mode="$1"
archive=PyOverScreen-windows-x64.zip
checksum="$archive.sha256"
artifact_name=PyOverScreen-windows-x64

fail() {
    echo "$1" >&2
    exit 1
}

[[ "$mode" == validate || "$mode" == publish ]] || fail "Unknown release mode."
[[ "$GITHUB_REF" == refs/heads/main ]] || fail "Run the release workflow from main."
[[ "$BUILD_RUN_ID" =~ ^[1-9][0-9]*$ ]] || fail "Enter a numeric build run ID."
[[ "$TAG" =~ ^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-(alpha|beta|rc)\.[1-9][0-9]*)?$ ]] ||
    fail "Use a tag like v1.1.0 or v1.1.0-rc.1."

run="$(gh api "repos/$GITHUB_REPOSITORY/actions/runs/$BUILD_RUN_ID")"
jq -e --arg sha "$GITHUB_SHA" --arg repo "$GITHUB_REPOSITORY" '
    .path == ".github/workflows/build-artifacts.yml" and
    (.event == "push" or .event == "workflow_dispatch") and
    .head_repository.full_name == $repo and .head_branch == "main" and
    .head_sha == $sha and .conclusion == "success"
' <<< "$run" > /dev/null || fail "Choose a successful build from this exact main commit."

assets="$(mktemp -d)"
trap 'rm -rf "$assets"' EXIT
gh run download "$BUILD_RUN_ID" --repo "$GITHUB_REPOSITORY" --name "$artifact_name" --dir "$assets"
[[ -f "$assets/$archive" && -f "$assets/$checksum" ]] || fail "Missing ZIP or checksum."
digest="$(sha256sum "$assets/$archive" | cut -d ' ' -f 1)"
[[ "$(tr -d '\r' < "$assets/$checksum")" == "$digest  $archive" ]] ||
    fail "The supplied checksum does not match the ZIP."

main_sha="$(gh api "repos/$GITHUB_REPOSITORY/branches/main" --jq '.commit.sha')"
[[ "$main_sha" == "$GITHUB_SHA" ]] || fail "Main has advanced. Select a build for the new commit."
tag_count="$(gh api "repos/$GITHUB_REPOSITORY/git/matching-refs/tags/$TAG" |
    jq --arg ref "refs/tags/$TAG" '[.[] | select(.ref == $ref)] | length')"
[[ "$tag_count" == 0 ]] || fail "Tag $TAG already exists."
release_matches="$(gh api --paginate "repos/$GITHUB_REPOSITORY/releases?per_page=100" |
    jq -r --arg tag "$TAG" '.[] | select(.tag_name == $tag) | .id')"
[[ -z "$release_matches" ]] || fail "A release or draft already uses $TAG."

if [[ "$mode" == validate ]]; then
    echo "digest=$digest" >> "$GITHUB_OUTPUT"
    echo "Validated $TAG from run $BUILD_RUN_ID at $GITHUB_SHA."
    exit 0
fi

[[ "$digest" == "$VERIFIED_DIGEST" ]] || fail "The ZIP changed after validation."
flags=()
if [[ "$TAG" == *-* ]]; then
    flags+=(--prerelease --latest=false)
fi
gh release create "$TAG" "$assets/$archive" "$assets/$checksum" \
    --repo "$GITHUB_REPOSITORY" --target "$GITHUB_SHA" --title "PyOverScreen $TAG" \
    --generate-notes "${flags[@]}"
