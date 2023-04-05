# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zi

if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod g-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://z-shell.pages.dev/docs/gallery/collection
zicompinit # <- https://z-shell.pages.dev/docs/gallery/collection#minimal


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zi light-mode for \
    z-shell/z-a-rust \
    z-shell/z-a-patch-dl \
    z-shell/z-a-bin-gem-node

# main zi setup
zi ice depth=1; zi load romkatv/powerlevel10k
zi wait lucid for \
    OMZL::completion.zsh \
    OMZL::directories.zsh \
    OMZL::functions.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::misc.zsh \
    OMZL::spectrum.zsh \
    OMZL::termsupport.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZP::git \
    OMZP::fzf \
    OMZP::asdf \
    atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    blockf zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    z-shell/zui \
    bindmap'^F -> ^G' z-shell/zzcomplete \
    as"command" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg" \
        BurntSushi/ripgrep \
    from"gh-r" as"program" pick"bin/exa" atload"alias ls=exa" \
        ogham/exa \
    as"command" from"gh-r" mv"delta* -> delta" pick"delta/delta" \
        atload"git config --global core.pager 'delta --dark'" \
        dandavison/delta \
    as"command" from"gh-r" pick"bin/*" \
        eth-p/bat-extras \
    as"command" from"gh-r" mv"sd-* -> sd" \
        chmln/sd

#zi ice wait lucid as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat" \  # comment out because aash doesn't like less=bat
    #atload"alias cat=bat; alias less=bat; alias more=bat"
zi light sharkdp/bat
zi ice wait lucid as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zi light sharkdp/fd

# load fzf without wait/lucid so it's available for OMZP::fzf
# if this breaks, remove the associated folders in ~/.zi/snippets and ~/.zi/plugins
zi ice as"command" from"gh-r" pick"fzf"
zi light junegunn/fzf
zi ice as"null" cp"*.zsh -> $HOME/.zi/plugins/junegunn---fzf/"
zi snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
zi ice as"null" cp"*.zsh -> $HOME/.zi/plugins/junegunn---fzf/"
zi snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
export FZF_BASE="$(dirname $(which fzf))"

# p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


####### Above this is from ashankar@ #########


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias gradle=gw
export PATH="/usr/local/bin:${PATH}"
export PATH="~/bin:${PATH}"
export PATH="/opt/homebrew/bin:${PATH}"
export PATH="~/.npm-global/bin:${PATH}"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/sbin:${PATH}"

export JAVA_HOME=$("/usr/libexec/java_home" -v "17")

alias ll='ls -l --color=auto'
alias sign="git rebase --exec 'git commit --amend --no-edit -n -S' ${1:-origin/develop}"

export GOPATH=/Volumes/git/go
