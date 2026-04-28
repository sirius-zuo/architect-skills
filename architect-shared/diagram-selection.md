# Diagram Selection Rules

## Core diagrams (always generated)

Both skills always generate these two diagrams regardless of project type:

- **System Context** — the system as a black box: who uses it, what it connects to
- **Component** — major internal components and their relationships

## Additional diagrams (propose when warranted)

After reading the design spec or codebase, identify which of these are warranted. Propose them in a single message with one-line reasons each. Wait for user confirmation before generating.

### Application diagram
**Propose when:** Multi-app architecture — client/server split, mobile + backend, micro-frontends, or a separate CLI + API.
**Skip when:** Single-application system with no distinct client layer.

### Data/information architecture
**Propose when:** Three or more distinct data entities exist, or data flows and transformations are central to the system.
**Skip when:** Trivial data model (1-2 entities), or data persistence is not a primary concern.

### Sequence diagram
**Propose when:** Async flows, event-driven patterns, multi-step authentication, or complex API interactions. Valuable when timing or order of operations matters.
**Skip when:** Only simple synchronous CRUD with no notable interaction sequences.

### Integration diagram
**Propose when:** The system integrates with one or more external APIs, third-party services, message queues, or webhooks.
**Skip when:** No external dependencies beyond a database.

### Deployment diagram
**Propose when:** Non-trivial deployment topology — cloud infrastructure, containers, multi-region, load balancing, or specific infrastructure requirements.
**Skip when:** Simple single-server or local-only deployment.

## How to propose

Send exactly one message listing warranted diagrams with one-line reasons:

> "Based on the [spec/codebase], I'd also generate:
> - **Sequence diagram** — authentication flow has 5 async steps
> - **Integration diagram** — Stripe, SendGrid, and S3 are referenced
>
> Confirm, skip any, or add others?"

Wait for the user's response before generating any diagrams.
