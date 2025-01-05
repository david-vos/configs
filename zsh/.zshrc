export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode disabled  # disable automatic updates

plugins=(git)
source $ZSH/oh-my-zsh.sh

autoload -Uz compinit && compinit       # Loads completion modules
setopt AUTO_MENU                        # Show completion menu on tab press
setopt ALWAYS_TO_END                    # Move cursor after completion
setopt COMPLETE_ALIASES                 # Allow autocompletion for aliases
setopt COMPLETE_IN_WORD                 # Allow completion from middle of word
setopt LIST_PACKED                      # Smallest completion menu
setopt AUTO_PARAM_KEYS                  # Intelligent handling of characters
setopt AUTO_PARAM_SLASH                 # after a completion
setopt AUTO_REMOVE_SLASH                # Remove trailing slash when needed
bindkey -v
bindkey '^?' backward-delete-char # Enable backspace after vicmd
bindkey '^h' backward-delete-char
eval "$(starship init zsh)" # Bootstrap starship shells

export PATH=$PATH:/Users/vos/.spicetify

export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
