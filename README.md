# OpenVario Software Image

This is repository to build the Software Image for Openvario Flight Computer

## Issues and discussion

As this repository just represents the build system of the image, the issue reporting and discussions related to the **meta-openvario** layer shall still take in the correspoding repo.

[Issues](https://github.com/Openvario/meta-openvario/issues)

[Dicussions](https://github.com/Openvario/meta-openvario/discussions)

## How to build an image

### Prerequisites

- Linux installation
- Installed Docker (<https://docs.docker.com/install/>)

### Fetching sources

```bash
git clone --recurse-submodules https://github.com/Openvario/OpenVario.git
cd OpenVario
```

This will fetch the sources including all submodules.

### Starting the containerd build environment

```bash
docker run -it --rm -v $(pwd):/workdir ghcr.io/openvario/ovbuild-container:latest --workdir=/workdir
```

### Configuring the build inside the docker container (only necessary once after fetching the repos)

```bash
source openembedded-core/oe-init-build-env .
```

### Setting the machine

```bash
export MACHINE=ov-cb2-ch70
```

### Available machines for the OpenVario

    Cubieboard 2 and the original adapter board
    ===========================================

    ov-cb2-am43
    ov-cb2-ch57
    ov-cb2-ch70
    ov-cb2-pq70
  
    Cubieboard 2 and the adapter board DS2
    ======================================

    ov-cb2-am70s
    ov-cb2-ch57s
    ov-cb2-ch70s

    Raspberry Pi CM4 (testing status)
    =================================
    
    ov-cm4-ch57
    ov-cm4-pq70

    ov-rpi4 (developemt only)
    ov-rpi4-64 (development only)

### Starting the build

```bash
bitbake openvario-image
```

### Writing the image to an SD card

The image is a file in `tmp/deploy/images/<machine>/OV-*.img.gz`. It is a whole-disk image and includes the bootloader.

Ensure its not auto mounted by your os:

```bash
sudo umount /dev/sdX*
```

Then write the image to the card with the below commands:

```bash
ls tmp/deploy/images/${MACHINE}/OV-*.img.gz
image=$(ls tmp/deploy/images/${MACHINE}/OV-*.img.gz | grep -v testing)
version=$(basename "$image" .img.gz)
version=${version#OV-}
zcat tmp/deploy/images/${MACHINE}/OV-${version}.img.gz | sudo dd of=/dev/sdX bs=16M conv=fsync status=progress
```

### USB recovery stick

**NOTE:** This only works if OpenVario is already installed on the SD card.

Build the recovery image:

```bash
bitbake openvario-recovery-image
```

Copy the recovery image and the disk image onto a fat formatted usb stick. U-Boot loads `openvario/ov-recovery.itb` from that stick:

```bash
image=$(ls tmp/deploy/images/${MACHINE}/OV-*.img.gz | grep -v testing)
version=$(basename "$image" .img.gz)
version=${version#OV-}
sudo mkdir -p /mnt/usbstick
sudo mount /dev/sda1 /mnt/usbstick
sudo mkdir -p /mnt/usbstick/openvario/images
sudo cp tmp/deploy/images/${MACHINE}/ov-recovery.itb /mnt/usbstick/openvario/
sudo cp tmp/deploy/images/${MACHINE}/OV-${version}.img.gz /mnt/usbstick/openvario/images/
printf 'IMAGEFILE=%s\nUPGRADE_TYPE=1\n' "OV-${version}.img.gz" | sudo tee /mnt/usbstick/openvario/upgrade.cfg >/dev/null
sudo umount /mnt/usbstick
```

Reboot your openvario with the usbstick attached.

Recovery renames `upgrade.cfg` to `_upgrade.cfg` after the write, so the stick does not install again.

### Build errors, development branches and upstream dependency changes

We are currently working on updating the commit references used for the stable OpenVario releases to ensure reproducible builds and long‑term maintainability.

For development purposes, please use the `scarthgap` branch of meta-openvario, as it contains the most up‑to‑date fixes and improvements.

Please note that some parts of the build — especially the testing image — track upstream development branches. These components may introduce new dependencies, change existing ones, or cause incompatibilities at any time, which can lead to unexpected build failures.

If the build fails, try checking out the `scarthgap` branch in meta-openvario, as it may resolve the issue.
If the problem persists, please open an issue in [Openvario/meta-openvario](https://github.com/Openvario/meta-openvario/issues) so we can investigate it.
