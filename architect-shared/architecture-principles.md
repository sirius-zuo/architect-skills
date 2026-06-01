# Architecture Principles Reference

Use these as evaluation criteria. For each relevant principle, classify findings as:
- ✅ **Strength** — a well-made architectural decision
- ⚠️ **Concern** — a potential issue worth addressing
- ❌ **Risk** — a significant architectural problem

## Review Section Conventions

**Review role:** Reference only

This section explains how review criteria are interpreted by the architect review skills. It is guidance for the skills, not an evaluation domain.

Each `##` heading is a candidate review section unless it is marked otherwise.

**Review role** controls whether a section is evaluated:
- `Evaluation` — evaluate this section and include it in reports
- `Reference only` — use this section as supporting vocabulary or guidance, but do not create a report section for it

**Applies to** controls review type:
- `design` — evaluate only during `architect-design-review`
- `codebase` — evaluate only during `architect-codebase-review`
- `design, codebase` — evaluate during both review types

If `Review role` is omitted, treat the section as `Evaluation`.
If `Applies to` is omitted, treat the section as applying to both `design` and `codebase`.
All content under a reviewable `##` heading belongs to that section until the next `##` heading.

## Separation of Concerns

Each component has one clear responsibility. Business logic is separate from persistence, presentation, and infrastructure.

**Signals of violation:**
- Business rules embedded in request handlers or UI components
- Database queries scattered across layers
- Presentation logic in domain models

## Cohesion and Coupling

Related things are grouped together (high cohesion). Unrelated things have minimal dependencies (low coupling).

**Signals of violation:**
- God classes or modules that do many unrelated things
- Modules that change together but live far apart
- Circular dependencies between packages

## Layered Architecture

Clear layers with a consistent dependency direction: outer layers depend on inner layers, never the reverse.

Common models:
- Presentation → Application → Domain → Infrastructure (Clean Architecture)
- Controller → Service → Repository → Database

**Signals of violation:**
- Domain logic importing from infrastructure packages
- Business layer depending on HTTP request/response types
- Database models used directly in API responses

## Hexagonal Architecture / Ports and Adapters

Core business logic has no dependency on external systems. External systems connect via interfaces (ports) with swappable implementations (adapters).

**When relevant:** Systems with multiple external integrations, or where external systems are likely to change.

## Scalability

The architecture can grow — more users, more data, more features — without fundamental restructuring.

**Check for:**
- **Stateless services** — Can instances be added horizontally without shared mutable state? Where is session/state stored?
- **Data partitioning** — Is there a sharding or tenant-isolation strategy for high data volumes?
- **Caching** — Are hot read paths cached? Is cache invalidation addressed?
- **Async processing** — Are long-running tasks offloaded from the synchronous request path (queues, workers)?
- **Rate limiting and backpressure** — Is the system protected from traffic spikes at the entry point?
- **Capacity headroom** — Are there obvious bottlenecks (single-threaded workers, unbounded queues, N+1 queries)?

## Observability

The system can be understood in production: errors are logged, key events are traced, health can be measured.

**Check for:**
- Structured logging at key operations
- Error propagation and surfacing
- Health endpoints or readiness probes
- Metrics for critical operations

## Security

OWASP-aware, architecture-level review.

**Check for:**
- **AuthN/AuthZ** — Is authentication enforced at the right layer? Is authorization centralized or scattered across handlers?
- **Secrets management** — Are credentials/API keys hardcoded or externalized? Is there a secrets store pattern (env vars, vault, cloud secrets manager)?
- **Network boundaries** — Are internal services exposed unnecessarily? Is there an API gateway or DMZ pattern isolating the public surface?
- **Data protection** — Is encryption at rest and in transit accounted for in the design? Are sensitive fields identified?
- **OWASP Top 10 signals:**
  - Injection risks (parameterized queries, ORM usage, input sanitization)
  - Broken access control (object-level auth, missing ownership checks)
  - Security misconfiguration (default credentials, verbose error responses, open CORS)
  - Insecure design (missing rate limiting, no account lockout, predictable IDs)
  - Use of components with known vulnerabilities (outdated dependencies)
  - Sensitive data exposure (logging PII, unencrypted storage of secrets)

## Reliability

High-availability focused.

**Check for:**
- **Graceful degradation** — Does the system define behavior when a dependency is unavailable? Are fallbacks or defaults in place?
- **Circuit breakers and retries** — Are patterns in place to prevent cascade failures across service boundaries?
- **Redundancy** — Are there single points of failure (single DB instance, single app server, single region)?
- **Failover** — Is there an active/passive or active/active setup for critical components?
- **Health checks** — Are liveness and readiness probes defined for all services? Does the load balancer use them?

## Resilience

Reliability focuses on availability. Resilience focuses on surviving unexpected conditions, recovering from failure, and limiting blast radius.

**Check for:**
- Chaos testing strategy
- Dependency isolation
- Bulkhead patterns
- Load shedding
- Brownout modes
- Recovery Time Objective (RTO)
- Recovery Point Objective (RPO)
- Disaster recovery exercises

**Signals of concern:**
- Nobody knows what happens when a critical dependency dies
- Region failover has never been tested
- Backups exist but restores are untested
- Retry behavior can amplify an outage

## Data Architecture

Data has clear ownership, lineage, retention, and consistency rules.

**Check for:**
- Ownership of data domains
- Canonical data models
- Data lineage
- Data retention policies
- Data archival strategy
- Data consistency model (strong, eventual, causal, or explicitly mixed)
- Data governance

**Signals of concern:**
- Multiple systems claim ownership of the same data
- No source of truth exists for critical business entities
- Reporting databases are built from undocumented ETL pipelines
- Retention and deletion requirements are not represented in the architecture

## Cost Efficiency (FinOps)

The architecture uses resources intentionally and exposes cost drivers early enough to manage them.

**Check for:**
- Autoscaling effectiveness
- Resource utilization
- Storage growth projections
- Cost observability
- Cost allocation by tenant, team, or product
- Expensive synchronous dependencies
- Token and inference cost controls for AI-heavy systems

**Signals of concern:**
- Architecture only works by overprovisioning
- Unlimited log, trace, or artifact retention
- Excessive cross-region traffic
- LLM calls on every request without caching, routing, or budget controls

## Operability

The system can be safely run, maintained, diagnosed, and repaired by people who did not originally build it.

**Check for:**
- Runbooks
- Alerting strategy
- Deployment rollback procedures
- Incident response ownership
- Operational dashboards
- On-call readiness
- Maintenance procedures

**Signals of concern:**
- Only original developers know how the system works
- Deployments require manual tribal knowledge
- Alerts identify symptoms but not owners or likely causes
- Routine maintenance requires direct production access

## Deployment Architecture

Deployment topology, release strategy, and infrastructure management are explicit parts of the architecture.

**Check for:**
- CI/CD maturity
- Deployment topology
- Blue-green deployments
- Canary releases
- Progressive delivery
- Infrastructure as Code
- Immutable infrastructure
- Environment promotion strategy

**Signals of concern:**
- Production changes are made manually
- Snowflake servers or hand-configured environments exist
- Each service has a different deployment process
- Rollback depends on manual reconstruction of prior state

## Event Architecture

Event-driven systems have explicit ownership, contracts, evolution rules, and failure handling.

**Check for:**
- Event ownership
- Event versioning
- Schema evolution
- Idempotency
- Replayability
- Ordering guarantees
- Dead-letter handling
- Exactly-once assumptions

**Signals of concern:**
- Consumers depend on global event ordering
- No schema registry or contract governance exists
- Event payloads are used as database replacements
- Replay behavior is undocumented or unsafe

## AI Architecture

AI-enabled systems make model, prompt, context, evaluation, safety, and cost decisions explicit.

**Check for:**
- Model ownership
- Model routing strategy
- Prompt versioning
- Context management
- Evaluation pipelines
- Hallucination mitigation
- Human review workflows
- Model fallback strategy
- Token cost controls
- AI-specific observability

**Signals of concern:**
- Prompts are hardcoded throughout the codebase
- No evaluation framework exists
- Model outputs are not observable or traceable
- Critical decisions depend on unreviewed model responses

## Multi-Tenancy

Tenant isolation, fairness, observability, and authorization are designed intentionally.

**Check for:**
- Tenant isolation
- Data segregation
- Tenant-aware authorization
- Noisy-neighbor protection
- Per-tenant quotas
- Per-tenant observability

**Signals of concern:**
- Tenant ID is passed manually through unrelated code paths
- Shared caches do not isolate tenant data
- Authorization rules are not tenant-aware
- One tenant can consume shared capacity without limits

## Architecture Governance

Important architectural decisions are explicit, owned, reviewed, and revisited.

**Check for:**
- Architecture Decision Records (ADRs)
- Decision rationale
- Explicit trade-offs
- Ownership of architecture decisions
- Review cadence

**Signals of concern:**
- Nobody knows why a major technology was chosen
- Architectural decisions exist only in chat logs
- Major trade-offs are undocumented
- No one owns architecture drift after implementation

## Domain Architecture

Business capabilities, bounded contexts, and team ownership are reflected in architecture boundaries.

**Check for:**
- Bounded contexts
- Context maps
- Upstream/downstream relationships
- Shared Kernel usage
- Customer/supplier relationships
- Team ownership alignment

**Signals of concern:**
- Services are split by technical layers instead of business capabilities
- Multiple teams modify the same business concepts without clear ownership
- Shared domain language means different things in different modules
- Cross-context dependencies bypass defined contracts

## API Architecture

APIs have clear contracts, compatibility guarantees, versioning, and error models.

**Check for:**
- Contract-first design
- Backward compatibility
- API versioning
- Consumer-driven contract testing
- Pagination strategy
- Consistent error models

**Signals of concern:**
- Breaking API changes are shipped without migration paths
- Error formats differ by endpoint or service
- Public APIs are unversioned
- Pagination, filtering, and idempotency are inconsistent

## Architecture Fitness Metrics

Architectural quality is checked continuously rather than only during manual review.

**Check for:**
- Dependency rules enforced automatically
- Architectural conformance tests
- Coupling metrics
- Complexity metrics
- Service dependency maps
- Architectural drift detection

**Signals of concern:**
- Review findings cannot be converted into automated checks
- Dependency direction is documented but unenforced
- Coupling and complexity only become visible after failures
- Service maps are manually maintained and quickly go stale

## Common Anti-Patterns

These are recurring design decisions that look reasonable locally but cause systemic problems. Evaluate against these in both design and codebase reviews.

### Shared Database as Integration Hub
Two or more services write to the same database tables or schemas, using the database as a message bus instead of proper APIs or events.
**Signals:** Multiple services importing the same ORM model; cross-service SQL joins; shared schema migrations.
**Impact:** Hidden coupling spreads failures across unrelated services. No team owns the boundary.

### Distributed Monolith
Microservices that still share state, call each other in lockstep (synchronous chains), or are deployed as a single unit. The operational complexity of microservices without the benefits.
**Signals:** Service A calls Service B calls Service C in a single request; services deployed together; no independent deployability.
**Impact:** You pay microservices costs (network, latency, operational overhead) but can't get microservices benefits (independent scaling, team autonomy).

### Point-to-Point Coupling (Spaghetti Architecture)
Every service connects directly to every other service it needs, creating an N² dependency graph. No API gateway, no event bus, no centralized integration layer.
**Signals:** Service A has direct HTTP connections to 15+ other services; changing one service requires changes in half the codebase.
**Impact:** Impossible to understand impact of changes. Adding a new service requires updating every existing service that might need it.

### Leaky Abstraction
Implementation details of one layer (database schema, third-party API response shapes, infrastructure constraints) are exposed through the boundaries of other layers.
**Signals:** API responses that mirror database column names; domain models that include infrastructure-specific fields; error messages exposing internal paths.
**Impact:** Can't swap implementations without breaking consumers. Vendor lock-in.

### Point-to-Point Async
Every consumer maintains its own direct connection to every producer it needs data from. No central event bus. No canonical event definitions.
**Signals:** Service A connects directly to Kafka topics from 5 different producers; adding a new event requires changes in every consumer.
**Impact:** Event storms — adding one new event type requires modifying every service that might care about it. Missed messages when consumers go offline.

### Missing Anti-Corruption Layer
Third-party models, legacy data formats, or external service response shapes are used directly inside the domain layer.
**Signals:** Domain entities with fields named after external API parameters; domain logic that transforms third-party date formats.
**Impact:** Vendor lock-in. If the external service changes its contract, your domain breaks.

### Big Ball of Mud
No identifiable boundaries. Everything calls everything. The system has grown organically without any architectural discipline.
**Signals:** One file is 5000+ lines; every function imports from every other module; no package/module structure.
**Impact:** No developer can understand more than a small piece. Every change risks regressions.

### Tight Coupling Through Shared Libraries
Two or more independent services depend on a shared library that is developed and released without versioning or backward-compatibility guarantees.
**Signals:** Services import a monorepo package; a breaking release of the shared library requires coordinated changes across services.
**Impact:** Teams coordinate releases unnecessarily. One team's bug forces a rollback on all dependents.

## Testability

The architecture should enable fast, reliable, and isolated testing. If a design makes testing harder, the boundaries are wrong.

**Check for:**
- **Injectable dependencies** — Can every component be tested with mock or stub dependencies via constructor injection (not global state or service locators)?
- **Domain-infra test boundary** — Is there a clear separation where domain logic can be tested with simple unit tests while infrastructure is tested separately with integration tests?
- **Testable integration points** — Are all external interactions (APIs, databases, message queues) mockable or stubbable at the boundary?
- **Independent test execution** — Can tests run in parallel without shared mutable state or database contention?
- **Staging-to-production fidelity** — Can the system be deployed in a staging environment that accurately mirrors production configuration (network, dependencies, feature flags)?
- **Fitness functions** — Are there automated checks that enforce architectural quality (e.g., dependency direction rules, coupling limits, test coverage thresholds)?
- **Deterministic behavior** — Are timing-dependent paths (retries, timeouts, race conditions) testable with controllable clock or mock time?
- **Feature flags for risky changes** — Can risky features be deployed and controlled without code changes, allowing gradual rollout and quick rollback?

## Evolvability

The architecture should allow changes to requirements and capabilities without rewriting existing code. A system can be scalable but completely unmaintainable when requirements shift.

**Check for:**
- **Stable boundaries with mutable internals** — Do module/service boundaries allow internal implementation changes without breaking consumers? (Open/Closed Principle)
- **Configuration-driven behavior** — Is behavior driven by configuration (feature flags, routing tables, strategy selection) rather than code changes?
- **Identified extension points** — Are places where new capabilities will be added explicitly designed (plug-in patterns, strategy interfaces, event hooks)?
- **Versioning strategy** — Is there a strategy for versioning APIs and data schemas that supports backward-compatible evolution and defined deprecation windows?
- **Independent module releases** — Can new capabilities be added to one module without requiring coordinated releases across other modules?
- **Behavior over structure** — Is the system structured around *what it does* (capabilities, workflows) rather than *what it is* (data entities, technical layers)?

## C4 Model Vocabulary (for communication)

**Review role:** Reference only

Use when describing architecture at different levels of abstraction:
- **Context** — the system and its relationships to users and other systems
- **Container** — deployable units (apps, services, databases)
- **Component** — major structural building blocks within a container
- **Code** — classes, functions (usually too detailed for architecture reviews)

## DDD Tactical Patterns (when domain is complex)

**Review role:** Reference only

- **Aggregate** — cluster of objects treated as a unit with a single root
- **Entity** — object with identity that persists over time
- **Value Object** — immutable object defined by its attributes
- **Repository** — abstraction for data access
- **Domain Service** — stateless operation that doesn't belong on an entity

## Architectural Smells (codebase review only — not applicable in design review)

**Applies to:** codebase

- **Anemic domain model** — domain objects with no behavior, only data
- **Smart UI / dumb domain** — all logic in controllers or UI components
- **God service** — one service class or module handling everything
- **Leaky abstraction** — implementation details leaking through interfaces
- **Missing anti-corruption layer** — third-party models used directly in domain

## When to Look Deeper

**Review role:** Reference only

These principles cover structural quality attributes that apply to any system. For specialized domains, findings from these sections may reveal gaps that need deeper review:

- **AI/LLM systems** — Review for model strategy decisions (API vs self-hosted), context management (short-term vs long-term memory, vector databases), prompt pipeline design, and AI-specific observability (data drift, concept drift, model SLOs, hallucination detection)
- **Event-driven systems** — Review event versioning, schema registries (Avro/Protobuf), dead-letter queues, and consumer lag monitoring — beyond the point-to-point async check in Anti-Patterns
- **High-scale read/write divergence** — Review CQRS suitability, event sourcing, and separate read/write model optimization
- **Multi-agent systems** — Review agent coordination patterns (centralized vs decentralized orchestration), stochastic-boundary composition, and agent-specific reliability patterns
- **Serverless-first deployments** — Review cold-start impact on latency-sensitive paths, vendor lock-in risk, platform-specific service dependencies, and debugging async event chains

For these domains, the structural principles above still apply — but they are a starting point, not the full review.
