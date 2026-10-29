#!/bin/sh
# Install md-exec and register it with binfmt_misc for the .md extension.
# Run as root: sudo ./install.sh
set -eu

PREFIX=${PREFIX:-/usr/local}
HANDLER=$PREFIX/bin/md-exec
# E = match on file extension; the kernel runs "$HANDLER /path/file.md args..."
RULE=":md-exec:E::md::$HANDLER:"

install -Dm755 "$(dirname "$0")/md-exec" "$HANDLER"

# Persist across reboots via systemd-binfmt.
mkdir -p /etc/binfmt.d
echo "$RULE" > /etc/binfmt.d/md-exec.conf

# Register now.
BINFMT=/proc/sys/fs/binfmt_misc
[ -e "$BINFMT/register" ] || mount -t binfmt_misc binfmt_misc "$BINFMT"
[ -e "$BINFMT/md-exec" ] && echo -1 > "$BINFMT/md-exec"
echo "$RULE" > "$BINFMT/register"

echo "Installed $HANDLER and registered .md with binfmt_misc."
echo "Try: chmod +x examples/fizzbuzz.md && ./examples/fizzbuzz.md 20"
