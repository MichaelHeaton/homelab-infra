---
hide: []
---

# Resolve Git Merge Conflicts (Runbook)

## 1. Summary
- **Purpose:** Resolve a simple one-file conflict in a feature branch, keep branch protections intact.
- **Scope:** Typical docs conflicts (e.g., `mkdocs.yml`).

## 2. Preconditions
- Local clone with `origin` pointing to GitHub.
- Feature branch checked out, e.g., `docs/mkdocs-scaffold`.

## 3. Diagnosis
- PR shows: *"This branch has conflicts that must be resolved"*.
- File shows conflict markers `<<<<<<<`, `=======`, `>>>>>>>`.

## 4. Remediation A — Merge main into feature (safe)
```bash
# from your feature branch
git fetch origin
git merge origin/main
# edit conflicted files, keep the intended blocks
git add mkdocs.yml  # and any others
git commit -m "fix: resolve merge conflicts"
git push
```

## 5. Remediation B — Rebase feature onto main (linear history)
```bash
git fetch origin
git rebase origin/main
# resolve conflicts as they arise
git add <file>
git rebase --continue
# may require force-with-lease
git push --force-with-lease
```

## 6. Validation
- CI checks pass.
- PR shows *"This branch has no conflicts"*.
- Site builds and renders locally: `mkdocs serve -a 0.0.0.0:8000`.

## 7. Notes
- Prefer **merge** for simplicity on shared branches.
- Prefer **rebase** for a clean, linear history on personal branches.
