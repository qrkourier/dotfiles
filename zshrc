
# return unless interactive 
case $- in
  *i*) true
     ;;
    *) return 1
     ;;
esac

#
## oh-my-zsh
#

export ZSH=$HOME/Sites/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="terminalparty"
#ZSH_THEME="nicoulaj"
#ZSH_THEME="jreese"
#ZSH_THEME="dpoggi"
ZSH_THEME="pure"
#ZSH_THEME="random"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker gitfast history-substring-search vault github git-extras
ubuntu tmux pip jira git bundler vi-mod vim-interaction systemadmin ssh-agent
python nmap nanoc httpie history heroku git-prompt gem firewalld debian
cloudapp branch web-search vagrant urltools tmuxinator systemd sudo stack rvm
ruby rsync gpg-agent gnu-utils git-remote-branch gitignore encode64
common-aliases aws)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

bindkey -v
bindkey -M vicmd v edit-command-line

#
## includes
#

# glob-order rc files in $RCS
RCS+=(~/sh.d/*.sh)
# install zsh-syntax-highlighting
RCS+=(/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh)

# for each rc do source if expected mime type or complain
for RC in ${RCS[*]}; do
  test -s $RC && { file --dereference --mime $RC | \
    egrep -q 'text/(x-shellscript|plain)'; } && {
      source $RC;
    } || {
      echo -e "\e[1;49;31m ERROR: \e[0m$RC" >&2 ;
    }
done
unset RCS

#
## overrides
#

typeset -aU path                  # enforce uniqueness in $path
path+=(~/{.,}bin)                 # my scripts
path+=(~/Sites/sysops/bin)        # team scripts
path+=(~/{.local,.rvm,perl5}/bin) # interpreted packages
path+=(/usr/local/{s,}bin)        # installed from src
path+=({/usr,}/{s,}bin $path)     # vendor packages

# zshoptions are case-insensitive and underscore is ignored
# setopt = set -<opt> = non-default state
# unsetopt = set +<opt> = default state
#
# append or truncate, not copy and replace HISTFILE if symlink
setopt APPEND_HISTORY
unsetopt HIST_SAVE_BY_COPY
# write on exit, not return to prompt
unsetopt INC_APPEND_HISTORY
# write latest occurence of identical command lines
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
# store bash-compat history
unsetopt EXTENDED_HISTORY
unsetopt SHARE_HISTORY
# emulate ksh (like bash)
setopt KSH_ARRAYS

# remember
HISTSIZE=6543210
SAVEHIST=6543210

# configure pydrive
export GOOGLE_DRIVE_SETTINGS=~/etc/kbingham-backup-pydrive.conf

