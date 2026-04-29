# Profile Isolation — Architecture Rules

## The Problem

When multiple Hermes profiles run on one VPS, each profile should be completely isolated — separate memory, separate sessions, separate cron jobs, separate context. But there's a critical pitfall:

**Crons created under the main profile inherit main's full context.**

This means if you create a Captain's daily report cron under the main profile, the cron will have access to ALL of main's projects, memory, and context — not just the Captain's. The Captain's report will start referencing projects it shouldn't know about.

## The Rule

**Profile-specific crons MUST be created under that profile's own cron system.**

```bash
# ✗ WRONG — creates cron under main profile, inherits main's context
hermes cron create '0 9 * * *' --name 'Captain Daily Report' --deliver 'telegram:12345'

# ✓ CORRECT — creates cron under Captain's profile, isolated context
hermes --profile captain cron create '0 9 * * *' --name 'Captain Daily Report' --deliver 'telegram:12345'
```

## How to Verify

After creating a cron, verify it landed in the right place:

```bash
# Check Captain's crons
cat ~/.hermes/profiles/captain/cron/jobs.json | python3 -m json.tool

# Check main's crons (Captain's crons should NOT be here)
cat ~/.hermes/cron/jobs.json | python3 -m json.tool
```

## What Gets Isolated Per Profile

| Resource | Location | Isolated? |
|----------|----------|-----------|
| Config | `~/.hermes/profiles/<name>/config.yaml` | ✓ |
| Secrets | `~/.hermes/profiles/<name>/.env` | ✓ |
| Memory | `~/.hermes/profiles/<name>/memory/` | ✓ |
| Sessions | `~/.hermes/profiles/<name>/sessions/` | ✓ |
| Skills | `~/.hermes/profiles/<name>/skills/` | ✓ |
| Cron jobs | `~/.hermes/profiles/<name>/cron/jobs.json` | ✓ |
| Gateway service | `hermes-gateway-<name>.service` | ✓ |

## Common Pitfalls

1. **Creating crons via `hermes cron create` (no `--profile`)** — goes to main, inherits everything
2. **Using the `cronjob` tool in chat** — always targets the current profile, but if you're chatting with main, it goes to main
3. **Editing the wrong `jobs.json`** — `~/.hermes/cron/jobs.json` is main, `~/.hermes/profiles/<name>/cron/jobs.json` is the profile
4. **Forgetting to restart the gateway** after adding crons to a profile — the gateway needs to reload to pick up new jobs

## After Installing a Captain

1. Verify crons are in `~/.hermes/profiles/captain/cron/jobs.json` (not main's)
2. Restart Captain's gateway: `hermes --profile captain gateway restart`
3. Verify Captain's SOUL.md has explicit boundaries (what it does NOT know about)
4. Test: send Captain a message and confirm it only references its own project
