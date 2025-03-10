FROM quay.io/fedora/fedora-bootc:41 as base

# We're inheriting from a pretty bare-bones server image, so we're gonna want to layer some batteries over it
# Problems: edac_mce_amd kernel module is not running on guest-os, causing mcelog to start (need to figure out what provides this, and what conditions require it to be installed).
# Groups:
# 	base-graphical: necessary for any desktop session
# 	hardware-support: just broad install for potentially needed hardware-support packages
# 	standard: Common utilities probably already installed, but easier to manage if they're visible under "dnf group list"
# 	core: Stuff needed for smallest possible installation, bootc container seems to install these manually, since some workarounds are needed to make it work.
# 	multimedia: common audio/video libs
# 	fonts: fonts
#	swaywm swaywm-extended: Stuff for sway. This probably also gets rofi grimshot desktop-backgrounds-compat, but I figure I'll keep those there just in case
#	networkmanager-submodules: I like having stuff for NM just in case
RUN dnf install -y \
    @base-graphical @hardware-support @guest-agents @standard @multimedia \
    @fonts \
    @swaywm @swaywm-extended \
    @networkmanager-submodules \
    screenfetch tmux neovim ansible flatpak

# Add flathub to remotes
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Configure sway, hopefully not interfering with packaged sway stuff
COPY ./sway/config /etc/sway/config
COPY ./sway/config.d/*.conf /etc/sway/config.d/

FROM base as host-os

RUN dnf install -y @virtualization
