# HTML Report Template

Use this to produce the architecture review HTML output. Replace all `{PLACEHOLDER}` values with actual content.

## Section structure

**For `architect-design-review`:**
- Executive Summary
- Architecture Diagrams
- Evaluation
- Recommendations

**For `architect-codebase-review`:**
- Current Architecture (diagrams + narrative)
- Evaluation
- Recommended Architecture (revised diagrams + migration notes)

## Full HTML template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Architecture Review — {PROJECT_NAME}</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
  <script>mermaid.initialize({ startOnLoad: true, theme: 'default' });</script>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
      background: #f5f5f7;
      color: #1d1d1f;
      line-height: 1.6;
      display: flex;
      min-height: 100vh;
    }

    nav {
      width: 220px;
      min-width: 220px;
      background: #fff;
      border-right: 1px solid #e5e5ea;
      padding: 2rem 1.25rem;
      position: sticky;
      top: 0;
      height: 100vh;
      overflow-y: auto;
    }

    nav h2 {
      font-size: 0.7rem;
      font-weight: 600;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: #8e8e93;
      margin-bottom: 1rem;
    }

    nav a {
      display: block;
      padding: 0.4rem 0.75rem;
      border-radius: 6px;
      color: #3a3a3c;
      text-decoration: none;
      font-size: 0.875rem;
      margin-bottom: 0.25rem;
      transition: background 0.15s;
    }

    nav a:hover { background: #f2f2f7; }

    main {
      flex: 1;
      padding: 2.5rem 3rem;
      max-width: 960px;
    }

    header {
      margin-bottom: 2.5rem;
      padding-bottom: 1.5rem;
      border-bottom: 1px solid #e5e5ea;
    }

    header h1 { font-size: 1.75rem; font-weight: 700; }
    header p { margin-top: 0.5rem; color: #6e6e73; font-size: 0.95rem; }
    header .meta { margin-top: 0.75rem; font-size: 0.8rem; color: #8e8e93; }

    section { margin-bottom: 3rem; scroll-margin-top: 2rem; }

    section h2 {
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 1.25rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid #e5e5ea;
    }

    .card {
      background: #fff;
      border: 1px solid #e5e5ea;
      border-radius: 12px;
      padding: 1.5rem;
      margin-bottom: 1.25rem;
    }

    .card h3 { font-size: 1rem; font-weight: 600; margin-bottom: 0.75rem; }
    .card p { color: #3a3a3c; font-size: 0.9rem; }

    .diagram-card {
      background: #fff;
      border: 1px solid #e5e5ea;
      border-radius: 12px;
      padding: 1.5rem;
      margin-bottom: 1.25rem;
      overflow-x: auto;
    }

    .diagram-card h3 { font-size: 1rem; font-weight: 600; margin-bottom: 0.4rem; }
    .diagram-desc { color: #6e6e73; font-size: 0.85rem; margin-bottom: 1rem; }
    .mermaid { min-height: 80px; }

    .findings { display: flex; flex-direction: column; gap: 0.75rem; }

    .finding {
      display: flex;
      gap: 0.75rem;
      align-items: flex-start;
      padding: 0.875rem 1rem;
      border-radius: 8px;
      font-size: 0.9rem;
    }

    .finding.strength { background: #f0faf4; border-left: 3px solid #30d158; }
    .finding.concern  { background: #fffbf0; border-left: 3px solid #ff9f0a; }
    .finding.risk     { background: #fff5f5; border-left: 3px solid #ff3b30; }

    .badge {
      font-size: 0.75rem;
      font-weight: 600;
      padding: 0.2rem 0.6rem;
      border-radius: 4px;
      white-space: nowrap;
      flex-shrink: 0;
    }

    .badge-strength { background: #30d158; color: #fff; }
    .badge-concern  { background: #ff9f0a; color: #fff; }
    .badge-risk     { background: #ff3b30; color: #fff; }

    .finding-text strong { display: block; margin-bottom: 0.2rem; }
    .finding-text p { color: #3a3a3c; }

    .recommendations ol { padding-left: 1.5rem; }
    .recommendations li { margin-bottom: 0.75rem; color: #3a3a3c; font-size: 0.9rem; }
    .recommendations li strong { color: #1d1d1f; }
  </style>
</head>
<body>

  <nav>
    <h2>Architecture Review</h2>
    <!-- Design review nav: -->
    <a href="#summary">Executive Summary</a>
    <a href="#diagrams">Diagrams</a>
    <a href="#evaluation">Evaluation</a>
    <a href="#recommendations">Recommendations</a>

    <!-- Codebase review nav (replace above with this):
    <a href="#current">Current Architecture</a>
    <a href="#evaluation">Evaluation</a>
    <a href="#recommended">Recommended Architecture</a>
    -->
  </nav>

  <main>
    <header>
      <h1>{PROJECT_NAME} Architecture Review</h1>
      <p>{ONE_LINE_PROJECT_DESCRIPTION}</p>
      <p class="meta">Generated {YYYY-MM-DD} · {Design Review | Codebase Review}</p>
    </header>

    <!-- ============================================================
         DESIGN REVIEW SECTIONS
         ============================================================ -->

    <section id="summary">
      <h2>Executive Summary</h2>
      <div class="card">
        <p>{2-3 sentences: what the system is, key architectural decisions, overall assessment}</p>
      </div>
    </section>

    <section id="diagrams">
      <h2>Architecture Diagrams</h2>

      <div class="diagram-card">
        <h3>System Context</h3>
        <p class="diagram-desc">{One sentence: what this diagram shows}</p>
        <div class="mermaid">
graph TB
  User(["{Actor}"])  --> Sys["{System Name}"]
  Sys --> DB[("Database")]
  Sys --> Ext["{External Service}"]
        </div>
      </div>

      <div class="diagram-card">
        <h3>Component Diagram</h3>
        <p class="diagram-desc">{One sentence: what this diagram shows}</p>
        <div class="mermaid">
graph LR
  subgraph "{System Name}"
    A["{Component A}"] --> B["{Component B}"]
    B --> C["{Component C}"]
  end
        </div>
      </div>

      <!-- Add additional diagram-card blocks for confirmed extras -->

    </section>

    <section id="evaluation">
      <h2>Evaluation</h2>
      <div class="findings">

        <div class="finding strength">
          <span class="badge badge-strength">Strength</span>
          <div class="finding-text">
            <strong>{Principle or area}</strong>
            <p>{Why this is a strength}</p>
          </div>
        </div>

        <div class="finding concern">
          <span class="badge badge-concern">Concern</span>
          <div class="finding-text">
            <strong>{Principle or area}</strong>
            <p>{What the concern is}</p>
          </div>
        </div>

        <div class="finding risk">
          <span class="badge badge-risk">Risk</span>
          <div class="finding-text">
            <strong>{Principle or area}</strong>
            <p>{What the risk is and why it matters}</p>
          </div>
        </div>

      </div>
    </section>

    <section id="recommendations" class="recommendations">
      <h2>Recommendations</h2>
      <div class="card">
        <ol>
          <li><strong>{Recommendation title}</strong> — {Actionable explanation}</li>
        </ol>
      </div>
    </section>

    <!-- ============================================================
         CODEBASE REVIEW SECTIONS (replace design review sections)
         ============================================================

    <section id="current">
      <h2>Current Architecture</h2>
      [diagram-card blocks for current-state diagrams]
      <div class="card">
        <p>{Narrative describing the current architecture}</p>
      </div>
    </section>

    <section id="evaluation">
      <h2>Evaluation</h2>
      <div class="findings">
        [finding blocks]
      </div>
    </section>

    <section id="recommended">
      <h2>Recommended Architecture</h2>
      [diagram-card blocks for revised diagrams]
      <div class="card recommendations">
        <ol>
          <li><strong>{Change}</strong> — {Why and how}</li>
        </ol>
      </div>
      <div class="card">
        <h3>Migration Notes</h3>
        <p>{How to get from current to recommended, what to do first}</p>
      </div>
    </section>

    -->

  </main>
</body>
</html>
```

## Mermaid diagram syntax reference

All diagrams use `<div class="mermaid">` blocks. Common types:

**Flowchart** (system context, application, integration):
```
graph TB
  Actor([Actor]) --> System[System]
  System --> DB[(Database)]
  System --> Ext[External API]
```

**Component** (internal structure):
```
graph LR
  subgraph System
    A[Module A] --> B[Module B]
  end
```

**Sequence**:
```
sequenceDiagram
  actor User
  User->>API: POST /login
  API->>Auth: validate(credentials)
  Auth-->>API: token
  API-->>User: 200 {token}
```

**ER diagram** (data architecture):
```
erDiagram
  USER ||--o{ ORDER : places
  ORDER ||--|{ ITEM : contains
```

**Deployment**:
```
graph TB
  subgraph Cloud
    LB[Load Balancer] --> App1[App Instance]
    LB --> App2[App Instance]
    App1 & App2 --> DB[(RDS)]
  end
```
