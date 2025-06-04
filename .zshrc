# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sorin"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export HISTTIMEFORMAT="%Y-%m-%d %T "

## ALIASES
# some git stuff
alias glog='git log --oneline'
alias gl='glog'
alias gs='glog --stat'
alias g='git status'
alias gd='git diff'
alias gg="git for-each-ref --color=always --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' | less -iXFR"

# backend stuff
alias django-env='env $(cat .env | xargs)'
alias django='django-env python ./backend/manage.py'
alias django-time='stime env $(cat .env | xargs) python ./backend/manage.py'
alias init='cd ~/workspace/pulse && activate'
alias pip-install='env | grep VIRTUAL_ENV &&  LDFLAGS=`pg_config --ldflags` CPPFLAGS=`pg_config --cppflags` uv pip install --compile --no-cache-dir -r backend/requirements.dev.txt || echo "No virtual env detected"'
alias make-venv='uv venv'
alias pip-nuke='activate && rm -rf $VIRTUAL_ENV && deactivate && make-venv'
alias pip-reset='pip-nuke && activate && pip-install'
alias redis-start='brew services start redis'
alias redis-stop='brew services stop redis'

# frontend stuff
alias npm-reset='rm -rf node_modules & npm ci'

alias django-start='init && PYTHONUNBUFFERED=1 honcho start django'
alias django-test='django test -n --noinput'
alias vite-start='init && honcho start vite'
alias maildev-start='init && honcho -f ./tools/Procfile start maildev'
alias celery-worker-start='init && PYTHONUNBUFFERED=1 honcho -f Procfile.celery start worker'
alias celery-flower-start='init && PYTHONUNBUFFERED=1 honcho -f Procfile.celery start flower'
alias storybook-start='init && npm run start-storybook'
alias add-test-plan='./bin/add-test-plan'
alias refresh-deps='pip-install && npm ci'

# Activate Python virtual envs as "activate", "activate devops"
activate_venv() {
    venv_dir=".venv"
    if [[ -n "$1" ]]; then
        venv_dir="$venv_dir-$1"
    fi
    
    source $venv_dir/bin/activate    
}

alias activate='activate_venv'

# fix stuff
alias postgres-cleanup='sudo rm /opt/homebrew/var/postgresql\@14/postmaster.pid & brew services restart postgresql@14'

# misc stuff
alias stime='/usr/bin/time -l -h -p'
alias django-pid='lsof -n -i :8000'
alias tcurl="curl -kv -w '\n* Response time: %{time_total}s\n'"
