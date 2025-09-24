#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Install RPMFusion Repos
# ------------------------
for repo in free nonfree; do
    if ! dnf repolist all | grep -q "rpmfusion-$repo"; then
        rpm-ostree install -y "https://mirrors.rpmfusion.org/$repo/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"
    fi
done

# ------------------------
# Multimedia-Hardware-Beschleunigung
# ------------------------
rpm-ostree override remove fdk-aac-free libavcodec-free libavdevice-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free ffmpeg-free --install ffmpeg
rpm-ostree install intel-media-driver
rpm-ostree install libva-intel-driver
rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi --allow-inactive
rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld
rpm-ostree install mesa-vdpau-drivers-freeworld

# ------------------------
# Tainted Repos für DVD / Firmware
# ------------------------
dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf install -y libdvdcss
dnf install -y --repo=rpmfusion-nonfree-tainted "*-firmware"

# ------------------------
# Nützliche Programme
# ------------------------
rpm-ostree install htop ranger

# ------------------------
# Flatpak Programme
# ------------------------
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub md.obsidian.Obsidian com.zettlr.Zettlr com.usebottles.bottles org.freedesktop.Sdk.Extension.texlive dev.zed.Zed com.helix_editor.Helix org.musicbrainz.Picard org.gnome.EasyTAG ca.littlesvr.asunder org.videolan.VLC org.remmina.Remmina
