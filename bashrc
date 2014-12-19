[[ -f /etc/bash/bashrc ]] && . /etc/bash/bashrc

# Exit if non-interactive
[[ $- != *i* ]] && return

#vim mode in the shell
set -o vi

PATH="/sbin:/usr/sbin:$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -f $HOME/.bash_prompt ]] && source $HOME/.bash_prompt

[[ -f $HOME/.bash_alias ]] && source $HOME/.bash_alias


if [ -f /usr/bin/fortune ]; then
    command fortune 95% calvin firefly
fi

# Custom functions
[[ -f $HOME/.bash_functions ]] && source $HOME/.bash_functions

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export EDITOR=vim

unset LD_PRELOAD
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

# Completions not managed via Gentoo
[[ -f $HOME/.bash_comp ]] && source $HOME/.bash_comp
