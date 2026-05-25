# Agent Path — AI Assessment System

## Overview

The AI Assessment is Agent Path's core product at the $999 tier. It's a structured discovery interview that produces a professional slide deck showing the client exactly where AI can save them time and money — with a built-in path to implementation upsells.

## Files

| File | Purpose |
|------|---------|
| `questionnaire.md` | The interview script — 3 sections, 50+ questions |
| `report-prompt.md` | Claude prompt that turns interview transcript into a report |
| `deck-template-spec.md` | Visual spec for the PowerPoint deliverable |
| `README.md` | This file |

## Workflow

```
1. BOOK    → Client schedules 30-min discovery call
2. ASK     → Run through questionnaire (live call or voice agent)
3. RECORD  → Transcribe the interview (Fathom.ai, Otter, or voice agent)
4. GENERATE → Feed transcript into Claude with report-prompt.md
5. BUILD   → Generate .pptx deck from Claude's output
6. QA      → Convert to images, visual inspection
7. DELIVER → Send PDF + .pptx to client within 48 hours
8. UPSELL  → Report naturally leads to implementation packages
```

## Questionnaire Structure

**Section 1: Core (25 questions)** — Ask every time. Business profile, tech stack, pain points, revenue, team operations.

**Section 2: Middle (10 questions per industry)** — Pick the block matching their vertical. Currently covers:
- Home Services (HVAC, Plumbing, Roofing, etc.)
- Healthcare & Wellness (Dental, Therapy, Med Spas, etc.)
- Professional Services (Law, Accounting, Consulting, etc.)
- Restaurants & Hospitality
- E-Commerce & Retail
- Real Estate & Property
- Construction & Contracting

**Section 3: Ending (13 questions)** — Ask every time. AI exposure, priorities, budget, next steps.

## Report Structure (12 slides)

1. Cover
2. Executive Summary
3. Business Snapshot
4. Quick Win #1
5. Quick Win #2
6. Quick Win #3
7. Strategic Opportunity #1
8. Strategic Opportunity #2
9. The Upsell Path / Timeline
10. Implementation Roadmap
11. Investment & Next Steps
12. Thank You / Contact

## Pricing Alignment

| Tier | Price | What's Included |
|------|-------|-----------------|
| AI Assessment | $999 | Discovery call + 12-slide report + 1 follow-up call |
| Implementation | $1,199+ | Quick wins installed + training |
| Chief of Staff | $1,699/mo | Ongoing optimization + new automations monthly |

## Next Steps

- [ ] Build the .pptx template using pptxgenjs
- [ ] Create a voice agent prompt for the questionnaire
- [ ] Test end-to-end with a mock interview
- [ ] Add more industry question blocks as needed
