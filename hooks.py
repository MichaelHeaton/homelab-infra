# MkDocs hook to inject shared abbreviation definitions into every page
# Requires: mkdocs.yml -> hooks: [hooks.py]
# Reads: docs/includes/abbreviations.md
# MkDocs hook to inject shared abbreviation definitions into every page
# Enable in mkdocs.yml:
#   hooks:
#     - hooks.py
#
# Reads shared abbreviations from: docs/includes/abbreviations.md
# Behavior:
# - Appends the abbreviations block to every Markdown page at render time.
# - Skips if the page already includes the snippet, already defines any abbreviations,
#   or opts out via front-matter: `no_abbr: true`.

from pathlib import Path
import re
from typing import Optional

_ABBR_CACHE: Optional[str] = None
_ABBR_PATH_CACHE: Optional[Path] = None

_ABBR_DEFINITION_RE = re.compile(r"(?m)^\*\[[^]]+\]:")  # e.g., *[IaC]: ...

def _load_shared_abbreviations(config) -> str:
    """Load shared abbreviations text once per build."""
    global _ABBR_CACHE, _ABBR_PATH_CACHE
    if _ABBR_CACHE is not None:
        return _ABBR_CACHE

    docs_dir = Path(config.get("docs_dir", "docs"))
    abbr_path = docs_dir / "includes" / "abbreviations.md"
    _ABBR_PATH_CACHE = abbr_path

    if not abbr_path.exists():
        _ABBR_CACHE = ""
        return _ABBR_CACHE

    text = abbr_path.read_text(encoding="utf-8").strip()
    _ABBR_CACHE = text if text else ""
    return _ABBR_CACHE

def on_page_markdown(markdown, page, config, files):
    # Skip non-Markdown pages
    src = getattr(page.file, "src_uri", "")
    if not src.endswith(".md"):
        return markdown

    # Skip the includes folder and the abbreviations file itself
    if src.startswith("includes/") or src.endswith("includes/abbreviations.md"):
        return markdown

    # Allow opt-out via front matter: `no_abbr: true`
    if getattr(page, "meta", {}).get("no_abbr", False):
        return markdown

    abbr_text = _load_shared_abbreviations(config)
    if not abbr_text:
        return markdown

    # If the page already includes the snippet explicitly, skip
    if '--8<-- "includes/abbreviations.md"' in markdown:
        return markdown

    # If the page already defines any abbreviation lines, skip
    if _ABBR_DEFINITION_RE.search(markdown):
        return markdown

    # Append shared abbreviations with a separating newline
    return f"{markdown.rstrip()}\n\n{abbr_text}\n"