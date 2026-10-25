alias mv_root="zip -r main.love * && mv main.love /storage/emulated/0/"
alias go_root="cd /storage/emulated/0/"
alias ls="eza --icons"

./tuxsay/tuxsay.sh
export ROOT="/storage/emulated/0/"

eval "$(starship init bash)"

#[[ ${USER-} ]] || export USER=$(id -un)
#source -- ~/.local/share/blesh/ble.sh
