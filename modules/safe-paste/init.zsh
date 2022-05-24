# Code from Mikael Magnusson: http://www.zsh.org/mla/users/2011/msg00367.html
#
# Requires xterm, urxvt, iTerm2 or any other terminal that supports bracketed
# paste mode as documented: http://www.xfree86.org/current/ctlseqs.html

# create a new keymap to use while pasting
bindkey -N paste


# switch the active keymap to paste mode
function safe-paste-start {
  bindkey -A paste main
}
zle -N safe-paste-start
# these is the code sent at the start of the pasted text in bracketed paste mode.
# do the first one with both -M viins and -M vicmd in vi mode
bindkey '^[[200~' safe-paste-start


function safe-paste-insert {
  _paste_content+=$KEYS
}
zle -N safe-paste-insert
# make everything in this keymap call our custom insert widget
bindkey -R -M paste "^@"-"\M-^?" safe-paste-insert
# insert newlines rather than carriage returns when pasting newlines
bindkey -M paste -s '^M' '^J'


# go back to our normal keymap, and insert all the pasted text in the
# command line. this has the nice effect of making the whole paste be
# a single undo/redo event.
function safe-paste-end {
  LBUFFER+=$_paste_content
  unset _paste_content
  bindkey -e  # use bindkey -e here with emacs mode and -v with vi mode.
  # maybe you want to track if you were in ins or cmd mode and restore the right one.
}
zle -N safe-paste-end
# these is the code sent at the end of the pasted text in bracketed paste mode.
bindkey -M paste '^[[201~' safe-paste-end


function zle-line-init {
  # Tell terminal to send escape codes around pastes.
  [[ $TERM == rxvt-unicode || $TERM == xterm || $TERM = xterm-256color || $TERM = screen || $TERM = screen-256color ]] && printf '\e[?2004h'

  # The following comes from the editor module:

  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( $+terminfo[smkx] )); then
    # Enable terminal application mode.
    echoti smkx
  fi

  # Update editor information.
  zle editor-info
}
zle -N zle-line-init


function zle-line-finish {
  # Tell it to stop when we leave zle, so pasting in other programs
  # doesn't get the ^[[200~ codes around the pasted text.
  [[ $TERM == rxvt-unicode || $TERM == xterm || $TERM = xterm-256color || $TERM = screen || $TERM = screen-256color ]] && printf '\e[?2004l'

  # The following comes from the editor module:

  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( $+terminfo[rmkx] )); then
    # Disable terminal application mode.
    echoti rmkx
  fi

  # Update editor information.
  zle editor-info
}
zle -N zle-line-finish
