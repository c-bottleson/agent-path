# Agent Path — Near-Zero-Human Business OS

## North Star

Agent Path should feel like checking the cockpit of a small machine that is already moving.

The user should not wake up and wonder, "What do I need to push today?"

The user should wake up, read one short dashboard/report, make one steering decision if needed, then go be the human employee on calls.

## Roles

### User role: CEO + specialist employee

The user does two jobs only:

1. **CEO / tiller nudge**
   - Look once per day.
   - React to direction.
   - Approve big pivots.
   - Add taste, judgment, and ideas.

2. **Employee / call operator**
   - Run AI Assessment calls.
   - Run setup-walkthrough calls.
   - Give real-world feedback from calls.

The user should not be the project manager, sysadmin, marketer, analytics person, deployment person, or reminder system.

### Captain role: operator + chief of staff + growth team

Captain owns the machine:

- Improve the website.
- Watch the funnel.
- Create and refine assets.
- Maintain scripts and playbooks.
- Draft content and outreach.
- Track calls, leads, and follow-ups.
- Report what changed.
- Recommend the next move.
- Ask for human input only when taste, approval, payment, legal identity, or OAuth approval is required.

## Daily Experience

The user sees one daily report, not a pile of tasks.

Format:

```text
📋 Captain Daily — DATE

Agent Path — Day N
• Status: Clear next bottleneck identified
• Done: Improved page / content / funnel
• Blocked: Only human approval if needed
• Next: Ship one leverage move

📊 Cockpit
• Leads: X
• Calls booked: X
• Calls completed: X
• Revenue: $X
• Site changes shipped: X
• Content drafted: X
• Follow-ups due: X

🧭 Direction
One paragraph: where the business is drifting and what I recommend.

🔮 Next Improvements
• Highest-leverage improvement
• Second improvement if useful
```

## Dashboard Sections

### 1. Money

Track only what changes behavior:

- Revenue collected
- Assessments sold
- Setup installs sold
- Pending follow-ups
- Estimated pipeline value

### 2. Calls

The user is still the call employee, so this is the core operating board:

- Calls booked
- Calls completed
- No-shows
- Follow-ups due
- Close rate
- Common objections
- Best quote/testimonial candidate

### 3. Website/Funnel

Captain reports what changed, not just traffic numbers:

- Landing page improvements shipped
- CTA tested
- Offer clarity score
- Pages indexed / not indexed
- Search impressions/clicks when available
- Top SEO opportunity

### 4. Distribution

Keep it fun and lightweight:

- LinkedIn drafts ready
- Posts published/manual-post needed
- Outreach batches prepared
- Replies/leads
- One story from the week worth turning into content

### 5. Product/Delivery

- Assessment script improvements
- Setup-call script improvements
- Reusable client assets created
- Problems found during calls
- Automation opportunities discovered

## First Metrics To Track

Start with manual-light metrics first. Do not build a complex analytics stack before usage exists.

### Daily manually entered, if needed

- Calls booked
- Calls completed
- Money collected
- Follow-ups owed
- Interesting call notes

### Captain can collect automatically now

- Git commits / shipped changes
- Live page verification
- Website pages and copy changes
- Existing content assets
- Cron/report status
- Vercel deployment status

### Add next

- Vercel Analytics or Plausible for page views
- Google Search Console for SEO impressions/clicks
- Stripe sales/events
- Calendar calls
- Simple CRM log

## Fun Layer

Make this feel like a game:

- **Ship streak:** days Captain improved something.
- **Lead seeds planted:** content/outreach pieces created.
- **Call XP:** each completed call improves scripts/playbooks.
- **Friction removed:** annoying manual steps killed.
- **Boss decision:** one clear decision per day max.

## Kill Criteria

If a daily report creates more work than clarity, simplify it.

If a metric does not change a decision, remove it.

If a dashboard requires the user to maintain it manually, Captain should absorb it or cut it.

## First Build

V1 is not a SaaS dashboard. V1 is a daily Captain report plus a lightweight cockpit page/file.

V1 success means:

- User checks once per day.
- User knows what changed.
- User knows where the business is going.
- User has at most one decision.
- Captain has already done the work, not assigned the work.
