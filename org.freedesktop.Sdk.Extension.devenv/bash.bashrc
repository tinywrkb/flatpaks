#
# ${DEVELOPMENT_ENVIRONMENT_SDK}/etc/bash.bashrc
#

################################################################################
##############################     Term init      ##############################
################################################################################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

DEVELOPMENT_ENVIRONMENT_SDK=/usr/lib/sdk/devenv

shopt -s nullglob extglob

################################################################################
##############################  Local functions  ###############################
################################################################################

local_functions=()

try_source() {
  if [ -r "$1" ]; then
    source "$1"
    return 0
  fi
  return 1
}; local_functions+=(try_source)

try_catch_source() {
  try_source "$1"
  return 0
}; local_functions+=(try_catch_source)

set_complete_alias() {
  declare -F _complete_alias &>/dev/null &&
    defined_complete_alias="yes"

  # alternative
  #[ "$(type _complete_alias)" == "function" ] &&
  #  defined_complete_alias="yes"
  #fi
}; local_functions+=(set_complete_alias)

is_defined_complete_alias() {
  [ "$defined_complete_alias" = "yes" ] || return 1
  return 0
}; local_functions+=(is_defined_complete_alias)

try_complete_alias() {
  is_defined_complete_alias &&
    complete -F _complete_alias "$1"
}; local_functions+=(try_complete_alias)

################################################################################
############################   Global functions   ##############################
################################################################################

try_source "$XDG_CONFIG_HOME"/bash/bash.functions ||
  try_catch_source ~/.bash.functions

try_source $DEVELOPMENT_ENVIRONMENT_SDK/enable.sh

################################################################################
##############################    Extra PATHs    ###############################
################################################################################

if [ -z "$BASH_EXTRA_PATHS" ]; then
  export BASH_EXTRA_PATHS=1

  extra_paths=(
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/flatpak-run-cli/exports/bin"
  )

  for extra_path in ${extra_paths[@]}; do
    if [[ ":$PATH:" != *":$extra_path:"* ]]; then
      PATH+=":$extra_path"
    fi
  done

  export PATH
fi

################################################################################
##############################        PS1         ##############################
################################################################################

# default PS1
PS1='[\u@\h \W]\$ '

# git PS1
try_source /usr/share/git/completion/git-prompt.sh &&
  PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# powerline-go
function _update_ps1() {
  # save return value as a workaround to it being swallowed by pyenv init
  ret=$?
  _cdw_pyenv_root_update
  PS1="$($(exit $ret); powerline-go -error $? -jobs $(jobs -p | wc -l) -shell-var FLATPAK_ID -numeric-exit-codes -modules venv,user,shell-var,ssh,cwd,perms,git,jobs,exit,root)"
}

# pyenv shell integration
if which pyenv &>/dev/null; then
  export _PYENV_FOUND=1
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

_pyenv_init() {
  # pyenv init creates background jobs as it forks the shell instead of using subshell, see pyenv-init: print_path()
  export _PYENV_INIT=1
  eval "$(pyenv init -)"
  local _pyenv_exec=$(realpath $(which pyenv 2>/dev/null))
  if [ -r "$PYENV_ROOT"/plugins/pyenv-virtualenv/bin/pyenv-virtualenv ] ||
    [ -r ${_pyenv_exec%/*/*}/plugins/pyenv-virtualenv/bin/pyenv-virtualenv ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
}

_pyenv_update() {
  [ -n "$_PYENV_INIT" ] || _pyenv_init
  #eval "$(pyenv init --path)"
  # more aggresive PATH update
  IFS=:
  paths=($PATH)
  for i in ${!paths[@]}; do
    if [[ ${paths[i]} == "${PYENV_ROOT}/shims" ]] ||
      [[ ${paths[i]} == *"pyenv/shims" ]]; then
      unset 'paths[i]'
    fi
  done
  PATH="${paths[*]}"
  unset IFS
  export PATH="${PYENV_ROOT}/shims:${PATH}"

  _pyenv_virtualenv_hook
}

# pyenv auto PYENV_ROOT update
function _cdw_pyenv_root_update() {
  # dynamic PYENV_ROOT updater is opt-in
  if [ -n "$AUTO_PYENV_ROOT" ] && [ -n "$_PYENV_FOUND" ]; then
    if [ -d "$PWD/.pyenv" ]; then
      # only update PYENV_ROOT when different from $PWD/.pyenv
      if [ "$PWD/.pyenv" != "$PYENV_ROOT" ]; then
        # switching back to global pyenv_root
        if [ "$PWD/.pyenv" == "$GLOBAL_PYENV_ROOT" ]; then
          unset PROJECT_PYENV_ROOT
          export PYENV_ROOT="$GLOBAL_PYENV_ROOT"
          _pyenv_update
        # switching to a different project
        elif [ "$PYENV_ROOT" == "$PROJECT_PYENV_ROOT" ] ||
          [ -z "$PYENV_ROOT" ]; then
          export PROJECT_PYENV_ROOT="$PWD/.pyenv"
          export PYENV_ROOT="$PROJECT_PYENV_ROOT"
          _pyenv_update
        # PYENV_ROOT is already set, so save it as global
        elif [ -n "$PYENV_ROOT" ]; then
          export GLOBAL_PYENV_ROOT="$PYENV_ROOT"
          export PROJECT_PYENV_ROOT="$PWD/.pyenv"
          export PYENV_ROOT="$PROJECT_PYENV_ROOT"
          _pyenv_update
        # project pyenv_root without global one
        else
          export PROJECT_PYENV_ROOT="$PWD/.pyenv"
          export PYENV_ROOT="$PROJECT_PYENV_ROOT"
          _pyenv_update
        fi
      fi
    # no .pyenv, need to decide to reset back to global or unset
    else
      # if cwd is not a subfolder of project with .pyenv, then reset PYENV_ROOT
      if [ -n "$PROJECT_PYENV_ROOT" ] &&
        [[ "$PWD" != "${PROJECT_PYENV_ROOT%.pyenv}"* ]]; then
        unset PROJECT_PYENV_ROOT
        if [ -n "$GLOBAL_PYENV_ROOT" ]; then
          export PYENV_ROOT="$GLOBAL_PYENV_ROOT"
          _pyenv_update
        else
          unset PYENV_ROOT
          _pyenv_update
        fi
      fi
    fi
  fi
}

if [ "$TERM" != "linux" ] && (which powerline-go &>/dev/null); then
  # workaround 1 for ssh and startup scratchpad issue
  #PROMPT_COMMAND='printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
  #PROMPT_COMMAND=''
  # workaround 2 for ssh and startup scratchpad issue
  if [ -z "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="_update_ps1"
  else
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
  fi
fi

################################################################################
##############################    Completions     ##############################
################################################################################

# bash-completion
try_catch_source ${DEVELOPMENT_ENVIRONMENT_SDK}/share/bash-completion/bash_completion

# bash git completion
try_catch_source /usr/share/git/completion/git-completion.bash

# complete-alias
if ! is_defined_complete_alias; then
  try_source ~/.local/apps/bash-complete-alias ||
    try_source ${DEVELOPMENT_ENVIRONMENT_SDK}/share/bash-complete-alias/complete_alias ||
    try_catch_source /usr/share/bash-complete-alias/complete_alias
  set_complete_alias
fi

# TODO: user bash completion folder
#unset user_completion
#[ -d ~/.local/bin/bash-completion ] &&  user_completion=(~/.local/bin/bash-completion/!(*.md))
#for file in "${user_completion[@]}"; do
#  source "$file"
#done
#unset file user_completion

################################################################################
###############################      Vars       ################################
################################################################################

# ccache
# avoid setting CCACHE_MAXSIZE by creating ccache.conf in CCACHE_DIR with max_size = 5.0G
#export CCACHE_DISABLE=true

# editor
which nvim &>/dev/null && export EDITOR=nvim

# TODO: optionally set similar environment variables as flatpak-builder

################################################################################
##############################      Aliases       ##############################
################################################################################

# byobu/tmux/screen
which byobu &>/dev/null && alias b=byobu

# lsd
which lsd &>/dev/null && alias ls="lsd" && try_complete_alias ls

# makepkg
alias mksrcinfo='[ -f PKGBUILD ] && makepkg --printsrcinfo > .SRCINFO  || echo "Can'\''t find PKGBUILD"'

# nvim
which nvim &>/dev/null && {
  alias vim="nvim" && try_complete_alias vim
  alias e="nvim" && try_complete_alias e
}

# trash-cli
which rmtrash &>/dev/null && {
  alias rm=rmtrash
  alias rmdir=rmdirtrash
  alias rrm=/bin/rm && try_complete_alias rrm
  alias rrmdir=/bin/rmdir && try_complete_alias rrmdir
}

################################################################################
###########################   XDG dirs workaround   ############################
################################################################################

# bash
export HISTFILE="$XDG_DATA_HOME/bash_history"

# gnupg
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# openssl
export RANDFILE="$XDG_CACHE_HOME/rnd"

# readline
if [ -f "$XDG_CONFIG_HOME/readline/inputrc" ]; then
  export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
elif [ -f "$HOME/.config/readline/inputrc" ]; then
  export INPUTRC="$HOME/.config/readline/inputrc"
else
  export INPUTRC="$DEVELOPMENT_ENVIRONMENT_SDK/etc/inputrc"
fi

# less
# flatpak workround as less doesn't check .config if XDG_CONFIG_HOME is set
if [ -f "$HOME/.config/lesskey" ]; then
  export LESSKEYIN="$HOME/.config/less"
fi

# svn
alias svn='svn --config-dir "$XDG_CONFIG_HOME/subversion"'

# wget
alias wget='wget --hsts-file="$XDG_CACHE_HOME"/wget-hsts'

################################################################################
################################     Colors     ################################
################################################################################

# man colors
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# less colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
# and so on

# ls colors aliases
_colorized='--color=always'
alias lsLC='ls -al $_colorized | less'
alias ls='ls --color=auto'

# colors test
## https://unix.stackexchange.com/questions/41563/how-to-create-a-testcolor-sh-like-the-following-screenshot/213471#213471
alias color='echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m"; for FGs in "    m" "   1m" "  30m" "1;30m" "  31m" "1;31m" "  32m" "1;32m" "  33m" "1;33m" "  34m" "1;34m" "  35m" "1;35m" "  36m" "1;36m" "  37m" "1;37m"; do FG=${FGs// /}; echo -en " $FGs \033[$FG  $T  "; for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"; done; echo; done; echo'

################################################################################
##############################  Extra functions  ###############################
################################################################################

################################################################################
##############################     SSH-Agent     ###############################
################################################################################

################################################################################
#############################  Terminal graphics  ##############################
################################################################################

################################################################################
##############################   Local bashrc   ###############################3
################################################################################

try_source "$XDG_CONFIG_HOME"/bash/bashrc.local ||
  try_catch_source ~/.bashrc.local

################################################################################
###############################    Finalize    #################################
################################################################################

# unset local functions
for f in "${local_functions[@]}"; do
  unset -f "$f"
done
unset local_functions

# systemd annoyance, always follows /home symlink
if [[ "$PWD" == "/var/homes/"* ]]; then
  cd ${PWD/#\/var\/homes/\/home}
fi
