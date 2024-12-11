#!/usr/bin/bash

dnf_install () {
    dnf install -y $1
}

dnf_swap () {
    dnf swap -y $1
}

dnf_update () {
    dnf update -y $1
}

# install RPMFusion
dnf_install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# update  repository
dnf_update

# multimedia
dnf_swap "ffmpeg-free ffmpeg --allowerasing"
dnf_update '@multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin'
dnf_install "intel-media-driver"
dnf_swap "mesa-va-drivers mesa-va-drivers-freeworld"
dnf_swap "mesa-vdpau-drivers mesa-vdpau-drivers-freeworld"
dnf_install "rpmfusion-free-release-tainted"
dnf_install "libdvdcss"
dnf_install "rpmfusion-nonfree-release-tainted"
dnf_install '--repo=rpmfusion-nonfree-tainted "*-firmware"'

# Install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
| tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf_update
dnf_install "code"

# install system tools
dnf_install "htop ranger"

# install multimedia applicantions
dnf_install "remmina* texlive-scheme-full picard easytag asunder musicbrainz"
