# Dynamic Review Framework

Use this framework after loading `architecture-principles.md`. The principles document is the source of truth for evaluation criteria.

## Inputs

- Review type: `design` or `codebase`
- Structured evidence summary produced by the public skill workflow
- Full text of `architecture-principles.md`

## Derive Review Sections

1. Treat each `##` heading in `architecture-principles.md` as a candidate section.
2. A candidate section includes all content from that `##` heading until the next `##` heading.
3. If the section contains `**Review role:** Reference only`, do not evaluate it and do not create a report section for it.
4. If the section contains `**Review role:** Evaluation`, evaluate it.
5. If `Review role` is missing, evaluate it.
6. If the section contains `**Applies to:** design`, evaluate it only for design reviews.
7. If the section contains `**Applies to:** codebase`, evaluate it only for codebase reviews.
8. If the section contains `**Applies to:** design, codebase`, evaluate it for both.
9. If `Applies to` is missing, evaluate it for both.
10. If `Applies to` contains an unrecognized value, evaluate it for both and include a warning in the report generation notes.

If no reviewable sections remain after filtering, halt with:

`ERROR: No reviewable sections found in architecture-principles.md. Check Review role and Applies to markers. Stopping.`

## Evaluate Sections

Evaluate each applicable section in the order it appears in `architecture-principles.md`.

For each section:

1. Use the section heading as the report section title.
2. Use the section content as criteria. Treat bullets under `Check for`, `Signals of violation`, `Signals of concern`, `Impact`, examples, and explanatory paragraphs as evaluation guidance.
3. Compare criteria against the structured evidence summary.
4. Produce findings classified as:
   - `Strength` — a well-made architectural decision
   - `Concern` — a potential issue worth addressing
   - `Risk` — a significant architectural problem
5. Prefer specific evidence from the reviewed spec or codebase over generic best-practice statements.
6. Do not invent findings when there is no evidence. If the section applies but there are no material findings, emit one neutral finding:

```html
<div class="finding strength">
  <span class="badge badge-strength">No material findings</span>
  <div class="finding-text">
    <strong>No material findings</strong>
    <p>The available evidence did not reveal notable strengths, concerns, or risks for this area.</p>
  </div>
</div>
```

Use this neutral block only when a section applies and the review has enough evidence to say there were no material findings. If the input lacks enough evidence for an important section, use a Concern describing the missing evidence instead.

## Generate Anchors

Create section IDs from headings:

1. Lowercase the heading.
2. Replace any sequence of non-alphanumeric characters with a single hyphen.
3. Trim leading and trailing hyphens.
4. If the resulting ID is empty, use `section`.
5. If an ID duplicates an earlier ID, append `-2`, `-3`, and so on.

Examples:

| Heading | Anchor |
|---|---|
| Security | `security` |
| Cost Efficiency (FinOps) | `cost-efficiency-finops` |
| API Architecture | `api-architecture` |
| Architecture Fitness Metrics | `architecture-fitness-metrics` |

## Generate Report Sections

For every evaluated section, create:

```html
<section id="{generated-anchor}">
  <h2>{Section heading}</h2>
  <div class="findings">
    {finding blocks}
  </div>
</section>
```

Each finding block must use the structure defined in `html-template.md`.

## Generate Navigation

Add one nav link for each evaluated section:

```html
<a href="#{generated-anchor}">{Section heading}</a>
```

Design review navigation order:

1. `#summary`
2. `#diagrams`
3. dynamic criteria sections in principles order
4. `#recommendations`

Codebase review navigation order:

1. `#current`
2. dynamic criteria sections in principles order
3. `#recommended`

## Synthesize Recommendations

Recommendations must synthesize across all evaluated criteria sections, not only the original Architecture/Security/Scalability/Reliability domains.

Prioritize:

1. Risks that threaten correctness, security, operability, or delivery.
2. Concerns that unlock multiple quality attributes.
3. Missing decisions that block implementation or safe operation.
4. Strengths that should be preserved during refactoring or implementation.

Keep recommendations actionable and tied to specific findings.

## Context Release

After evaluation, discard the full text of `architecture-principles.md` and `dynamic-review-framework.md` from active context. Carry forward only:

- evaluated section headings
- generated anchors
- warnings
- classified findings per section
- synthesized recommendation inputs
