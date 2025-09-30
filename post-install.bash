#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Funktionen
# ------------------------
install_rpmfusion() {
    echo "Installiere RPMFusion Repos..."
    for repo in free nonfree; do
        if ! dnf repolist all | grep -q "rpmfusion-$repo"; then
            echo "RPMFusion-$repo wird installiert..."
            dnf install -y "https://mirrors.rpmfusion.org/$repo/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"
        else
            echo "RPMFusion-$repo ist bereits installiert."
        fi
    done
}

system_update() {
    echo "System wird aktualisiert..."
    dnf update -y
}

setup_multimedia() {
    echo "Multimedia- und Hardware-Beschleunigung wird konfiguriert..."
    dnf swap -y ffmpeg-free ffmpeg --allowerasing || true
    dnf install -y intel-media-driver libva-intel-driver || true
    dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin || true
    dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld || true
    dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld || true
}

install_tainted() {
    echo "Tainted Repos, DVD und Firmware werden installiert..."
    dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted || true
    dnf install -y libdvdcss || true
    dnf install -y --repo=rpmfusion-nonfree-tainted "*-firmware" || true
}

install_tools() {
    echo "Installiere nützliche Programme..."
    dnf install -y htop ranger helix remmina* picard easytag asunder vlc borgbackup || true
}

install_flatpaks() {
    echo "Installiere Flatpaks..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    flatpaks=(
      md.obsidian.Obsidian
      com.zettlr.Zettlr
      com.usebottles.bottles
      org.freedesktop.Sdk.Extension.texlive
      dev.zed.Zed
    )

    for pkg in "${flatpaks[@]}"; do
        if ! flatpak list | grep -q "$pkg"; then
            flatpak install -y --noninteractive flathub "$pkg"
        else
            echo "$pkg ist bereits installiert."
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

echo "Workstation-Setup abgeschlossen!"
