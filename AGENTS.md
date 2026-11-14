# OpenVario agent notes

This repository builds the OpenVario disk image. Yocto layers are pinned
submodules. OpenVario behaviour lives in `meta-openvario`. Do not copy
`.cursor/rules/` into this file. Open the matching rule when the work
matches the table below.

## Always

- Change the image in `meta-openvario`. Leave `bitbake`,
  `openembedded-core`, `meta-openembedded`, `meta-arm`, `meta-sunxi`,
  `meta-raspberrypi`, and `meta-rauc` at the pinned revisions.
- `conf/`, `tmp/`, `downloads/`, and `sstate-cache/` are generated and
  gitignored. Do not commit them.
- A recipe change is a commit in the `meta-openvario` repository. Updating
  the pin is a separate commit here.
- Layer pull requests target `scarthgap`. Pull requests for this
  repository target `main`.
- Bugs in the running image are reported on Openvario/meta-openvario.
  This repository is the build system.

## Rules

| When working on | Read |
| --- | --- |
| Where a change belongs | `.cursor/rules/openvario-layout.mdc` |
| Docker, BitBake, images | `.cursor/rules/build.mdc` |
| Recipes, classes, machine config | `.cursor/rules/bitbake.mdc` |
| Recovery image or the USB stick | `.cursor/rules/recovery.mdc` |
| `README.md` | `.cursor/rules/readme.mdc` |
