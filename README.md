# Architect Skills

A portable skill set for architecture review at two stages of development:

- **`architect-design-review`** — reviews an approved design spec and generates an architecture report before implementation begins
- **`architect-codebase-review`** — analyzes an existing codebase and generates a current + recommended architecture report

Both skills produce a Mermaid.js HTML report saved to `docs/architecture/review/`.

## Installation

### Claude Code

```bash
./install.sh claude
```

Then add one line to `~/.claude/CLAUDE.md`:

```
After superpowers:brainstorming writes and the user approves the spec,
always invoke architect-design-review before invoking writing-plans.
```

### Codex

```bash
./install.sh codex
```

Add the equivalent workflow hook to your Codex agent configuration.

### Other agents / custom path

```bash
./install.sh ~/.my-agent/skills
```

The three directories (`architect-design-review/`, `architect-codebase-review/`, `architect-shared/`) must be installed as siblings — the skills reference shared files at `../architect-shared/`.

## Usage

### Design review (automatic after brainstorming)

With the CLAUDE.md hook in place, `architect-design-review` runs automatically after brainstorming approves a spec and before `writing-plans` is invoked. No manual invocation needed.

To run manually: invoke `/architect-design-review` in Claude Code.

### Codebase review (manual)

Invoke `/architect-codebase-review` in any project directory.

## Diagram types

Both skills always generate:
- System Context diagram
- Component diagram

Additional diagrams proposed based on the project (user confirms before generating):
- Application diagram
- Data/information architecture
- Sequence diagram
- Integration diagram
- Deployment diagram

## Requirements

- Internet connection required to render diagrams (Mermaid.js loaded via CDN)
- No other dependencies
