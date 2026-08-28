---
name: skill-scout-daily-cron
description: Documents the local daily cron job that scouts GitHub/Reddit/Anthropic docs for genuinely new Claude Code skill-writing patterns applicable to this repo, and writes a report to reviews/skill-scouting/<date>.md. Read this to understand, debug, or manually trigger that job; it is not itself an invocable review skill.
---

> **See also:** `second-brain/SKILL.md` routes across this repo's review skills.

# Skill Scout (local cron job)

Runs unattended, once daily, via the user's local crontab (not a cloud
routine — the user chose local because the cloud version required
connecting a GitHub App, which they declined). Report-only: it never
modifies `.claude/skills/`, `lean_book/`, `lean_project/`, or
`lean_book_latex/`, and never commits or pushes.

## Files

- `run.sh` — the cron entry point. Sets up logging, reads `prompt.md`,
  invokes `claude -p` headlessly with a scoped `--allowedTools` list
  (`Read,Grep,Glob,WebSearch,WebFetch,Write,Bash(mkdir *),Bash(date *)`)
  so the unattended run never hangs on a permission prompt it can't
  answer.
- `prompt.md` — the self-contained research prompt (repo context, what
  counts as "genuinely new," output location and format).
- `logs/<date>.log` — stdout/stderr of each run, for debugging a run
  that produced no report or an unexpected one.

## Schedule

Installed in the user's crontab as:

```
0 0 * * * /home/adrabi/dev/lean/lean4-learning/.claude/skills/skill-scout-daily-cron/run.sh
```

Midnight local time (Africa/Casablanca), daily. Check with `crontab -l`;
edit with `crontab -e` (do not overwrite other entries already in the
user's crontab, this repo shares it with other projects).

## Output

`reviews/skill-scouting/<YYYY-MM-DD>.md`, one file per day it ran and
found something worth a real proposal (the prompt tells it to say so
plainly and stay short if nothing genuinely new turned up, not pad the
report). These files are report input for a human to review and decide
whether to fold a finding into an actual skill, this job never edits a
skill itself.

## Manual trigger

`bash .claude/skills/skill-scout-daily-cron/run.sh` runs it immediately instead of
waiting for the next midnight fire; check `logs/<today>.log` and
`reviews/skill-scouting/<today>.md` afterward.

## Maintenance

If this repo's own skill catalog changes (a skill added, renamed, or
retired), `prompt.md`'s list of existing skills should be updated to
match, otherwise the job may propose something that already exists
under a different description.
