# PATH extras
export PATH="$PATH:$HOME/.local/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f ~/.secrets ]; then
  source ~/.secrets
fi

if [ -f ~/.zshenv-workspace ]; then
  # Load workspace specific aliases if the file exists
  echo "Loading workspace specific env from ~/.zshenv-workspace"
  source ~/.zshenv-workspace
fi
