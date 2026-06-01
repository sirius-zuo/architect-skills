# Output Contract — architect-design-review

This document is the stable interface specification for `architect-design-review`. Orchestrating skills and downstream consumers can rely on this contract across minor updates to the skill's workflow.

---

## Output path

```
docs/architecture/review/YYYY-MM-DD-<project>-design-architecture.html
```

- `YYYY-MM-DD` is the date the skill was run (ISO 8601)
- `<project>` is derived using the **project name derivation** rules below
- The file is always written relative to the directory where the skill is invoked

## Project name derivation

The skill checks these sources in order and uses the first match:

1. `name` field in `package.json` at the project root
2. Module name in `go.mod` at the project root
3. `name` field in `Cargo.toml` at the project root
4. The root directory name

**Sanitization:** Before using the derived name in the file path, the skill strips: `/`, `\`, `..` sequences, null bytes (`\0`), and leading dots. If the name is empty after sanitization, the skill falls back to the root directory name.

## Guaranteed HTML section IDs

The output HTML file is guaranteed to contain these wrapper anchors, in this order relative to dynamic criteria sections:

| Section ID | Content |
|---|---|
| `#summary` | Executive summary (2-3 sentences on what the system is and key architectural choices) |
| `#diagrams` | Architecture diagrams (System Context, Component, and any user-confirmed additional diagrams) |
| dynamic criteria anchors | One section per applicable reviewable `##` heading in `architecture-principles.md`, in document order |
| `#recommendations` | Numbered actionable improvements synthesizing all dynamic criteria findings |

Dynamic criteria anchors are generated from headings by lowercasing, replacing non-alphanumeric sequences with `-`, trimming leading/trailing `-`, and appending `-2`, `-3`, and so on for duplicates.

Examples:

| Principle heading | Generated anchor |
|---|---|
| `Security` | `#security` |
| `Cost Efficiency (FinOps)` | `#cost-efficiency-finops` |
| `API Architecture` | `#api-architecture` |

## Side effects

The skill takes exactly these filesystem actions, in this order:

1. **Read-only:** Reads the spec file from `docs/superpowers/specs/` (most recent, or specified path)
2. **Read-only:** Reads up to 3 documents referenced by the spec (depth 1 only)
3. **Read-only:** Reads `../architect-shared/architecture-principles.md`, `../architect-shared/dynamic-review-framework.md`, `../architect-shared/diagram-selection.md`, and `../architect-shared/html-template.md`
4. **Write:** `mkdir -p docs/architecture/review`
5. **Write:** Writes the HTML report to the output path (overwrites if file already exists)

**No spec or source files are ever modified.** The only writes are the mkdir and the HTML file.

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `spec-path` | No | Most-recently-modified `.md` in `docs/superpowers/specs/` | Path to the spec file to review |

## Known limitations

- No machine-parsable output format — output is HTML only
- Referenced document reads are capped: maximum depth 1, maximum 3 documents; additional references are noted but not read
- Input size limit: for specs >8k tokens, the skill uses summarization; the report will note this
- Additional diagram count is capped at 5 user-confirmed diagrams per run
