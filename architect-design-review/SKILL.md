---
name: architect-design-review
description: Use after superpowers:brainstorming approves a design spec and before writing-plans is invoked. Reviews the spec, generates architecture diagrams using Mermaid.js, evaluates against architecture principles, and produces an HTML report in docs/architecture/review/. Hands off to writing-plans when complete.
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Architect Design Review

Reviews an approved design spec, generates architecture diagrams, evaluates the design, produces an HTML report, then hands off to writing-plans.

## Step 1: Read the spec

Find the most recently modified file in `docs/superpowers/specs/`:

```bash
ls -lt docs/superpowers/specs/ | head -5
```

Read it fully. Read any documents it references.

## Step 2: Extract project context

From the spec, identify:
- Project type (web app, CLI, library, service, mobile, etc.)
- Tech stack and frameworks
- Major components and their relationships
- External dependencies (APIs, databases, third-party services)
- Data entities (if any)
- User types / actors

## Step 3: Load shared references

Read both files:
- `../architect-shared/architecture-principles.md`
- `../architect-shared/diagram-selection.md`

## Step 4: Generate core diagrams

Always generate both:

**System Context** — the system as a black box. Who uses it? What does it connect to?

Example Mermaid:
```
graph TB
  User([User]) --> Sys[Your System]
  Sys --> DB[(Database)]
  Sys --> ExtAPI[External API]
```

**Component diagram** — major internal components and how they relate. Use the actual component names from the spec.

Example Mermaid:
```
graph LR
  subgraph System
    API[API Layer] --> Service[Business Logic]
    Service --> Repo[Repository]
    Repo --> DB[(Database)]
  end
```

## Step 5: Propose additional diagrams

Apply the rules from `../architect-shared/diagram-selection.md`. Send ONE message listing warranted diagrams with one-line reasons. Wait for user confirmation before proceeding.

## Step 6: Generate all diagrams

Generate Mermaid.js code for core diagrams and each user-confirmed additional diagram. Use the syntax reference in `../architect-shared/html-template.md`.

## Step 7: Evaluate the design

Using `../architect-shared/architecture-principles.md`, evaluate each relevant principle against what's described in the spec. Produce a list of findings classified as Strength, Concern, or Risk.

## Step 8: Build the HTML report

Read `../architect-shared/html-template.md`. Fill in the design review template with:
- **Executive summary** — 2-3 sentences on what the system is and key architectural choices
- **Architecture diagrams** — each diagram in a `diagram-card` with title and one-line description
- **Evaluation** — all findings as `finding` blocks with correct badge class
- **Recommendations** — numbered actionable improvements

Use the nav links: `#summary`, `#diagrams`, `#evaluation`, `#recommendations`.

## Step 9: Save the report

```bash
mkdir -p docs/architecture/review
```

Derive `<project>` from:
1. `name` field in `package.json`, `go.mod`, or `Cargo.toml` if present
2. Otherwise, the root directory name

Save to: `docs/architecture/review/YYYY-MM-DD-<project>-design-architecture.html`

Confirm the saved path to the user.

## Step 10: Hand off

Invoke `writing-plans` to create the implementation plan from the approved spec.

---

After writing, verify:
```bash
ls -la architect-design-review/SKILL.md
head -5 architect-design-review/SKILL.md
```
Expected: first line is `---`

Then commit:
```bash
git add architect-design-review/SKILL.md
git commit -m "feat: add architect-design-review skill"
```
