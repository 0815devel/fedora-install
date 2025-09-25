#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Funktionen
# ------------------------
install_rpmfusion() {
    for repo in free nonfree; do
        if ! dnf repolist all | grep -q "rpmfusion-$repo"; then
            echo "Installiere RPMFusion-$repo..."
            rpm-ostree install -y "https://mirrors.rpmfusion.org/$repo/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm" || true
        fi
    done
}

setup_multimedia() {
    echo "Konfiguriere Multimedia und Hardware-Beschleunigung..."
    rpm-ostree override remove fdk-aac-free libavcodec-free libavdevice-free libavfilter-free \
        libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free ffmpeg-free \
        --install ffmpeg || true

    rpm-ostree install intel-media-driver libva-intel-driver || true
    rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras \
        gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi --allow-inactive || true

    rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld || true
    rpm-ostree install mesa-vdpau-drivers-freeworld || true
}

install_tainted() {
    echo "Installiere Tainted Repos und Firmware..."
    rpm-ostree install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted || true
    rpm-ostree install libdvdcss || true
    rpm-ostree install --allow-inactive $(dnf repoquery --repo=rpmfusion-nonfree-tainted '*-firmware') || true
}

install_tools() {
    echo "Installiere nützliche Programme..."
    rpm-ostree install htop ranger borgbackup || true
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
      com.helix_editor.Helix
      org.musicbrainz.Picard
      org.gnome.EasyTAG
      ca.littlesvr.asunder
      org.videolan.VLC
      org.remmina.Remmina
    )

    for pkg in "${flatpaks[@]}"; do
        if ! flatpak list | grep -q "$pkg"; then
            flatpak install -y --noninteractive flathub "$pkg"
        else
            echo "$pkg ist bereits installiert."
        fi
    done
}

system_upgrade() {
    echo "Führe Systemupgrade durch..."
    rpm-ostree upgrade
}

# ------------------------
# Main
# ------------------------
install_rpmfusion
setup_multimedia
install_tainted
install_tools
install_flatpaks
system_upgrade

echo "Setup abgeschlossen!"
