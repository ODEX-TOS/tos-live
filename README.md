[![Build Status repo](https://jenkins.pbfp.xyz/buildStatus/icon?job=tos-repo&style=flat-square&subject=repo+build)](https://jenkins.pbfp.xyz/job/tos-repo/)
[![Build Status](https://jenkins.pbfp.xyz/buildStatus/icon?job=tos-iso&style=flat-square&subject=iso+build)](https://jenkins.pbfp.xyz/job/tos-iso/)
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/F0xedb/tos-live">
    <img src="https://tos.pbfp.xyz/images/logo.svg" alt="Logo" width="150" height="150">
  </a>

  <h3 align="center">TOS-Live</h3>

  <p align="center">
    This repo contains the build for TOS (Tom OS live iso)
    <br />
    <a href="https://github.com/F0Xedb/repo"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/F0xedb/repo">View Demo</a>
    ·
    <a href="https://github.com/F0xedb/repo/issues">Report Bug</a>
    ·
    <a href="https://github.com/F0xedb/repo/issues">Request Feature</a>
  </p>
</p>


<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project

### Built By

* [F0xedb](https://www.pbfp.xyz)


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

```sh
uname -r
```



### Installation
 
1. Clone the repo
```sh
git clone https:://github.com/F0xedb/tos-live.git
```

> You can only build the iso if you are running an arch based distribution.


## Usage

### Tos iso

Before building the iso you could add your personal repository to the `pacman.conf`file located at `tos-live/toslive/pacman.conf`
You will see the following entry:

```bash
[tos]
SigLevel = Optional TrustAll
Server = https://repo.pbfp.xyz
```

This will use the official repository for tos. If you want to use your own repo change the above to

```
[tos]
 SigLevel = Optional TrustAll
 Server = file:///home/zetta/tos/repo/arch/
```

This repository also includes the build tool to make iso's. The tool can be found under `toslive/start.sh`

It can be activated as followed
```bash
sudo ./start.sh -s # build the server iso
sudo ./start.sh -g # build the desktop iso

sudo ./start.sh -s -a # build the server iso with the keyboard layout to azert
sudo ./start.sh -g -a # build the desktop iso with the keyboard layout to qwerty
```
> start.sh needs to be activated in the same folder or your images won't get build. You also need to be on the latest kernel for the build to succees


## Structure
Our project has the following files you need to know about:

#### toslive/packages.x86_64_client
This file contains all packages required for the operating system (for the desktop edition)
> The packages listed here do not work with the aur see repo below for more info


#### toslive/packages.x86_64_server
This is the same as above but for the server edition (without a desktop)


#### toslive/airootfs/root/customize_airootfs.sh
This file is a script that will be executed during build. In this file you "prepare" the operating system for the user
> Do not install packages from the aur here. It won't work

#### toslive/version.txt
This contains the current version of our operating system. When making a pull request please update it accordingly.

#### toslive/out
This directory will contain all our iso's

#### toslive/images
This directory is an archive for our old images

#### toslive/start.sh
The script that actually builds the iso's

#### repo/build.sh
This will completely build a arch based repository from scratch. If building you own repo don't forget to reference it in the pacman.conf file.

#### repo/genpackagelist.sh
This generates a html file that shows all data about tos packages.

_For more examples, please refer to the [Documentation](https://github.com/F0xedb/tos-live/wiki)_


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/F0xedb/tos-live/issues) for a list of proposed features (and known issues).



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
## Contact

Tom Meyers - tom@pbfp.team

Project Link: [https://github.com/F0xedb/tos-live](https://github.com/F0xedb/tos-live)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [F0xedb](https://www.pbfp.xyz)
* [TOS Homepage](https://tos.pbfp.xyz)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/F0xedb/tos-live.svg?style=flat-square
[contributors-url]: https://github.com/F0xedb/tos-live/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/F0xedb/tos-live.svg?style=flat-square
[forks-url]: https://github.com/oF0xedb/tos-live/network/members
[stars-shield]: https://img.shields.io/github/stars/F0xedb/tos-live.svg?style=flat-square
[stars-url]: https://github.com/F0xedb/tos-live/stargazers
[issues-shield]: https://img.shields.io/github/issues/F0xedb/tos-live.svg?style=flat-square
[issues-url]: https://github.com/F0xedb/tos-live/issues
[license-shield]: https://img.shields.io/github/license/F0xedb/tos-live.svg?style=flat-square
[license-url]: https://github.com/F0xedb/tos-live/blob/master/LICENSE.txt
[product-screenshot]: https://tos.pbfp.xyz/images/logo.svg

