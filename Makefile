build: image cleanup fetch_key packages sync_packages cleanup

packages_and_sync: packages sync

build_single: image cleanup download_packages fetch_key package sync_packages cleanup

image:
	docker build -t custom_archlinux --build-arg CACHEBUST=$(shell date --iso=d) .

cleanup:
	docker run \
		-v "/tmp/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		clean

fetch_key:
	docker run \
		-v "/tmp/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		keys \
		"6C35B99309B5FA62" \
		"$(key)"

packages:
	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "/tmp/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		build \
		"android-sdk" \
		"android-studio" \
		"bacon" \
		"dell-bios-fan-control-git" \
		"direnv" \
		"dive-git" \
		"emacs-native-comp-git-enhanced" \
		"epub2txt-git" \
		"eva-git" \
		"fastmod" \
		"flutter" \
		"google-cloud-sdk" \
		"hadolint-bin" \
		"histdb-rs" \
		"i8kutils" \
		"kafkacat-git" \
		"leftwm" \
		"mkpasswd" \
		"mqtt-explorer" \
		"neuron-zettelkasten-bin" \
		"nginx-mod-fancyindex" \
		"ngrok" \
		"nomad-bin" \
		"rua" \
		"steamcmd" \
		"teams" \
		"teamviewer" \
		"telegraf-bin" \
		"tmux-cssh" \
		"tmux-xpanes" \
		"zoom"

package:
	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "/tmp/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		build \
		"$(package)"

sync_packages:
	./sync

download_packages:
	docker run \
		--cpus="32.0" \
		--cpuset-cpus="0-31" \
		-v "/tmp/custom_archlinux_thaller_ws/outdir/:/home/" \
		custom_archlinux:latest \
		setup

	rsync -azPhe ssh \
	'builduser@root.thaller.ws:/usr/home/builduser/repo/custom/os/x86_64/' \
	/tmp/custom_archlinux_thaller_ws/outdir/build/.local/share/rua/checked_tars/ \
	--exclude=custom.db \
	--exclude=custom.db.tar.gz \
	--exclude=custom.files \
	--exclude=custom.files.tar.gz
