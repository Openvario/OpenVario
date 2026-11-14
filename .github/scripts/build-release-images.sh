#!/bin/bash
# Build the OpenVario release images. Run this inside the ovbuild
# container, with the checkout mounted at /workdir.
#
# Boards that share a CPU use one build directory. The first board
# compiles the userspace. Later boards reuse it and rebuild the kernel,
# U-Boot, and the image, which is what changes with the display and the
# adapter.
#
# /workdir/downloads and /workdir/sstate-cache are mounted from the
# runner so the next tag does not fetch everything again.

set -u

cd /workdir

git config --global --add safe.directory /workdir
git config --global --add safe.directory /workdir/meta-openvario

# Point BitBake at one build directory and at the shared caches.
start_build_dir() {
  local builddir=$1

  cd /workdir
  unset BUILDDIR
  export TEMPLATECONF=/workdir/meta-openvario/conf/templates/default

  set +u
  # oe-init-build-env refers to variables it has not set yet.
  . openembedded-core/oe-init-build-env "$builddir"
  set -u

  local conf=$builddir/conf/local.conf
  if ! grep -q '^DL_DIR ' "$conf"; then
    echo 'DL_DIR = "/workdir/downloads"' >> "$conf"
    echo 'SSTATE_DIR = "/workdir/sstate-cache"' >> "$conf"
  fi
}

# Build one board. A failure is recorded so the remaining boards still run.
failed=0
build_board() {
  local machine=$1
  shift

  echo
  echo "-------- $machine --------"
  echo "bitbake $*"
  if MACHINE="$machine" bitbake "$@"; then
    echo "$machine done"
  else
    echo "$machine failed"
    failed=1
  fi
}

# Cubieboard 2. Allwinner A20. Disk image and USB recovery ITB.
start_build_dir /workdir/build-cubie

cubie_boards=(
  ov-cb2-am43
  ov-cb2-ch57
  ov-cb2-ch70
  ov-cb2-pq70
  ov-cb2-am70s
  ov-cb2-ch57s
  ov-cb2-ch70s
)

for machine in "${cubie_boards[@]}"; do
  build_board "$machine" openvario-image openvario-recovery-image
done

# Compute Module 4. Cortex-A72, so it does not share the Cubieboard
# build. Disk image only: ov-recovery.itb is the Cubie U-Boot payload.
start_build_dir /workdir/build-cm4

cm4_boards=(
  ov-cm4-ch57
  ov-cm4-pq70
)

for machine in "${cm4_boards[@]}"; do
  build_board "$machine" openvario-image
done

exit "$failed"
