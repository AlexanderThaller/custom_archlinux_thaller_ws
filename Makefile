build: image cleanup fetch_key packages sync_packages cleanup

packages_and_sync: packages sync

build_single: image cleanup download_packages fetch_key package sync_packages cleanup

image:
	docker build -t custom_archlinux --build-arg CACHEBUST=$(shell date --iso=d) .

cleanup:
	mkdir -p "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/"

	docker run \
		-v "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		clean

fetch_key:
	mkdir -p "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/"

	docker run \
		-v "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		keys \
		"139B09DA5BF0D338" \
		"3AB00996FC26A641" \
		"6AD860EED4598027" \
		"6C35B99309B5FA62" \
		"$(key)"

packages:
	mkdir -p "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/"

	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		build \
		"dell-bios-fan-control-git" \
		"dive-git" \
		"emacs-git" \
		"epub2txt-git" \
		"etcd" \
		"eva-git" \
		"fastmod" \
		"google-cloud-sdk" \
		"google-cloud-sdk-gke-gcloud-auth-plugin" \
		"hadolint-bin" \
		"hstdb" \
		"i8kutils" \
		"insync" \
		"jackett" \
		"jellyfin" \
		"jsonnet-bundler" \
		"kafkacat-git" \
		"krew" \
		"nginx-mod-fancyindex" \
		"ngrok" \
		"nomino" \
		"pushgateway" \
		"rua" \
		"seafile-client" \
		"snapd" \
		"sonarr" \
		"steamcmd" \
		"teamviewer" \
		"telegraf-bin" \
		"tmux-cssh" \
		"tmux-xpanes" \
		"uhk-agent-appimage" \
		"wsdd" \
		"zfs-dkms" \
		"zoom"

package:
	mkdir -p "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/"

	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		build \
		"$(package)"

sync_packages:
	./sync

download_packages:
	mkdir -p "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/"

	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "${HOME}/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		setup

	rsync -azPhe ssh \
	'192.168.1.200:/data/archlinux_thaller_ws/custom/' \
	${HOME}/.cache/custom_archlinux_thaller_ws/outdir/build/.local/share/rua/checked_tars/ \
	--exclude=custom.db \
	--exclude=custom.db.tar.gz \
	--exclude=custom.files \
	--exclude=custom.files.tar.gz
