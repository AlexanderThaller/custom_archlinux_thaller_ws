# default recipe to display help information
@_default:
  @just --list

# build the builder image
builder:
  docker build -t "builder" . -f "Dockerfile.builder"

# build all packages
packages:
  ./resources/generate_packages_dockerfile > Dockerfile.packages

  docker build \
    -t "packages" \
    -f "Dockerfile.packages" \
    .

  rm -rf packages

  id=$(docker create packages) && \
  docker cp "${id}:/output" packages && \
  docker rm -v "${id}"

  cd packages && \
  repo-add custom.db.tar.gz *.pkg.tar.*

# build a specific package
package package:
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
  	"packages/" \
  	'root.thaller.ws:/data/archlinux_thaller_ws/custom/'
