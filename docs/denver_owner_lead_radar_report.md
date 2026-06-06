# Denver Owner Lead Radar — Viability Report

Generated from live Denver parcel/middle-housing data and Agent Path CRM assets.

## Verdict

**PASS — Denver has enough owner/rental signal to test the $799/month Owner Lead Radar.**

Recommended starting MRR target: **$1,598 MRR** from 2 protected Denver territories.

Do not sell 3+ Denver accounts yet. First prove weekly lead freshness and outreach usefulness with 1–2 clients.

## Data Source

- Denver Middle Housing Stock ArcGIS FeatureServer, retrieved live.
- Agent Path CRM prospect list for Denver property managers.
- Output sample: `data/property-radar/denver_owner_lead_sample.csv`.

## Signal Counts

- Core residential/middle-housing records: **35,839**
- Non-owner occupied / mailing differs from property: **22,473**
- Out-of-state owners: **1,574**
- Corporate/trust/entity owners: **6,854**
- Small multifamily properties: **4,427**
- Small multifamily + non-owner occupied: **3,991**
- Sold 2024+: **3,246**
- Sold 2023+: **6,151**
- Non-owner + out-of-state: **1,573**
- Non-owner + corporate/trust: **5,992**

## Top ZIP5 Concentrations

- 80211: 2,899 non-owner signals
- 80204: 2,691 non-owner signals
- 80206: 1,847 non-owner signals
- 80238: 1,713 non-owner signals
- 80212: 1,353 non-owner signals
- 80205: 1,231 non-owner signals
- 80220: 1,220 non-owner signals
- 80219: 810 non-owner signals
- 80207: 726 non-owner signals
- 80231: 648 non-owner signals

## Sample Batch

Created **25 scored sample leads**. First five:

- Score 100: 1230 N PEARL ST — RESIDENTIAL-4 TO 8 UNITS — entity/trust owner; small multifamily; recent sale 2025; mailing address differs from property; high-value asset
- Score 100: 3200 N ELIZABETH ST — RESIDENTIAL-4 TO 8 UNITS — entity/trust owner; small multifamily; recent sale 2025; mailing address differs from property; high-value asset
- Score 100: 3219 N STEELE ST — RESIDENTIAL-4 TO 8 UNITS — entity/trust owner; small multifamily; recent sale 2025; mailing address differs from property; high-value asset
- Score 100: 1467 N DETROIT ST — RESIDENTIAL-4 TO 8 UNITS — entity/trust owner; small multifamily; recent sale 2025; mailing address differs from property; high-value asset
- Score 100: 3610 N KRAMERIA ST — RESIDENTIAL-4 TO 8 UNITS — entity/trust owner; small multifamily; recent sale 2025; mailing address differs from property; high-value asset

## Product Decision

Denver supports the first paid test because the source pool is far above the 40–60 usable leads/month threshold. The risk is not raw volume. The risk is **lead intent quality**: parcel data identifies likely owner/rental opportunities, but it does not prove the owner is actively looking for management.

## Pricing Recommendation

- Start: **$799/month** for one protected territory.
- Base target: **2 territories = $1,598 MRR**.
- Do not exceed 2 paid Denver clients until weekly refresh quality is proven.
- Upsell: **Managed Assist at $1,499/month** after a property manager says they want help contacting owners, not just the list.

## Territory Recommendation

1. Denver Core / Central: 80203, 80204, 80205, 80206, 80211
2. West + East/South spillover: 80212, 80219, 80220, 80231, 80238, nearby ZIPs


## Balanced Sample Decision

The first trial sample is now intentionally mixed instead of simply taking the top-scored records. This protects the premium pool and tells us which signal category property managers actually value.

Trial sample size: **25 leads**.

Trial mix:

- **8 Recent Sale Absentee** — recently sold and mailing address differs from property.
- **6 Small Multifamily** — duplex/triplex/4–8 unit non-owner style opportunities.
- **5 Entity Owner** — LLC/trust/entity-owned rental/investor signals.
- **3 Out-of-State Owner** — classic absentee-owner management pain.
- **3 High-Value Asset** — higher-value assets where premium PM positioning may work.

Success threshold: **2–3 leads worth checking further** from the 25-lead sample.

Kill threshold: **5 property managers receive the balanced sample and nobody finds 2 useful leads**.

Paid weekly mix after first close:

- **15 Recent Sale Absentee**
- **12 Small Multifamily**
- **10 Entity Owner**
- **8 Out-of-State Owner**
- **5 High-Value Asset**

Operating rule: each lead gets one primary testing category even when multiple public-record signals overlap. Track which category the buyer says is most useful before changing the mix.

## SDR Call Readiness

CRM app is ready with:

- Denver viability stats
- property manager call queue
- copyable opener
- call status tracking in browser localStorage
- 25 sample owner/rental opportunities
- DenCO-style private sample page

## Risk / Compliance Notes

- Public property records can support lead research, but outreach must stay human, relevant, and non-spammy.
- Do not claim "exclusive" before payment.
- Do not claim owner intent; say "signals that may be worth outreach."
- Do not sell the same lead to direct competitors after payment.

## Kill Criteria

Stop or reprice Denver if any of these happen:

- Fewer than 40 usable leads/month after manual review.
- Fewer than 10 good leads/week for a protected territory.
- SDR sends 5 samples and no property manager says the list is useful.
- First paid client says the first full batch is weak.
- Source data proves too stale without an enrichment layer.

## Next Action

Make calls using the CRM app. Start with DenCO, Colorado Realty and Property Management, Whole Property Management, and Sheepdog. Lead with the sample, not AI.
