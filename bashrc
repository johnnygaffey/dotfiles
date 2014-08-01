[[ -f /etc/bash/bashrc ]] && . /etc/bash/bashrc

# Exit if non-interactive
[[ $- != *i* ]] && return

#vim mode in the shell
set -o vi

PATH="/sbin:/usr/sbin:$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -f $HOME/.bash_prompt ]] && source $HOME/.bash_prompt

# Aliases
alias ls='ls -F --color=auto'    #colors
alias l='ls -F --color=auto'    #colors
alias ll='ls -lsah --color=auto'  #long list
alias la='ls -AF --color=auto'  #show hidden
alias lx='ls -lXB --color=auto'  #sort by sextension
alias lk='ls -lSr --color=auto'  #sort by size biggest last
alias lc='ls -ltcr --color=auto' #sort by and show chagne times
alias lu='ls -ltur --color=auto' #sort by and show access time
alias lt='ls -ltr --color=auto'  #sort by date
alias lm='ls -al |more'          #pipe through more
alias lr='ls -lR'                #recursive
alias tree='tree -Csuh'          #alternative to recursive ls
alias df='df -kTh'
alias path='echo -e ${PATH//:/\\n}'
alias grep='grep -i --color=auto'

# Silly sudo
alias salt='sudo salt'

# Program defaults
alias bundleupdate='vim -c BundleUpdate -c qa'

# To keep typos alive
alias snv="svn"
alias cim="vim"
alias bim="vim"
alias svim="vim"
alias suod="sudo"
alias sduo="sudo"
alias vm="mv"

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

e=\\\033
export PS1="\n\[$e[35m\].-(\[$e[33m\]\u@\h \[$e[36m\]\t\[$e[35m\] \$(parse_git_branch))\[$e[0m\]\w\n\[$e[35m\]\\\`-->\[$e[0m\] "

export EDITOR=vim

unset LD_PRELOAD
alias runserver="python manage.py runserver"
alias prunserver="python manage.py runserver 0.0.0.0:8000"
alias mcb_runserver="python manage_website_coupon_buddy.py runserver"
alias mcb_prunserver="python manage_website_coupon_buddy.py runserver 0.0.0.0:8182"

[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh
