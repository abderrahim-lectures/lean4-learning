#!/bin/bash
# check-plain-prose.sh — detect two rhetorical habits that make prose hard to read
# even when every individual sentence is correct.
#
# Origin: a reader reported a draft was "hard to read, used unfamiliar vocabulary,
# and felt poetic rather than like a research paper — a reader should not need a
# dictionary." Re-reading confirmed it. The cause was not individual hard words; it
# was two habits running through the whole text:
#
#   A. THE ANTITHESIS DRUMBEAT — "It is not X. It is Y." used for rhetorical
#      effect, repeated dozens of times. Each instance reads fine alone. In bulk it
#      turns a paper into a speech. Distinct from `style-provenance-check`'s
#      hedge-chain rule, which bans "not X, or Y, but rather W" WITHIN one sentence;
#      this is the two-sentence version, and the count is what makes it a defect.
#
#   B. PRECISE BUT UNCOMMON VOCABULARY — forecloses, asymmetric, self-sealing,
#      rationed, dissolve. Not clichés and not metaphors, so the existing rules miss
#      them. They are exact words that send a nonnative reader to a dictionary, and
#      a plainer word almost always carries the same meaning.
#
# Both are frequency defects: one or two instances are fine, a dozen is a rewrite.
# This script therefore reports counts and a density alongside each hit.
#
# Usage: tools/scripts/check-plain-prose.sh <file> [file...]
#        tools/scripts/check-plain-prose.sh lean_book/07-groups/*.md
# Exit: 0 always (advisory). Use the counts to decide; the rewrite is a judgment call.

set -uo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <file> [file...]" >&2
  exit 1
fi

# Words that are precise but send the reader to a dictionary, with the plain
# alternative that almost always carries the same meaning. Extend deliberately:
# a word belongs here only if a plainer word does the same work.
declare -A PLAIN=(
  [forecloses]="rules out"        [foreclose]="rule out"       [foreclosed]="ruled out"
  [asymmetric]="uneven"           [asymmetry]="imbalance"
  [self-sealing]="unfalsifiable"  [rationed]="limited"         [ration]="limit"
  [dissolve]="remove"             [dissolves]="removes"        [dissolved]="removed"
  [obviates]="removes the need for"
  [predicated]="based"            [construe]="read"            [construed]="read"
  [salient]="relevant"            [ostensibly]="apparently"
  [attenuate]="weaken"            [attenuates]="weakens"
  [orthogonal]="unrelated"        [tractable]="workable"
  [elides]="skips over"           [elide]="skip over"          [elided]="skipped over"
  [inheres]="belongs"             [supervenes]="depends"
  [reify]="treat as concrete"     [reified]="treated as concrete"
)

total_anti=0
total_vocab=0

for f in "$@"; do
  [ -f "$f" ] || { echo "SKIP (no such file): $f" >&2; continue; }
  echo "=== $f ==="

  # --- A. antithesis drumbeat -------------------------------------------------
  # Two-sentence form: a sentence whose content is a negation, immediately
  # followed by the positive restatement.
  # The negated clause need not open the sentence ("The result is not a theorem.
  # It is a definition."), and the positive half may follow a comma rather than a
  # full stop ("The claim is not new, it is standard.").
  anti=$(grep -nEo \
    "[^.!?]{0,60}\\b(is|are|was|were) not\\b[^.!?]{0,60}[.!?,][[:space:]]+([Ii]t|[Tt]his|[Tt]hat|[Tt]hey|[Tt]hese) (is|are|was|were)\\b" \
    "$f" 2>/dev/null | head -40)
  # Single-sentence contrastive fragment used as a beat: ", not X." / "— not X."
  beat=$(grep -nEo "[,—-] not [a-z][^.!?]{0,60}[.!?]" "$f" 2>/dev/null | head -40)

  na=$(printf '%s\n' "$anti" | grep -c . )
  nb=$(printf '%s\n' "$beat" | grep -c . )
  [ -z "$anti" ] && na=0
  [ -z "$beat" ] && nb=0

  echo "  [A] antithesis pairs (\"It is not X. It is Y.\"): $na"
  [ "$na" -gt 0 ] && printf '%s\n' "$anti" | head -5 | sed 's/^/      /'
  echo "  [A] contrastive beats (\", not X.\" / \"— not X.\"): $nb"
  [ "$nb" -gt 0 ] && printf '%s\n' "$beat" | head -5 | sed 's/^/      /'

  # --- B. dictionary vocabulary ----------------------------------------------
  vhits=0
  for w in "${!PLAIN[@]}"; do
    c=$(grep -io "\b${w}\b" "$f" 2>/dev/null | wc -l | tr -d ' ')
    if [ "${c:-0}" -gt 0 ]; then
      echo "  [B] ${w} x${c}  -> prefer: ${PLAIN[$w]}"
      vhits=$((vhits + c))
    fi
  done
  [ "$vhits" -eq 0 ] && echo "  [B] no dictionary-vocabulary hits"

  # --- density ---------------------------------------------------------------
  words=$(wc -w < "$f")
  sum=$((na + nb + vhits))
  if [ "$words" -gt 0 ]; then
    per1k=$(awk -v s="$sum" -v w="$words" 'BEGIN{printf "%.1f", (s*1000)/w}')
    echo "  TOTAL $sum findings over $words words (${per1k} per 1000)"
    awk -v p="$per1k" 'BEGIN{
      if (p+0 >= 3.0) print "  VERDICT: rewrite — the habit runs through the whole text";
      else if (p+0 >= 1.0) print "  VERDICT: sweep — several instances; fix them in one pass";
      else print "  VERDICT: acceptable at this density"}'
  fi

  total_anti=$((total_anti + na + nb))
  total_vocab=$((total_vocab + vhits))
done

echo "---"
echo "check-plain-prose: $total_anti antithesis findings, $total_vocab vocabulary findings."
echo "Judge by the density. A single instance is a choice; a dozen is a habit."
exit 0
