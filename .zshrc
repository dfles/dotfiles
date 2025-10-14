# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sorin"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

source <(fzf --zsh)
bindkey -v

export HISTTIMEFORMAT="%Y-%m-%d %T "

# Some git stuff
alias glog='git log --oneline'
alias gl='glog'
alias gs='glog --stat'
alias g='git status'
alias gd='git diff'

alias gga="git for-each-ref --color=always --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' | less -iXFR"
alias gg="gga | head -n 10"

# Activate Python virtual envs as "activate", "activate devops"
activate_venv() {
    venv_dir=".venv"
    if [[ -n "$1" ]]; then
        venv_dir="$venv_dir-$1"
    fi

    source $venv_dir/bin/activate
}

alias activate='activate_venv'

portpid() {
  lsof -n -i :$1
}

alias tcurl="curl -kv -w '\n* Response time: %{time_total}s\n'"
alias stime='/usr/bin/time -l -h -p'

if [ -f ~/.zshrc-workspace ]; then
  # Load workspace specific aliases if the file exists
  echo "Loading workspace specific aliases from ~/.zshrc-workspace"
  source ~/.zshrc-workspace
fi

# Temp alias since I still need to work while rebuilding my config
alias lnvim='NVIM_APPNAME=lnvim nvim'
