#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Functions
# ------------------------
install_rpmfusion() {
    echo "Install RPMFusion Repos..."
    for repo in free nonfree; do
        if ! dnf repolist all | grep -q "rpmfusion-$repo"; then
            echo "RPMFusion-$repo is installing..."
            dnf install -y "https://mirrors.rpmfusion.org/$repo/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"
        else
            echo "RPMFusion-$repo is already installed."
        fi
    done
}

system_update() {
    echo "System is updating..."
    dnf update -y
}

setup_multimedia() {
    echo "Multimedia- and Hardware-Acceleration installing..."
    dnf swap -y ffmpeg-free ffmpeg --allowerasing || true
    dnf install -y intel-media-driver libva-intel-driver || true
    dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin || true
    dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld || true
    dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld || true
}

install_tainted() {
    echo "Tainted Repos, DVD and Firmware installing..."
    dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted || true
    dnf install -y libdvdcss || true
    dnf install -y --repo=rpmfusion-nonfree-tainted "*-firmware" || true
}

install_tools() {
    echo "Installing Packages..."
    dnf install -y htop ranger helix remmina* picard easytag asunder vlc rclone virt-viewer virt-manager || true
}

install_flatpaks() {
    echo "Installing Flatpaks..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    flatpaks=(
      md.obsidian.Obsidian
      com.zettlr.Zettlr
      com.usebottles.bottles
      org.freedesktop.Sdk.Extension.texlive
    )

    for pkg in "${flatpaks[@]}"; do
        if ! flatpak list | grep -q "$pkg"; then
            flatpak install -y --noninteractive flathub "$pkg"
        else
            echo "$pkg is already installed."
        fi
    done
}

# ------------------------
# Main
# ------------------------
install_rpmfusion
system_update
setup_multimedia
install_tainted
install_tools
install_flatpaks

echo "Workstation-Setup done!"
