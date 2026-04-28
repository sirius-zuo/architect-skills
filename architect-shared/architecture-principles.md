# Architecture Principles Reference

Use these as evaluation criteria. For each relevant principle, classify findings as:
- ✅ **Strength** — a well-made architectural decision
- ⚠️ **Concern** — a potential issue worth addressing
- ❌ **Risk** — a significant architectural problem

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

## Scalability Considerations

The architecture can grow — more users, more data, more features — without fundamental restructuring.

**Check for:**
- Stateless services (can be horizontally scaled)
- Clear data partitioning strategy
- Asynchronous processing for long-running tasks
- Caching strategy for hot paths

## Observability

The system can be understood in production: errors are logged, key events are traced, health can be measured.

**Check for:**
- Structured logging at key operations
- Error propagation and surfacing
- Health endpoints or readiness probes
- Metrics for critical operations

## C4 Model Vocabulary (for communication)

Use when describing architecture at different levels of abstraction:
- **Context** — the system and its relationships to users and other systems
- **Container** — deployable units (apps, services, databases)
- **Component** — major structural building blocks within a container
- **Code** — classes, functions (usually too detailed for architecture reviews)

## DDD Tactical Patterns (when domain is complex)

- **Aggregate** — cluster of objects treated as a unit with a single root
- **Entity** — object with identity that persists over time
- **Value Object** — immutable object defined by its attributes
- **Repository** — abstraction for data access
- **Domain Service** — stateless operation that doesn't belong on an entity

## Architectural Smells (codebase review)

- **Anemic domain model** — domain objects with no behavior, only data
- **Smart UI / dumb domain** — all logic in controllers or UI components
- **God service** — one service class or module handling everything
- **Leaky abstraction** — implementation details leaking through interfaces
- **Missing anti-corruption layer** — third-party models used directly in domain
