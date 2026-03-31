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
docker run -it --rm -v $(pwd):/workdir ghcr.io/openvario/ovbuild-container:latest --workdir=/workdir
```

### Configuring the build (only necessary once after fetching the repos)

```
source openembedded-core/oe-init-build-env .
```

### Setting the machine

```
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

```
bitbake openvario-image
```

If the build fails, try checking out the `scarthgap` branch in `meta-openvario`, as it may resolve the issue. If the problem persists, please open an issue so we can investigate it.
