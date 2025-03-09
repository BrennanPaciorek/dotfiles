FROM quay.io/fedora/fedora-bootc:41

RUN dnf install -y \
    sddm sway foot waybar rofi desktop-backgrounds-compat swaybg grimshot sddm-wayland-sway xdg-desktop-portal-wlr thunar \
    unzip screenfetch tmux neovim ansible flatpak
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

COPY ../sway/config /etc/sway/config

RUN systemctl enable sddm.service
