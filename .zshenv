path+=/opt/homebrew/opt/postgresql@14
path+=/opt/homebrew/bin
path+=~/workspace/libs
path+=~/.local/share/bob/nvim-bin

# Exports for installing python deps
export LDFLAGS=`pg_config --ldflags`
export CPPFLAGS=`pg_config --cppflags`

# PATH extras
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NODE_OPTIONS="--max-old-space-size=4096"

. ~/.tokens
