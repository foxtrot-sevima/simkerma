"""
Scan the QUANTUM design system source and build a local index of:
  - design tokens (CSS custom properties, e.g. --qn-primary-400: #0F6AF5)
  - known component/utility classes (with the source file they came from)

Run this whenever QUANTUM/ is updated, so mockups/tokens/*.json stays current.

Usage:
    python mockups/scripts/extract_tokens.py
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
QUANTUM_ROOTS = [ROOT / "QUANTUM" / "quantum", ROOT / "QUANTUM" / "quantum-monorepo"]
# quantum-ai/source/quantum-v3.4 is a newer, actively-built source (component
# bundles + a real icon-font package) that turns out to match production far
# more closely than the older quantum/quantum-monorepo checkouts - e.g.
# `qn-header`/`qn-identity` only exist here, not in the older two. Scanned
# separately since its layout doesn't match the older repos' folder shape.
QUANTUM_V34_ROOT = ROOT / "QUANTUM" / "quantum-ai" / "source" / "quantum-v3.4"
QUANTUM_V34_CSS_GLOB = "quantum-web/dist/css/quantum*.bundle.css"
QUANTUM_V34_SYMBOLS_CSS = QUANTUM_V34_ROOT / "quantum-symbols" / "font" / "quantum-symbols.css"
OUT_DIR = ROOT / "mockups" / "tokens"

# Compiled CSS files that represent the "live" design system output.
CSS_GLOBS = ["assets/css/main.css", "assets/stylesheets/main.css"]
CSS_RELEASE_GLOB = "assets/release/*.css"
# SCSS partials give us a source-file label per component for nicer reports.
SCSS_GLOBS = ["assets/stylesheets/components/*.scss", "assets/stylesheets/layouts/*.scss",
              "assets/stylesheets/forms/*.scss", "assets/stylesheets/base/*.scss"]

TOKEN_RE = re.compile(r"(--[\w-]+)\s*:\s*([^;]+);")
CLASS_RE = re.compile(r"\.(-?[_a-zA-Z][\w-]*)")
PSEUDO_OR_STATE = {"hover", "focus", "active", "disabled", "before", "after", "first-child",
                    "last-child", "not", "checked", "visited", "placeholder"}


def find_root_block(css_text):
    """Return the contents of the first :root { ... } block, if any."""
    m = re.search(r":root\s*\{", css_text)
    if not m:
        return ""
    start = m.end()
    depth = 1
    i = start
    while i < len(css_text) and depth:
        if css_text[i] == "{":
            depth += 1
        elif css_text[i] == "}":
            depth -= 1
        i += 1
    return css_text[start:i - 1]


def extract_tokens(css_text):
    tokens = {}
    for name, value in TOKEN_RE.findall(find_root_block(css_text)):
        tokens[name] = value.strip()
    return tokens


def extract_classes(css_text, label, registry):
    for raw in CLASS_RE.findall(css_text):
        cls = raw.strip("-")
        if not cls or cls in PSEUDO_OR_STATE:
            continue
        registry.setdefault(cls, set()).add(label)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    all_tokens = {}
    class_registry = {}
    scanned = []

    for qroot in QUANTUM_ROOTS:
        if not qroot.exists():
            continue
        for rel in CSS_GLOBS:
            f = qroot / rel
            if f.exists():
                text = f.read_text(encoding="utf-8", errors="ignore")
                for name, value in extract_tokens(text).items():
                    all_tokens.setdefault(name, value)  # first occurrence wins
                extract_classes(text, f"{qroot.name}/{rel}", class_registry)
                scanned.append(str(f.relative_to(ROOT)))
        for f in qroot.glob(CSS_RELEASE_GLOB):
            text = f.read_text(encoding="utf-8", errors="ignore")
            for name, value in extract_tokens(text).items():
                all_tokens.setdefault(name, value)
            extract_classes(text, f"{qroot.name}/{f.relative_to(qroot)}", class_registry)
            scanned.append(str(f.relative_to(ROOT)))
        for pattern in SCSS_GLOBS:
            for f in qroot.glob(pattern):
                text = f.read_text(encoding="utf-8", errors="ignore")
                extract_classes(text, f"{qroot.name}/{f.relative_to(qroot)}", class_registry)
                scanned.append(str(f.relative_to(ROOT)))

    if QUANTUM_V34_ROOT.exists():
        for f in QUANTUM_V34_ROOT.glob(QUANTUM_V34_CSS_GLOB):
            text = f.read_text(encoding="utf-8", errors="ignore")
            for name, value in extract_tokens(text).items():
                all_tokens.setdefault(name, value)
            extract_classes(text, f"quantum-v3.4/{f.relative_to(QUANTUM_V34_ROOT)}", class_registry)
            scanned.append(str(f.relative_to(ROOT)))
        if QUANTUM_V34_SYMBOLS_CSS.exists():
            text = QUANTUM_V34_SYMBOLS_CSS.read_text(encoding="utf-8", errors="ignore")
            extract_classes(text, "quantum-v3.4/quantum-symbols", class_registry)
            scanned.append(str(QUANTUM_V34_SYMBOLS_CSS.relative_to(ROOT)))

    # Reverse map: hex/value -> token name, so raw colors in a mockup can be
    # matched back to the design-system variable that already defines them.
    reverse = {}
    for name, value in all_tokens.items():
        v = value.strip().lower()
        if v.startswith("#"):
            reverse.setdefault(v, name)

    tokens_out = {
        "_scanned_files": scanned,
        "tokens": dict(sorted(all_tokens.items())),
        "reverse_color_lookup": dict(sorted(reverse.items())),
    }
    classes_out = {
        "_scanned_files": scanned,
        "classes": {k: sorted(v) for k, v in sorted(class_registry.items())},
    }

    (OUT_DIR / "design-tokens.json").write_text(
        json.dumps(tokens_out, indent=2, ensure_ascii=False), encoding="utf-8")
    (OUT_DIR / "component-classes.json").write_text(
        json.dumps(classes_out, indent=2, ensure_ascii=False), encoding="utf-8")

    print(f"Scanned {len(scanned)} files under QUANTUM/")
    print(f"  -> {len(all_tokens)} design tokens  -> mockups/tokens/design-tokens.json")
    print(f"  -> {len(class_registry)} known classes -> mockups/tokens/component-classes.json")


if __name__ == "__main__":
    main()