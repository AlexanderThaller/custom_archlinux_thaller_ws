build: image cleanup fetch_key packages sync_packages cleanup

packages_and_sync: packages sync

build_single: image cleanup download_packages fetch_key package sync_packages cleanup

image:
	docker build -t custom_archlinux --build-arg CACHEBUST=$(shell date --iso=d) .

cleanup:
	docker run \
		-v "/home/athaller/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		clean

fetch_key:
	docker run \
		-v "/home/athaller/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		keys \
		"139B09DA5BF0D338" \
		"3AB00996FC26A641" \
		"6AD860EED4598027" \
		"6C35B99309B5FA62" \
		"$(key)"

packages:
	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "/home/athaller/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
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
		"jsonnet-bundler" \
		"kafkacat-git" \
		"krew" \
		"mkpasswd" \
		"nginx-mod-fancyindex" \
		"ngrok" \
		"nomino" \
		"obs-v4l2sink" \
		"pushgateway" \
		"rua" \
		"seafile-client" \
		"snapd" \
		"steamcmd" \
		"teamviewer" \
		"telegraf-bin" \
		"tmux-cssh" \
		"tmux-xpanes" \
		"uhk-agent-appimage" \
		"zfs-dkms" \
		"zoom"

package:
	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "/home/athaller/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		build \
		"$(package)"

sync_packages:
	./sync

download_packages:
	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "/home/athaller/.cache/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		setup

	rsync -azPhe ssh \
	'root.thaller.ws:/data/archlinux_thaller_ws/custom/' \
	/home/athaller/.cache/custom_archlinux_thaller_ws/outdir/build/.local/share/rua/checked_tars/ \
	--exclude=custom.db \
	--exclude=custom.db.tar.gz \
	--exclude=custom.files \
	--exclude=custom.files.tar.gz
