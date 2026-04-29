# Architect Skills

A portable skill set for architecture review at two stages of development:

- **`architect-design-review`** — reviews an approved design spec and generates an architecture report before implementation begins
- **`architect-codebase-review`** — analyzes an existing codebase and generates a current + recommended architecture report

Both skills produce a Mermaid.js HTML report saved to `docs/architecture/review/`.

## Installation

### Claude Code (recommended — full skill invocation support)

**Global install** (skills available in every project):

```bash
git clone https://github.com/sirius-zuo/architect-skills.git
cd architect-skills
./install.sh claude
```

Then add one line to `~/.claude/CLAUDE.md`:

```
After superpowers:brainstorming writes and the user approves the spec,
always invoke architect-design-review before invoking writing-plans.
```

**Project-local install** (skills available only in current project):

```bash
./install.sh .claude/skills
```

**Verify:**
```bash
# In Claude Code, type:
/architect-design-review
```

### Cursor

Cursor does not have named slash-command skills. To use these instructions in Cursor:

1. Copy the skill content you want into `.cursor/rules/architect.mdc` in your project:

```bash
cat architect-design-review/SKILL.md architect-codebase-review/SKILL.md \
    architect-shared/architecture-principles.md \
    architect-shared/diagram-selection.md \
    architect-shared/html-template.md \
    > .cursor/rules/architect.mdc
```

2. In Cursor Agent mode, prompt: *"Follow the architect skill instructions to review the architecture of this project."*

### Windsurf

Similar to Cursor. Add the skill content as a Windsurf rule:

```bash
mkdir -p .windsurf/rules
cat architect-design-review/SKILL.md architect-codebase-review/SKILL.md \
    architect-shared/architecture-principles.md \
    architect-shared/diagram-selection.md \
    architect-shared/html-template.md \
    > .windsurf/rules/architect.md
```

Then prompt Cascade: *"Follow the architect workflow instructions in the rules to review the architecture of this project."*

### GitHub Copilot

Add to `.github/copilot-instructions.md` in your project:

```bash
cat architect-design-review/SKILL.md architect-codebase-review/SKILL.md \
    architect-shared/architecture-principles.md \
    architect-shared/diagram-selection.md \
    architect-shared/html-template.md \
    >> .github/copilot-instructions.md
```

Then in Copilot Chat: *"Review the architecture of this project following the instructions."*

### OpenAI Codex CLI

Add to `AGENTS.md` in your project root, or to `~/.codex/instructions.md` for global use:

```bash
cat architect-design-review/SKILL.md architect-codebase-review/SKILL.md \
    architect-shared/architecture-principles.md \
    architect-shared/diagram-selection.md \
    architect-shared/html-template.md \
    >> AGENTS.md
```

### Gemini CLI

Add to `GEMINI.md` in your project root:

```bash
cat architect-design-review/SKILL.md architect-codebase-review/SKILL.md \
    architect-shared/architecture-principles.md \
    architect-shared/diagram-selection.md \
    architect-shared/html-template.md \
    >> GEMINI.md
```

---

> **Note:** The three directories (`architect-design-review/`, `architect-codebase-review/`, `architect-shared/`) must be installed as siblings — the skills reference shared files at `../architect-shared/`.

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
