FROM archlinux:latest

COPY pacman.conf /etc/pacman.conf
COPY mirrorlist /etc/pacman.d/mirrorlist
COPY makepkg.conf /etc/makepkg.conf
COPY gpg_key_files/ /etc/gpg_key_files/

ARG CACHEBUST=1

RUN pacman-db-upgrade
RUN pacman -Syyu --noconfirm \
  base-devel \
  git \
  rust \
  sudo

COPY sudoers /etc/sudoers

RUN useradd -ms /bin/bash build
RUN sudo -u "build" gpg --import /etc/gpg_key_files/6C35B99309B5FA62.asc

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
