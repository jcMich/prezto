#
# Integrates fast-syntax-highlighting into Prezto.
#

# Return if requirements are not found.
if ! zstyle -t ':prezto:module:fast-syntax-highlighting' color; then
  return 1
fi

# Source module files.
source "${0:h}/external/fast-syntax-highlighting.plugin.zsh" || return 1

# Set highlighting styles.
typeset -A syntax_highlighting_styles
zstyle -a ':prezto:module:fast-syntax-highlighting' styles 'syntax_highlighting_styles'
for syntax_highlighting_style in "${(k)syntax_highlighting_styles[@]}"; do
  FAST_HIGHLIGHT_STYLES[$syntax_highlighting_style]="$syntax_highlighting_styles[$syntax_highlighting_style]"
done
unset syntax_highlighting_style{s,}

# Set pattern highlighting styles.
typeset -A syntax_pattern_styles
zstyle -a ':prezto:module:fast-syntax-highlighting' pattern 'syntax_pattern_styles'
for syntax_pattern_style in "${(k)syntax_pattern_styles[@]}"; do
  FAST_BLIST_PATTERNS[$syntax_pattern_style]="$syntax_pattern_styles[$syntax_pattern_style]"
done
unset syntax_pattern_style{s,}
