alias code="flatpak run com.visualstudio.code"
alias nvim="flatpak run io.neovim.nvim"
alias vlc="flatpak run org.videolan.VLC"
alias nvlc="flatpak run --command=nvlc org.videolan.VLC"
alias yt-dl='docker run \
                  --rm -i \
                  -e PGID=$(id -g) \
                  -e PUID=$(id -u) \
                  -v "$(pwd)":/workdir:rw \
                  mikenye/youtube-dl'
