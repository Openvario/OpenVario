#!/bin/bash
# Copy the disk images and recovery ITBs out of the BitBake deploy
# directories into images/<machine>/. Run this on the host, from the
# OpenVario checkout, after build-release-images.sh.

set -eu
shopt -s nullglob

output=images
rm -rf "$output"
mkdir -p "$output"

found=0

copy_board() {
  local deploy=$1
  local machine
  local dest
  local file
  local copied=0

  machine=$(basename "$deploy")
  dest=$output/$machine
  mkdir -p "$dest"

  for file in "$deploy"/OV-*.img.gz "$deploy"/OV-*.ov-rpi-sdimg; do
    if [ -f "$file" ]; then
      cp -a "$file" "$dest/"
      copied=1
    fi
  done

  if [ -f "$deploy/ov-recovery.itb" ]; then
    cp -a "$deploy/ov-recovery.itb" "$dest/ov-recovery-$machine.itb"
    copied=1
  fi

  if [ "$copied" = 1 ]; then
    echo "$machine:"
    ls -lh "$dest"
    found=1
  else
    rmdir "$dest"
  fi
}

for deploy in \
    build-cubie/tmp/deploy/images/ov-* \
    build-cm4/tmp/deploy/images/ov-*
do
  if [ -d "$deploy" ]; then
    copy_board "$deploy"
  fi
done

if [ "$found" != 1 ]; then
  echo "No disk images were produced."
  exit 1
fi
