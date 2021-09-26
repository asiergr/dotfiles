# Exports
export EDITOR="nvim"
export CLICOLOR=1
export BAT_THEME="Nord"

export PATH=$HOME/bin:$HOME/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/Library/TeX/texbin

# Aliases
alias less="less -R"
alias grep="grep --color=auto"
alias cat="bat -p --paging=never"
alias ls=exa
alias l="exa -l"
alias ll="exa -al"
alias vim=nvim
alias config='/usr/bin/git --git-dir=/Users/asier/.cfg/ --work-tree=/Users/asier'
# Aliases for Homebrew and Rosetta
alias brewr="arch -x86_64 /usr/local/bin/brew $@"
alias leg="arch -x86_64 $@"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Starship and Zoxide
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

