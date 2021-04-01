# .bashrc

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

#history completition using fzf

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# my prompt

PS1="\[\033[32m\]  \[\033[37m\]\[\033[34m\]\w \[\033[0m\]"
PS2="\[\033[32m\]  > \[\033[0m\]"

PATH=$PATH:~/.local/bin

# unlimted bash history 
HISTSIZE=
HISTFILESIZE=

# Aliases
alias ls='ls --color=auto'
alias vim='nvim'

#xbps commands
alias xi='doas xbps-install -S'
alias xr='doas xbps-remove -Ro'
alias xu='doas xbps-install -Suv'
alias xq='doas xbps-query'

# youtube-dl to download stuffs
alias yt='youtube-dl --extract-audio --add-metadata --xattrs --embed-thumbnail --audio-quality 0 --audio-format mp3'
alias ytv='youtube-dl --merge-output-format mp4 -f "bestvideo+bestaudio[ext=m4a]/best" --embed-thumbnail --add-metadata'
