#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Install RPMFusion Repos
# ------------------------
for repo in free nonfree; do
    if ! dnf repolist all | grep -q "rpmfusion-$repo"; then
        dnf install -y "https://mirrors.rpmfusion.org/$repo/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"
    fi
done

# ------------------------
# Update System
# ------------------------
dnf update -y

# ------------------------
# Multimedia-Hardware-Beschleunigung
# ------------------------
dnf swap -y ffmpeg-free ffmpeg --allowerasing || true
dnf install -y intel-media-driver libva-intel-driver
dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin || true
dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld || true
dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld || true

# ------------------------
# Tainted Repos für DVD / Firmware
# ------------------------
dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf install -y libdvdcss
dnf install -y --repo=rpmfusion-nonfree-tainted "*-firmware"

# ------------------------
# Nützliche Programme
# ------------------------
dnf install -y htop ranger helix remmina* picard easytag asunder vlc

# ------------------------
# Flatpak Programme
# ------------------------
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub md.obsidian.Obsidian com.zettlr.Zettlr com.usebottles.bottles org.freedesktop.Sdk.Extension.texlive dev.zed.Zed
