[![Build Status repo][repo-build]][repo-url]
[![Build Status][iso-build]][iso-url]
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL License][license-shield]][license-url]
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FODEX-TOS%2Ftos-live.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FODEX-TOS%2Ftos-live?ref=badge_shield)

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/ODEX-TOS/tos-live">
    <img src="https://tos.odex.be/images/logo.svg" alt="Logo" width="150" height="150">
  </a>

  <h3 align="center">TOS-Live</h3>

  <p align="center">
    This repo contains the build for TOS (Tom OS live iso)
    <br />
    <a href="https://github.com/ODEX-TOS/tos-live"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ODEX-TOS/tos-live">View Demo</a>
    ·
    <a href="https://github.com/ODEX-TOS/tos-live/issues">Report Bug</a>
    ·
    <a href="https://github.com/ODEX-TOS/tos-live/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->

## Table of Contents

- [About the Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Repo](#repo)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

<!-- ABOUT THE PROJECT -->

## About The Project

### Built By

- [F0xedb](https://www.odex.be)

<!-- GETTING STARTED -->

## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

> You need to have an arch based distribution to build the iso and repo.

All the tools provided in the repository will download and install all necessary packages except for the following.

```bash
pacman -Syu archiso # only dependency not installed by our tools
```

Before building the live iso make sure you are on the latest kernel

```bash
uname -r
```

### Installation

1. Clone the repo

```sh
git clone https://github.com/ODEX-TOS/tos-live.git
```

> You can only build the iso if you are running an arch based distribution.

## Usage

### Tos iso

Before building the iso you could add your personal repository to the `pacman.conf` file located at `tos-live/toslive/pacman.conf`
You will see the following entry:

```bash
[tos]
SigLevel = Optional TrustAll
Server = https://repo.odex.be
```

This will use the official repository for tos. If you want to use your own repo change the above to

```
[tos]
 SigLevel = Optional TrustAll
 Server = file:///home/zetta/tos/repo/arch/
```

When using a server to serve your repository you can use the following

> Change the server to point towards your instance. We have delivered a `docker and docker-compose` file so that you can serve the repository tools

Simply launch the `docker-compose` file

```bash
docker-compose up --build -d
```

If you don't use traefik you will have to edit this file. Simply remove the `labels` section and the `network` section. Also add the port section mapping port 80 to port 80. If you wish to update your repository simply rsync to the docker volume.

This repository also includes the build tool to make iso's. The tool can be found under `toslive/start.sh`

It can be activated as followed

```bash
sudo ./start.sh -s # build the server iso
sudo ./start.sh -g # build the desktop iso

sudo ./start.sh -s -a # build the server iso with the keyboard layout to azerty
sudo ./start.sh -g -a # build the desktop iso with the keyboard layout to qwerty

# for more information use the help page
sudo ./start.sh -h
```

> start.sh needs to be activated in the same folder or your images won't get build. You also need to be on the latest kernel for the build to succeed

## Structure

Our project has the following files you need to know about:

#### toslive/packages.x86_64_awesome

This file contains all packages required for the operating system (for the desktop edition)

> The packages listed here do not work with the aur see repo below for more info

#### toslive/packages.x86_64_server

This is the same as above but for the server edition (without a desktop)

#### toslive/airootfs/root/customize_airootfs.sh

This file is a script that will be executed during build. In this file you "prepare" the operating system for the user

> Do not install packages from the aur here. It won't work

#### toslive/packages.x86_64_awesome

This file contains the packages that are going to be installed in the live environment.
You should add an extra line if you want to install an extra package.

> Do not install packages from the aur here. It won't work.

#### toslive/version-edit.txt

This contains the current version of our operating system. When making a pull request please update it accordingly.

#### toslive/out

This directory will contain all our iso's

#### toslive/images

This directory is an archive for our old images

#### toslive/start.sh

The script that actually builds the iso's

#### repo/build.sh

This will completely build a arch based repository from scratch. If building you own repo don't forget to reference it in the pacman.conf file.

The build script has numerous options.

```sh
./build.sh -a # build all generic packages
./build.sh -f # build all fonts
./build.sh -k # build the kernel with one core
./build.sh -k 3 # build the kernel with three cores
./build.sh -u # copy over all detected iso's in the toslive directory over to the repo
./build.sh # interactively ask what needs to be build
```

#### repo/genpackagelist.sh

This generates a html file that shows all data about tos packages.

#### repo/versioncheck.sh

Run this command to get a list of `PKGBUILDS` that need manual intervention to be updated.

#### repo/BUILD/*

Add custom pkgbuild files that will be build and added to the repository

#### repo/build.sh

Build certain parts of the repository
```bash
./build.sh -a # build all common packages
./build.sh -f # build all fonts
./build.sh -k # build the kernel using one core
./build.sh -k 3 # build the kernel using 3 cores
./build.sh # interactivaly build everything
./build.sh -u # upload all build iso images
```

#### repo/cleanup.sh

Remove duplicate packages in the `repo/arch` directory

#### repo/packages.conf

List all packages that will be added to the repo.
Each line equals one package.
For the construction of a line look at the comments in that file

### repo/fonts.conf

Same as above but for fonts.

_For more examples, please refer to the [Documentation](https://github.com/ODEX-TOS/tos-live/wiki)_

## Repo

If you wish to extend the repo you can do so in one of two ways.
You have the `packages.conf and fonts.conf` configuration files or the `BUILD` directory.
The configuration files contain a list of url's that contain valid PKGBUILD files. These files will be executed and then added to the repository.

The format of a line is as followed `<url> <dir to store data> <package name regex> <optional flags>`
The first element contains the url pointing to the PKGBUILD git repo.
The second element contains the directory where we will store this git repo.
The third element contains the name of the final package (that usually end in .pkg.tar.xz) but with the part that always stays the same. (without the version number)
The last part is optional and contain a flag telling the build script to exit the build if this package fails or not.
eg `no-exit` flag will not stop the build if something goes wrong.
Look at `repo/packages.conf` for more information.

The second way of adding packages is when there is no url where to download a PKGBUILD from.
This requires only a little bit more work.
We have a directory called `repo/BUILD` containing a set of PKGBUILD's in the following format. `PKGBUILD_<pkgname>`
where pkgname is the name of the directory where we will perform the build.
Each PKGBUILD will generate a package which is automatically added to the repo.
By default the build script will abort if anything goes wrong.
You can also add a flag to the PKGBUILD file to denote that you don't have to abort the build in case something went wrong.
The flag is the following comment `# NO_ABORT`
An example of this flag is in the `repo/BUILD/PKGBUILD_NVIDIA` file.

You can also add additional files required by a PKGBUILD inside the BUILD directory. They will automatically be copied into your working directory.

<!-- ROADMAP -->

## Roadmap

See the [open issues](https://github.com/ODEX-TOS/tos-live/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- CONTACT -->

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FODEX-TOS%2Ftos-live.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FODEX-TOS%2Ftos-live?ref=badge_large)

## Contact

Tom Meyers - tom@odex.be

Project Link: [https://github.com/ODEX-TOS/tos-live](https://github.com/ODEX-TOS/tos-live)

<!-- ACKNOWLEDGEMENTS -->

## Acknowledgements

- [F0xedb](https://www.odex.be)
- [TOS Homepage](https://tos.odex.be)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[repo-build]: https://jenkins.odex.be/buildStatus/icon?job=tos-repo&style=flat-square&subject=repo+build
[repo-url]: https://jenkins.odex.be/job/tos-repo/
[iso-build]: https://jenkins.odex.be/buildStatus/icon?job=tos-iso&style=flat-square&subject=iso+build
[iso-url]: https://jenkins.odex.be/job/tos-iso/
[contributors-shield]: https://img.shields.io/github/contributors/ODEX-TOS/tos-live.svg?style=flat-square
[contributors-url]: https://github.com/ODEX-TOS/tos-live/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ODEX-TOS/tos-live.svg?style=flat-square
[forks-url]: https://github.com/ODEX-TOS/tos-live/network/members
[stars-shield]: https://img.shields.io/github/stars/ODEX-TOS/tos-live.svg?style=flat-square
[stars-url]: https://github.com/ODEX-TOS/tos-live/stargazers
[issues-shield]: https://img.shields.io/github/issues/ODEX-TOS/tos-live.svg?style=flat-square
[issues-url]: https://github.com/ODEX-TOS/tos-live/issues
[license-shield]: https://img.shields.io/github/license/ODEX-TOS/tos-live.svg?style=flat-square
[license-url]: https://github.com/ODEX-TOS/tos-live/blob/master/LICENSE.txt
[product-screenshot]: https://tos.odex.be/images/logo.svg
