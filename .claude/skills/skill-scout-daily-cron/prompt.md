You are running as a scheduled, unattended daily research pass for the
repo at the current working directory (abderrahim-lectures/lean4-learning,
checked out locally). This repo is a single book project, "Lean for
Working Algebraists" (Markdown source in lean_book/, a companion Lean 4
project in lean_project/, a LaTeX/PDF pipeline in lean_book_latex/), plus
its own Claude Code skills under .claude/skills/.

Read .claude/skills/second-brain/SKILL.md first for the full catalog of
this repo's own skills (adversarial-book-reviewer,
adversarial-maths-reviewer, category-theory-accuracy-reviewer,
notation-consistency-reviewer, proof-search-analyst, lean-code-auditor,
latex-typesetting-reviewer, prose-style-reviewer, claude-final-reviewer)
so you know what already exists before proposing anything as new.

Your job today: search the public web (GitHub repos and topics such as
"claude-code-skills", "awesome-claude-code", "claude-skills"; relevant
subreddits such as r/ClaudeAI and r/ClaudeCode; Anthropic's own Claude
Code documentation and changelog) for genuinely new ideas, conventions,
or patterns for writing and maintaining Claude Code skills that would
concretely help THIS repo's specific work: adversarial review of a
mathematics textbook, Lean 4 proof verification, LaTeX/PDF build review,
and prose-style checking.

Do not report generic "best practices" already reflected in this repo's
existing skills (persona-based adversarial structure, WHAT/WHY/IMPACT/FIX
finding bars, citation requirements, bounded-loop re-review) — only
report what is actually new or meaningfully different from what is
already here.

Do NOT modify any file in .claude/skills/, lean_book/, lean_project/, or
lean_book_latex/. Do NOT run git commit or git push. This is a
report-only run.

Write your findings to a new file at
reviews/skill-scouting/<YYYY-MM-DD>.md (today's real date, from `date
+%F`; create the reviews/skill-scouting/ directory if it does not exist)
with this structure:

1. Summary (2-3 sentences on whether anything genuinely new was found).
2. Findings, each with: the source (a real URL you actually fetched, not
   a guess), what the pattern/idea is, and a concrete proposal for how it
   would apply to one of this repo's specific skills, naming the skill
   file.
3. If nothing genuinely new was found, say so plainly in one sentence and
   do not pad the report with restated existing practice.

Keep the whole report under 500 words unless there are 3+ genuinely new
findings that each need more space. The dated report file under
reviews/skill-scouting/ is the only file you should create or write.
