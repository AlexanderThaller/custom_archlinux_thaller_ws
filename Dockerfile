FROM archlinux:latest

COPY pacman.conf /etc/pacman.conf
COPY mirrorlist /etc/pacman.d/mirrorlist

COPY makepkg.conf /etc/makepkg.conf
COPY sudoers /etc/sudoers

RUN useradd -ms /bin/bash build

COPY \
  build \
  clean \
  entrypoint \
  keys \
  simple \
  rua \
  ./

ARG CACHEBUST=1

RUN pacman-db-upgrade
RUN pacman -Syyu --noconfirm \
  base-devel \
  git \
  rust \
  sudo

ENTRYPOINT ["./entrypoint"]
