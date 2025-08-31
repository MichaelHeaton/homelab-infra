---
icon: material/flag-checkered
hide: []
---

# Release Policy (Tags off `main`)

## Overview
- Source of truth: `main` branch.
- Releases are **annotated git tags** on `main` (format: `vMAJOR.MINOR.PATCH`).
- No long‑lived release branches. Only `main` and `gh-pages` exist.

## Preconditions
- `main` is green in CI.
- Local tree is clean and on `main`.
- You have push access to tags.

## Create a release tag
```bash
# pick the next version
export TAG=v0.1.0

# from repo root
git checkout main
git pull --ff-only

git tag -a "$TAG" -m "$TAG"
git push origin "$TAG"
```

## Optional: GitHub Release from the tag
```bash
# requires GitHub CLI (gh)
gh release create "$TAG" --generate-notes --latest
```

## Versioning
- Use Semantic Versioning: **MAJOR.MINOR.PATCH**.
- Bump **MAJOR** for incompatible changes, **MINOR** for backwards-compatible docs/features, **PATCH** for fixes.

## Rollback
```bash
# remove the remote tag (be careful)
git push origin :refs/tags/$TAG
# remove local tag
git tag -d $TAG
```

## Verify
- Tag appears at https://github.com/MichaelHeaton/homelab-infra/tags
- Pages build still passes.

---

.PHONY: release release-dry-run release-gh

## Create an annotated tag from main and push it
```bash
# Usage: make release TAG=v0.1.0
```

release:
	@test -n "$(TAG)" || (echo "TAG required, e.g., make release TAG=v0.1.0" && exit 1)
	@current=$$(git rev-parse --abbrev-ref HEAD); \
	 if [ "$$current" != "main" ]; then echo "checkout main (current: $$current)" && exit 1; fi
	@status=$$(git status --porcelain); \
	 if [ -n "$$status" ]; then echo "working tree dirty" && exit 1; fi
	@git fetch origin && git pull --ff-only
	@git tag -a $(TAG) -m "$(TAG)"
	@git push origin $(TAG)
	@echo "Tag $(TAG) pushed to origin"

## Dry-run helper
release-dry-run:
	@echo "Would tag current main as $(TAG) and push to origin"

## Optional: create a GitHub Release from the tag (requires gh)
```bash
# Usage: make release-gh TAG=v0.1.0
```

release-gh:
	@test -n "$(TAG)" || (echo "TAG required, e.g., make release-gh TAG=v0.1.0" && exit 1)
	@command -v gh >/dev/null 2>&1 || (echo "GitHub CLI 'gh' not found" && exit 1)
	@gh release create $(TAG) --generate-notes --latest
	@echo "GitHub Release created for $(TAG)"
