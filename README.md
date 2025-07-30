## Dependencies

* URI: https://github.com/yoctoproject/poky
* URI: https://git.openembedded.org/openembedded-core
* URI: https://git.yoctoproject.org/git/meta-raspberrypi
* URI: https://github.com/rauc/meta-rauc

## Yocto Project Build Environment Setup
Build environment is compilant with Liunux Ubuntu 20.04.4 LTS(Focal Fossa)
The build system can be installed natively or run with WSL2 on Windows 10/11

### Native Ubuntu instalation
- Install Ubuntu Desktop
https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview

### Ubuntu on Microsoft Windows WSL
- Windows Subsystem for Linux (WSL)
To install Ubuntu 20.04 on WSL use command:
```shell
C:\> wsl --install -d Ubuntu-20.04
```
https://learn.microsoft.com/en-us/windows/wsl/install

### Setup the build environment:

```shell
sudo apt update
sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python-is-python3 python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 python3-subunit zstd liblz4-tool ssh make python3-pip tar jq bmap-tools
```

### Download the 'repo' utility:

```shell
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo | sudo tee /usr/bin/repo > /dev/null
sudo chmod a+x /usr/bin/repo
```

### Fetch Project Manifest:

Make sure the git is set up properly:
```shell
git config --global user.name "Your Name"
git config --global user.email "Your Email"
```

To store git account credential use:
```shell
git config --global credential.helper store
```

Create new folder for the project folder, and navigate to it.
Fetch the project manifest:
```shell
repo init -u https://github.com/sadomich/imon-manifest.git -b scarthgap
```

### Download/Update the project sources:
```shell
repo sync --no-clone-bundle
```

### Configure the iMon Yocto Project:
```shell
TEMPLATECONF=../meta-imon/conf/templates/default . sources/poky/oe-init-build-env build/
```

### Build for specific machine:
**Note:** the first build will take a long time.

For Pigeon RB350 Board:
```shell
MACHINE=rb350-64 bitbake imon-image
```
For Pigeon RB700 Board:
```shell
MACHINE=rb700-64 bitbake imon-image
```
For Techbase x500 Board:
```shell
MACHINE=x500-64 bitbake imon-image
```

### Flash machine image:
Install libusb:
```shell
sudo apt-get install libusb-1.0-0-dev
```

Compile and install raspberry usbboot tools:
```shell
git clone https://github.com/raspberrypi/usbboot
cd usbboot
make && sudo make install
```

Run rpiboot:
```shell
sudo rpiboot
```

Connect PC USB cable into the USB device port, power up the board, now system should detect new USB Mass Storage device.
Find out the name of mapped storage device (like /dev/sd<X>), by executing mount or dmesg.

```shell
sudo bmaptool copy <build folder>/tmp-glibc/deploy/images/<MACHINE>/imon-image-<MACHINE>.wic.xz /dev/sd<X>
```
