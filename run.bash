#!/usr/bin/bash

# install RPMFusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# install Terra
dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# update  repository
dnf update -y

# multimedia
dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf install -y intel-media-driver
dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
dnf install -y rpmfusion-free-release-tainted
dnf install -y libdvdcss
dnf install -y rpmfusion-nonfree-release-tainted
dnf install -y --repo=rpmfusion-nonfree-tainted "*-firmware"

# install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
| tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf update -y
dnf install -y code

# install system tools
dnf install -y htop ranger neovim firefox

# install multimedia applicantions
dnf install -y remmina* texlive-scheme-full picard easytag asunder musicbrainz vlc
