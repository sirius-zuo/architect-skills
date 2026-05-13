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

Load `../architect-shared/architecture-principles.md`. Run four domain evaluations in order. Each produces a list of findings classified as Strength, Concern, or Risk.

### Step 8a: Architecture

Evaluate against: Separation of Concerns, Cohesion and Coupling, Layered Architecture, Hexagonal Architecture / Ports and Adapters. Also identify architectural smells:
- God modules (one file/package doing everything)
- Missing abstraction layers (UI talking directly to DB)
- Circular dependencies
- Tight coupling between business logic and infrastructure
- Missing error boundaries or observability hooks

### Step 8b: Security

Evaluate against the Security section of the principles:
- AuthN/AuthZ: Is authentication enforced at the right layer? Is authorization centralized or scattered?
- Secrets management: Are credentials/keys externalized? Is there a secrets store pattern?
- Network boundaries: Are internal services unnecessarily exposed? Is there an API gateway or DMZ?
- Data protection: Is encryption at rest and in transit accounted for? Are sensitive fields identified?
- OWASP Top 10 signals: injection risks, broken access control, security misconfiguration, insecure design, vulnerable components, sensitive data exposure.

### Step 8c: Scalability

Evaluate against the Scalability section of the principles:
- Stateless services: Can instances be added horizontally without shared mutable state? Where is session/state stored?
- Data partitioning: Is there a sharding or tenant-isolation strategy for high data volumes?
- Caching: Are hot read paths cached? Is cache invalidation addressed?
- Async processing: Are long-running tasks offloaded from the synchronous request path?
- Rate limiting and backpressure: Is the system protected from traffic spikes?
- Capacity headroom: Are there obvious bottlenecks (N+1 queries, unbounded queues, single-threaded workers)?

### Step 8d: Reliability

Evaluate against the Reliability section of the principles:
- Graceful degradation: Does the system define behavior when a dependency is unavailable?
- Circuit breakers and retries: Are patterns in place to prevent cascade failures?
- Redundancy: Are there single points of failure (single DB, single app instance, single region)?
- Failover: Is there an active/passive or active/active setup for critical components?
- Health checks: Are liveness and readiness probes defined for all services?

## Step 9: Generate recommended architecture diagrams

For each current-state diagram, produce a revised version showing the recommended improvements. Only produce a revised diagram if the current state has issues — if a diagram looks sound, skip it. Label what changed.

## Step 10: Build the HTML report

Read `../architect-shared/html-template.md`. Use the codebase review template with six sections:

- **Current Architecture** — all current-state diagrams in `diagram-card` blocks with narrative
- **Architecture** — findings from Step 8a as `finding` blocks
- **Security** — findings from Step 8b as `finding` blocks
- **Scalability** — findings from Step 8c as `finding` blocks
- **Reliability** — findings from Step 8d as `finding` blocks
- **Recommended Architecture** — revised diagrams, numbered actionable changes (synthesizing all domain findings), migration notes

Use nav links: `#current`, `#architecture`, `#security`, `#scalability`, `#reliability`, `#recommended`.

## Step 11: Save the report

```bash
mkdir -p docs/architecture/review
```

Derive `<project>` from:
1. `name` field in `package.json`, `go.mod`, or `Cargo.toml` if present
2. Otherwise, the root directory name

Save to: `docs/architecture/review/YYYY-MM-DD-<project>-codebase-architecture.html`

Confirm the saved path to the user.
