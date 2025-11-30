all: neovim-config git-config
.PHONY: build-bootc-container build-bootc-image test-bootc-image bash-rc-d bash

BOOTC_IMAGE_NAME ?= quay.io/brenp5744/fedora-bootc-desktop
BOOTC_IMAGE_TARGET ?= host-os
BOOTC_IMAGE_TYPE ?= qemu
TOOLBOX_IMAGE_NAME ?= quay.io/brenp5744/dev-toolbox
TOOLBOX_IMAGE_TAG ?= latest
QEMU_EXECUTABLE ?= qemu-system-x86_64

neovim-config:
	mkdir -p "${HOME}/.config/nvim/lua"
	cp "neovim/init.lua" "${HOME}/.config/nvim/init.lua"
	rsync -a --delete "neovim/lua/" "${HOME}/.config/nvim/lua/"

bash-rc-d:
	mkdir -p "${HOME}/.bashrc.d"

bash: bash-rc-d
	cp ./bash/bashrc.d/* "${HOME}/.bashrc.d/"

build-toolbox-container:
	podman build -t ${TOOLBOX_IMAGE_NAME}:${TOOLBOX_IMAGE_TAG} -f Containerfile.toolbox .

build-bootc-container:
	podman build -t ${BOOTC_IMAGE_NAME}:${BOOTC_IMAGE_TARGET} --target ${BOOTC_IMAGE_TARGET} .

build-bootc-image: build-bootc-container
	podman run \
	    --rm \
	    -it \
	    --privileged \
	    --pull=newer \
	    -v ./config.toml:/config.toml:ro \
	    -v ./output:/output \
	    -v /var/lib/containers/storage:/var/lib/containers/storage \
	    quay.io/centos-bootc/bootc-image-builder:latest \
	    --type "${BOOTC_IMAGE_TYPE}" \
	    --use-librepo=True \
	    --rootfs=btrfs \
	    ${BOOTC_IMAGE_NAME}:${BOOTC_IMAGE_TARGET}

# Requires: qemu-system-x86_64
test-bootc-image:
	${QEMU_EXECUTABLE} \
	    -M accel=kvm \
	    -cpu host \
	    -vga virtio \
	    -device virtio-gpu-rutabaga,cross-domain=on,hostmem=8G,wayland-socket-path=/tmp/nonstandard/mock_wayland.sock,wsi=headless \
	    -audio driver=pipewire,model=virtio \
	    -smp 4 \
	    -m 16384 \
	    -bios /usr/share/OVMF/OVMF_CODE.fd \
	    -drive file=output/qcow2/disk.qcow2
