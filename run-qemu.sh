#!/bin/sh

#
# Run a nerves_system_qemu_arm-based image in QEMU
#
# Usage:
#   run-qemu.sh [Path to .img file]
#

set -e

IMAGE="$1"
DEFAULT_IMAGE="hello_nerves.img"

help() {
    echo
    echo "Usage:"
    echo "  run-qemu.sh [Path to .img file]"
    exit 1
}
[ -n "$IMAGE" ] || IMAGE="$DEFAULT_IMAGE"

[ -f "$IMAGE" ] || (echo "Error: can't find '$IMAGE'"; help)

echo "Extracting U-Boot binary from image..."
umask 0177
TMP_UBOOT=$(mktemp)
trap 'rm -f -- "$TMP_UBOOT"' INT TERM HUP EXIT
dd if="$IMAGE" of="$TMP_UBOOT" skip=256 count=768 2>/dev/null

echo "Starting QEMU..."
qemu-system-arm \
    -M vexpress-a9 -m 1024M \
    -kernel "$TMP_UBOOT" \
    -drive file="$IMAGE",if=sd,format=raw \
    -net nic,model=lan9118,netdev=nervesnet \
    -netdev tap,id=nervesnet,br=bridge1
