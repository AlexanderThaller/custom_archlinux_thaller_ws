# default recipe to display help information
@_default:
    @just --list

# build the builder image
builder:
    docker build \
      --pull \
      --no-cache \
      -t "builder" \
      -f "Dockerfile.builder" \
      .

# build outdated packages (args: [--force] [package...])
packages *args:
    ./resources/build_packages {{ args }}

# build a specific package
package package: builder
    ./resources/generate_package_dockerfile "{{ package }}" > "Dockerfile.{{ package }}"

    docker build \
      -t "packages" \
      -f "Dockerfile.{{ package }}" \
      . ; rm -f "Dockerfile.{{ package }}"

# sync packages with upstream
sync:
    rsync -azPhe ssh \
      --delete \
      --delete-after \
      --delay-updates \
      --safe-links \
      --exclude ".state" \
      "packages/" \
      'root.thaller.ws:/data/archlinux_thaller_ws/custom/'

# build outdated packages and sync them to remote (also if some builds failed)
run:
    -./resources/build_packages
    just sync
