FROM archlinux:latest

COPY pacman.conf /etc/pacman.conf
COPY mirrorlist /etc/pacman.d/mirrorlist
COPY makepkg.conf /etc/makepkg.conf

ARG CACHEBUST=1

RUN pacman-db-upgrade
RUN pacman -Syyu --noconfirm \
  base-devel \
  git \
  rust \
  sudo

COPY sudoers /etc/sudoers

RUN useradd -ms /bin/bash build

COPY \
  build \
  clean \
  entrypoint \
  keys \
  rua \
  setup \
  simple \
  ./

ENTRYPOINT ["./entrypoint"]
