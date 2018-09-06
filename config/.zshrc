export TERM="xterm-256color"
export ZSH=/root/.oh-my-zsh

# Colorize directory listing
eval `dircolors ~/dircolors-solarized/dircolors.256dark`

# ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_DISABLE_COMPFIX=1

# pure
# autoload -U promptinit; promptinit
# prompt pure

setopt prompt_subst

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  # zgen load miekg/lean
  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure
  
  # generate the init script from plugins above
  zgen save
fi

PROMPT='%(?.%F{white}❯.%F{#dc322f}❯)%f '

[ -f /usr/share/autojump/autojump.zsh ] && . /usr/share/autojump/autojump.zsh

# Wii
export DEVKITPRO=/mnt/c/Users/Niko/Documents/Programming/coyote/devkitpro
export DEVKITPPC=$DEVKITPRO/devkitPPC

# Aliases
alias open="explorer.exe"
alias rz="source ~/.zshrc"
alias ez="vim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias et="vim ~/.tmux.conf"
alias eb="vim ~/.bashrc"
alias vscode="code . > /dev/null 2>&1 &"

# Load tmux
[[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
  [[ -n "$ATTACH_ONLY" ]] && {
    tmux a 2>/dev/null || {
      cd && exec tmux
    }
    exit
  }

  tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
  exec tmux
}
