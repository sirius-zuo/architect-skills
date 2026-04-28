---
name: architect-codebase-review
description: Use when an existing codebase needs an architecture review. Explores the codebase, generates current-state architecture diagrams using Mermaid.js, evaluates against architecture principles, proposes recommended improvements with revised diagrams, and saves an HTML report to docs/architecture/review/.
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
---

# Architect Codebase Review

Analyzes an existing codebase, produces current-state architecture diagrams, evaluates the architecture, generates recommended improvements, and saves an HTML report.

## Step 1: Explore codebase structure

```bash
# Detect tech stack
ls -la
find . -maxdepth 2 \( -name "go.mod" -o -name "package.json" -o -name "Cargo.toml" -o -name "pom.xml" -o -name "build.gradle" -o -name "pyproject.toml" -o -name "requirements.txt" \) 2>/dev/null | grep -v node_modules | head -10

# Key directories
ls src/ lib/ app/ cmd/ internal/ 2>/dev/null | head -30

# File distribution (signals module size and organization)
find . -not -path '*/\.*' -not -path '*/node_modules/*' \( -name '*.go' -o -name '*.ts' -o -name '*.py' -o -name '*.java' -o -name '*.rs' \) 2>/dev/null | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn | head -20
```

Read the top-level README.md if it exists.

## Step 2: Read existing architecture documents

```bash
find . -not -path '*/node_modules/*' \( -name "ARCHITECTURE.md" -o -name "DESIGN.md" -o -name "architecture.md" \) 2>/dev/null
find . -path "*/docs/*.md" -not -path '*/node_modules/*' 2>/dev/null | head -15
```

Read any found documents.

## Step 3: Load shared references

Read both files:
- `../architect-shared/architecture-principles.md`
- `../architect-shared/diagram-selection.md`

## Step 4: Map current architecture

From what you observed, identify:
- System boundary and external actors
- Major modules/packages/services
- Data stores and external dependencies
- Communication patterns (sync HTTP, async events, queues)
- Data entities (from model/schema files)
- Deployment configuration (Dockerfile, k8s YAML, cloud configs)

## Step 5: Generate core current-state diagrams

Always generate both, reflecting the actual code — not an idealized version:

**System Context** — current boundary, actual users, actual external dependencies.

**Component diagram** — actual modules/packages as they exist, with their real relationships including any problematic ones (god modules, circular deps).

## Step 6: Propose additional current-state diagrams

Apply rules from `../architect-shared/diagram-selection.md`. Send ONE message with the proposed list and one-line reasons. Wait for user confirmation.

## Step 7: Generate confirmed current-state diagrams

Generate Mermaid.js for core diagrams plus each confirmed additional diagram. Use syntax reference in `../architect-shared/html-template.md`.

## Step 8: Evaluate current architecture

Using `../architect-shared/architecture-principles.md`, classify findings as Strength, Concern, or Risk.

Also identify architectural smells:
- God modules (one file/package doing everything)
- Missing abstraction layers (UI talking directly to DB)
- Circular dependencies
- Tight coupling between business logic and infrastructure
- Missing error boundaries or observability hooks

## Step 9: Generate recommended architecture diagrams

For each current-state diagram, produce a revised version showing the recommended improvements. Only produce a revised diagram if the current state has issues — if a diagram looks sound, skip it. Label what changed.

## Step 10: Build the HTML report

Read `../architect-shared/html-template.md`. Use the codebase review template (three sections: Current Architecture, Evaluation, Recommended Architecture):

- **Current Architecture** — all current-state diagrams in `diagram-card` blocks with narrative
- **Evaluation** — all findings as `finding` blocks (Strength/Concern/Risk)
- **Recommended Architecture** — revised diagrams, numbered actionable changes, migration notes

Use nav links: `#current`, `#evaluation`, `#recommended`.

## Step 11: Save the report

```bash
mkdir -p docs/architecture/review
```

Derive `<project>` from:
1. `name` field in `package.json`, `go.mod`, or `Cargo.toml` if present
2. Otherwise, the root directory name

Save to: `docs/architecture/review/YYYY-MM-DD-<project>-codebase-architecture.html`

Confirm the saved path to the user.

---

After writing, verify and commit:
```bash
ls -la architect-codebase-review/SKILL.md
head -5 architect-codebase-review/SKILL.md
git add architect-codebase-review/SKILL.md
git commit -m "feat: add architect-codebase-review skill"
```
