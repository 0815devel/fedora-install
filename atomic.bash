#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Function
# ------------------------
install_rpmfusion() {
    local changed=0

    for repo in free nonfree; do
        if ! rpm-ostree status | grep -q "rpmfusion-$repo"; then
            echo "Installing RPMFusion-$repo..."
            if rpm-ostree install -y \
                "https://mirrors.rpmfusion.org/$repo/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"; then
                changed=1
            else
                echo "Warning: Installation of rpmfusion-$repo failed"
            fi
        else
            echo "rpmfusion-$repo is already installes, skip..."
        fi
    done

    if [ $changed -eq 1 ]; then
        echo "Repos had been installed, Reboot..."
        systemctl reboot
    else
        echo "No new Repos no Reboot"
    fi
}

setup_multimedia() {
    echo "Multimedia and Hardware-Acceleratiom..."
    rpm-ostree override remove fdk-aac-free libavcodec-free libavdevice-free libavfilter-free \
        libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free ffmpeg-free \
        --install ffmpeg || true

    rpm-ostree install intel-media-driver libva-intel-driver || true
    rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras \
        gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi --allow-inactive || true

    rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld || true
    rpm-ostree install mesa-vdpau-drivers-freeworld || true
}

install_tools() {
    echo "Install Packagea..."
    rpm-ostree install htop ranger rclone || true
}

install_flatpaks() {
    echo "Install Flatpaks..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    flatpaks=(
      md.obsidian.Obsidian
      com.zettlr.Zettlr
      com.usebottles.bottles
      org.freedesktop.Sdk.Extension.texlive
      com.helix_editor.Helix
      org.musicbrainz.Picard
      org.gnome.EasyTAG
      ca.littlesvr.asunder
      org.videolan.VLC
      org.remmina.Remmina
      org.virt_manager.virt-manager
      org.virt_manager.virt-viewer
    )

    for pkg in "${flatpaks[@]}"; do
        if ! flatpak list | grep -q "$pkg"; then
            flatpak install -y --noninteractive flathub "$pkg"
        else
            echo "$pkg is already installed."
        fi
    done
}

system_upgrade() {
    echo "Updating..."
    rpm-ostree upgrade
}

# ------------------------
# Main
# ------------------------
install_rpmfusion
setup_multimedia
install_tools
install_flatpaks
system_upgrade

echo "Setup done!"
