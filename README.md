# OpenVario Software Image

This is repository to build the Software Image for Openvario Flight Computer

## Issues and discussion

As this repository just represents the build system of the image, the issue reporting and discussions related to the **meta-openvario** layer shall still take in the correspoding repo.

[Issues](https://github.com/Openvario/meta-openvario/issues)

[Dicussions](https://github.com/Openvario/meta-openvario/discussions)

## How to build an image

### Prerequisites

 - Linux installation 
 - Installed Docker (https://docs.docker.com/install/)
 
### Fetching sources

```
git clone --recurse-submodules https://github.com/Openvario/OpenVario.git
cd OpenVario
```

This will fetch the sources including all submodules.

### Starting the containerd build environment
```
docker run -it --rm -v $(pwd):/workdir ghcr.io/openvario/ovbuild-container:main --workdir=/workdir
```

### Configuring the build (only necessary once after fetching the repos)

```
source openembedded-core/oe-init-build-env .
```

### Setting the machine

```
export MACHINE=openvario-7-CH070
```

### Available machines for the OpenVario 
    
    
    Cubieboard 2 and the original adapter board
    ===========================================

    ov-cb2-43-rgb
    ov-cb2-57-lvds
    ov-cb2-7-ch070
    ov-cb2-7-pq070
  
    Cubieboard 2 and the adapter board DS2
    ======================================

    ov-cb2-57-lvds-ds2
    ov-cb2-7-am070-ds2
    ov-cb2-7-ch070-ds2
    ov-cb2-7-pq070-ds2

    Raspberry Pi CM4 (testing status)
    =================================
    
    ov-cm4-7-pq070
    ov-cm4-57-lvds

    ov-rpi4 (developemt only)
    ov-rpi4-64 (development only)

### Starting the build

```
bitbake openvario-image
```
