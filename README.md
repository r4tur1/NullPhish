<!-- NullPhish -->

<p align="center">
  <img src=".github/misc/logo.png">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0-green?style=for-the-badge">
  <img src="https://img.shields.io/github/license/r4tur1/NullPhish?style=for-the-badge">
  <img src="https://img.shields.io/github/stars/r4tur1/NullPhish?style=for-the-badge">
  <img src="https://img.shields.io/github/issues/r4tur1/NullPhish?color=red&style=for-the-badge">
  <img src="https://img.shields.io/github/forks/r4tur1/NullPhish?color=teal&style=for-the-badge">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Author-r4tur1-blue?style=flat-square">
  <img src="https://img.shields.io/badge/Open%20Source-Yes-darkgreen?style=flat-square">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-lightblue?style=flat-square">
  <img src="https://img.shields.io/badge/Written%20In-Bash-darkcyan?style=flat-square">
  <img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fr4tur1%2FNullPhish&title=Visitors&edge_flat=false"/>
</p>

<p align="center"><b>An automated phishing toolkit for security research, with 30+ templates.</b></p>

##

<h3><p align="center">Disclaimer</p></h3>

<i>Any actions and or activities related to <b>NullPhish</b> is solely your responsibility. The misuse of this toolkit can result in <b>criminal charges</b> brought against the persons in question. <b>The contributors will not be held responsible</b> in the event any criminal charges be brought against any individuals misusing this toolkit to break the law.

<b>This toolkit contains materials that can be potentially damaging or dangerous for social media</b>. Refer to the laws in your province/country before accessing, using, or in any other way utilizing this in a wrong way.

<b>This Tool is made for educational purposes only</b>. Do not attempt to violate the law with anything contained here. <b>If this is your intention, then Get the hell out of here</b>!

It only demonstrates "how phishing works". <b>You shall not misuse the information to gain unauthorized access to someone's social media</b>. However you may try out this at your own risk.</i>

##

### Features

- Latest and updated login pages
- Beginner friendly
- Multiple tunneling options
  - Localhost
  - Cloudflared
  - LocalXpose
- Mask URL support
- Docker support

##

### Installation

- Clone this repository —
  ```
  git clone --depth=1 https://github.com/r4tur1/NullPhish.git
  ```

- Go to the cloned directory and run `nullphish.sh` —
  ```
  $ cd NullPhish
  $ bash nullphish.sh
  ```

- On first launch, dependencies will be installed automatically. ***NullPhish*** is ready.

##

### Installation (Termux)

```
$ pkg install tur-repo
$ pkg install nullphish
$ nullphish
```

> ***Termux discourages hacking*** — never discuss anything related to this tool in Termux discussion groups. See: [wiki](https://wiki.termux.com/wiki/Hacking)

##

### Installation via `.deb` file

- Download `.deb` files from [**Latest Release**](https://github.com/r4tur1/NullPhish/releases/latest)
- For ***Termux***, download the `*_termux.deb` variant

- Install:
  ```
  apt install <path to deb file>
  ```
  Or:
  ```
  $ dpkg -i <path to deb file>
  $ apt install -f
  ```

##

### Run on Docker

- Pull the image:
  - **DockerHub**:
    ```
    docker pull r4tur1/nullphish:latest
    ```
  - **GHCR**:
    ```
    docker pull ghcr.io/r4tur1/nullphish:latest
    ```

- Using the wrapper script:
  ```
  $ curl -LO https://raw.githubusercontent.com/r4tur1/NullPhish/master/run-docker.sh
  $ bash run-docker.sh
  ```

- Temporary container:
  ```
  docker run --rm -ti r4tur1/nullphish
  ```
  > Remember to mount the `auth` directory.

##

<details>
  <summary><h3>Dependencies</h3></summary>

**NullPhish** requires the following to run —
- `git`
- `curl`
- `php`

> All dependencies are installed automatically on first run.
</details>

<details>
  <summary><h3>Tested On</h3></summary>

- **Ubuntu**
- **Debian**
- **Arch**
- **Manjaro**
- **Fedora**
- **Termux**
</details>

##

<h3 align="center"><i>:: Workflow ::</i></h3>
<p align="center">
  <img src=".github/misc/workflow.gif"/>
</p>

##

### To-do List

Sites to be updated :-

- [ ] adobe
- [ ] badoo
- [ ] devian art
- [ ] discord
- [ ] dropbox
- [ ] ebay
- [ ] facebook
- [ ] fb_advanced
- [ ] fb_messenger
- [ ] fb_security
- [ ] github
- [ ] gitlab
- [ ] google
- [ ] google_new
- [ ] google_poll
- [ ] ig_followers
- [ ] ig_verify
- [ ] insta_followers
- [ ] instagram
- [ ] linkedin
- [ ] mediafire
- [ ] microsoft
- [ ] netflix
- [ ] origin
- [ ] paypal
- [ ] pinterest
- [ ] playstation
- [ ] protonmail
- [ ] quora
- [ ] reddit
- [ ] roblox
- [ ] snapchat
- [ ] spotify
- [ ] stackoverflow
- [ ] steam
- [ ] tiktok
- [ ] twitch
- [ ] twitter
- [ ] vk
- [ ] vk_poll
- [ ] wordpress
- [ ] xbox
- [ ] yahoo
- [ ] yandex

##

To add :-

- [ ] bumble
- [ ] epicgames
- [ ] hinge
- [ ] icloud
- [ ] onlyfans
- [ ] patreon
- [ ] riotgames
- [ ] skype
- [ ] teams
- [ ] telegram
- [ ] threads
- [ ] tinder
- [ ] ubisoft
- [ ] wechat
- [ ] whatsapp
- [ ] zoom

##

### Credits

<p>
NullPhish is based on <a href="https://github.com/htr-tech/zphisher"><b>Zphisher</b></a> by <a href="https://github.com/htr-tech"><b>htr-tech (Tahmid Rayat)</b></a>, licensed under GPL-3.0.
All original contributors of Zphisher are acknowledged below.
</p>

<table>
  <tr align="center">
    <td><a href="https://github.com/1RaY-1"><img src="https://avatars.githubusercontent.com/u/78962948?s=100" /><br /><sub><b>1RaY-1</b></sub></a></td>
    <td><a href="https://github.com/adi1090x"><img src="https://avatars.githubusercontent.com/u/26059688?s=100" /><br /><sub><b>Aditya Shakya</b></sub></a></td>
    <td><a href="https://github.com/AliMilani"><img src="https://avatars.githubusercontent.com/u/59066012?s=100" /><br /><sub><b>Ali Milani</b></sub></a></td>
    <td><a href="https://github.com/Meht-evaS"><img src="https://avatars.githubusercontent.com/u/57435273?s=100" /><br /><sub><b>AmnesiA</b></sub></a></td>
    <td><a href="https://github.com/KasRoudra"><img src="https://avatars.githubusercontent.com/u/78908440?s=100" /><br /><sub><b>KasRoudra</b></sub></a></td>
    <td><a href="https://github.com/MoisesTapia"><img src="https://avatars.githubusercontent.com/u/28166400?s=100" /><br /><sub><b>Moises Tapia</b></sub></a></td>
  </tr>
  <tr align="center">
    <td><a href="https://github.com/E343IO"><img src="https://avatars.githubusercontent.com/u/74646789?s=100" /><br /><sub><b>Mr.Derek</b></sub></a></td>
    <td><a href="https://github.com/BDhackers009"><img src="https://avatars.githubusercontent.com/u/67186139?s=100" /><br /><sub><b>Mustakim Ahmed</b></sub></a></td>
    <td><a href="https://github.com/sepp0"><img src="https://avatars.githubusercontent.com/u/36642137?s=100" /><br /><sub><b>sepp0</b></sub></a></td>
    <td><a href="https://github.com/TripleHat"><img src="https://avatars.githubusercontent.com/u/68332137?s=100" /><br /><sub><b>TripleHat</b></sub></a></td>
    <td><a href="https://github.com/Yisus7u7"><img src="https://avatars.githubusercontent.com/u/64093255?s=100" /><br /><sub><b>Yisus7u7</b></sub></a></td>
  </tr>
</table>

##

### Find Me on:

<p align="left">
  <a href="https://github.com/r4tur1" target="_blank"><img src="https://img.shields.io/badge/Github-blue?style=for-the-badge&logo=github"></a>
</p>


