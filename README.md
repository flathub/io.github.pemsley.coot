# _Coot_ (Crystallographic Object-Oriented Toolkit)
_Coot_ is a powerful macromolecular model-building tool for analysing X-ray data and models (i.e. proteins, ligands, RNA and DNA). 

There are many tools for model manipulation and building, such as minimization, molecular superposition, fragment rotation/translations, rotamer-fitting, de novo building and refinement.

_Coot_ is used by scientists using X-ray crystallography or cryo-EM for analysis of proteins, electron density maps, protein interactions and drug design.

This repo hosts the flatpak wrapper for [_Coot_](https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/), available at [Flathub](https://flathub.org/ja/apps/io.github.pemsley.coot).

_Coot_ is under active development at the [upstream repo](https://github.com/pemsley/coot) by Paul Emsley.

## Installation

There are two types of build for different purposes.

### Stable build

This is the latest stable version. It is suitable for the most people for daily use.

```shell
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.pemsley.coot
flatpak run io.github.pemsley.coot
```

### Beta build

**This isn’t meant to be the nightly build, but for the release that has some level of testing and is expected to mostly work and be usable to non-developer end-users.**

```shell
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install flathub-beta io.github.pemsley.coot
flatpak run io.github.pemsley.coot//beta
```

## Building

At first, Install `flatpak-builder` using Flatpak.

```shell
flatpak install flathub org.flatpak.Builder
```

Then, clone this repo to build the app using `flatpak-builder`.

```shell
git clone https://github.com/flathub/io.github.pemsley.coot.git
cd io.github.pemsley.coot
flatpak run org.flatpak.Builder --force-clean --sandbox --user --install --install-deps-from=flathub --ccache --mirror-screenshots-url=https://dl.flathub.org/media/ --repo=repo builddir io.github.pemsley.coot.yaml
```

Finally, you can run the app for testing.

```shell
flatpak run io.github.pemsley.coot
```
