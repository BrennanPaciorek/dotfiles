all: neovim-config git-config
.PHONY: build-bootc-container build-bootc-image

BOOTC_IMAGE_NAME ?= localhost/bpaciore/fedora-bootc-workstation:latest

neovim-config:
	mkdir -p "${HOME}/.config/nvim/lua"
	cp "neovim/init.lua" "${HOME}/.config/nvim/init.lua"
	rsync -a --delete "neovim/lua/" "${HOME}/.config/nvim/lua/"

git-config:
	mkdir -p "${HOME}/.config/"
	rm -rf "${HOME}/.config/git-template"
	cp -r git/git-template/ "${HOME}/.config/git-template"
	git config --global init.templateDir "${HOME}/.config/git-template"

build-bootc-container:
	podman build -t ${BOOTC_IMAGE_NAME} .

build-bootc-image: build-bootc-container
	podman run \
	    --rm \
	    -it \
	    --privileged \
	    --pull=newer \
	    --network=none \
	    --security-opt label=type:unconfined_t \
	    -v ./config.toml:/config.toml:ro \
	    -v ./output:/output \
	    -v /var/lib/containers/storage:/var/lib/containers/storage \
	    quay.io/centos-bootc/bootc-image-builder:latest \
	    --type qcow2 \
	    --use-librepo=True \
	    --rootfs=btrfs \
	    ${BOOTC_IMAGE_NAME}

build-bootc-image-using-sudo: build-bootc-image
	# Update permissions to not be root if this was run as root
	chown -R ${USER}:${USER} output/*

# Requires: qemu-system-x86_64
test-bootc-image:
	qemu-system-x86_64 \
	    -M accel=kvm \
	    -cpu host \
	    -display gtk,gl=on \
	    -device virtio-gpu-rutabaga,cross-domain=on,hostmem=4G,wayland-socket-path=/tmp/nonstandard/mock_wayland.sock,wsi=headless \
	    -audio driver=pipewire,model=virtio \
	    -smp 4 \
	    -m 16384 \
	    -bios /usr/share/OVMF/OVMF_CODE.fd \
	    -drive file=output/qcow2/disk.qcow2
