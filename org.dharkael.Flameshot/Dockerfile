FROM fedora:29

MAINTAINER ZetaoYang "https://github.com/ZetaoYang"

# Install Flatpak and dependencies
RUN dnf -y update && \
    dnf install -y flatpak flatpak-builder ostree fuse wget curl elfutils dconf git bzip2 bzr && \
    dnf clean all

RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install runtimes
RUN flatpak install -y flathub org.kde.Platform//5.12 && \
    flatpak install -y flathub org.kde.Sdk//5.12