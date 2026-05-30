# Output Contract — architect-codebase-review

This document is the stable interface specification for `architect-codebase-review`. Orchestrating skills and downstream consumers can rely on this contract across minor updates to the skill's workflow.

---

## Output path

```
docs/architecture/review/YYYY-MM-DD-<project>-codebase-architecture.html
```

- `YYYY-MM-DD` is the date the skill was run (ISO 8601)
- `<project>` is derived using the **project name derivation** rules below
- The file is always written relative to the directory where the skill is invoked (the codebase root)

## Project name derivation

The skill checks these sources in order and uses the first match:

1. `name` field in `package.json` at the codebase root
2. Module name in `go.mod` at the codebase root (the part after `module `)
3. `name` field in `Cargo.toml` at the codebase root
4. The root directory name

**Sanitization:** Before using the derived name in the file path, the skill strips: `/`, `\`, `..` sequences, null bytes (`\0`), and leading dots. If the name is empty after sanitization, the skill falls back to the root directory name.

## Guaranteed HTML section IDs

The output HTML file is guaranteed to contain these anchors, in this order:

| Section ID | Content |
|---|---|
| `#current` | Current architecture diagrams and narrative |
| `#architecture` | Architecture domain findings (Strengths, Concerns, Risks) |
| `#security` | Security domain findings |
| `#scalability` | Scalability domain findings |
| `#reliability` | Reliability domain findings |
| `#antipatterns` | Anti-patterns findings |
| `#testability` | Testability domain findings |
| `#evolvability` | Evolvability domain findings |
| `#recommended` | Recommended architecture diagrams and numbered migration steps |

## Side effects

The skill takes exactly these filesystem actions, in this order:

1. **Read-only:** Reads files within the codebase root (source files, manifests, architecture docs)
2. **Read-only:** Reads `../architect-shared/architecture-principles.md` and `../architect-shared/diagram-selection.md` and `../architect-shared/html-template.md`
3. **Write:** `mkdir -p docs/architecture/review` — creates the output directory if it does not exist
4. **Write:** Writes the HTML report to the output path (overwrites if a file at that path already exists)

**No source files are ever modified.** All reads are read-only. The only writes are the mkdir and the HTML file.

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `target-directory` | No | Current working directory | The codebase root to review |

## Known limitations

- No machine-parsable output format — output is HTML only
- Input size limit: for codebases >50k LOC, the skill uses summarization rather than full reads; the report will note this
- The `Agent` tool is used for sub-tasks; Agent scope is limited to read operations within the codebase root
