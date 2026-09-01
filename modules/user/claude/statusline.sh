#!/usr/bin/env bash

# Read all of stdin into a variable
input=$(cat)

# Extract fields with jq, "// 0" provides fallback for null
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
MODEL=$(echo "$input" | jq -r '.model.display_name')
EFFORT=$(echo "$input" | jq -r '.effort.level')
CTX=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Subscription limit usage; absent when the account has no limit data
FIVE_HOUR=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
SEVEN_DAY=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' | cut -d. -f1)

# Labels and separators are faint, values carry the colour
DIM=$'\033[2m'
RESET=$'\033[0m'
CYAN=$'\033[36m'
BLUE=$'\033[34m'

# Traffic light for a usage percentage: comfortable, getting full, nearly out
pct_color() {
  if [ "${1:-0}" -lt 50 ]; then
    printf '\033[32m'
  elif [ "${1:-0}" -lt 80 ]; then
    printf '\033[33m'
  else
    printf '\033[31m'
  fi
}

# One-cell vertical gauge: lower block elements fill the cell from the bottom,
# over a grey background so the unfilled remainder of the cell stays visible
pct_bar() {
  local levels=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
  local idx=$(( ${1:-0} * 8 / 100 ))
  [ "$idx" -gt 7 ] && idx=7
  # 22m drops the label's faint attribute so the glyph keeps full contrast;
  # 49m clears the background and 2m restores faintness for what follows
  printf '\033[22m\033[100m%s\033[49m\033[2m' "${levels[$idx]}"
}

# "Label: value" with a faint label and a coloured value
field() {
  printf '%s%s: %s%s%s' "$DIM" "$1" "$3" "$2" "$RESET"
}

SEP="$DIM | $RESET"
OUT="$(field Dir "${DIR##*/}" "$RESET")$SEP$(field Model "$MODEL" "$CYAN")$SEP$(field Effort "$EFFORT" "$BLUE")"
OUT="$OUT$SEP$(field Ctx "$CTX% $(pct_bar "$CTX")" "$(pct_color "$CTX")")"
[ -n "$FIVE_HOUR" ] && OUT="$OUT$SEP$(field 5h "$FIVE_HOUR% $(pct_bar "$FIVE_HOUR")" "$(pct_color "$FIVE_HOUR")")"
[ -n "$SEVEN_DAY" ] && OUT="$OUT$SEP$(field 7d "$SEVEN_DAY% $(pct_bar "$SEVEN_DAY")" "$(pct_color "$SEVEN_DAY")")"

printf '%s\n' "$OUT"
