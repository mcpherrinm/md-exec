#!/bin/sh
# Remove md-exec and its binfmt_misc registration. Run as root.
set -eu

PREFIX=${PREFIX:-/usr/local}

[ -e /proc/sys/fs/binfmt_misc/md-exec ] && echo -1 > /proc/sys/fs/binfmt_misc/md-exec
rm -f /etc/binfmt.d/md-exec.conf "$PREFIX/bin/md-exec"

echo "Uninstalled md-exec. Per-user caches remain in ~/.cache/md-exec."
