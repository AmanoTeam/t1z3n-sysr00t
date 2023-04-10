#!/bin/bash

set -e
set -u

declare -r TIZEN_HOME="${HOME}/tizen-studio"

declare -r current_source_directory="${PWD}"

declare -ra targets=(
	'iot-headless-device'
	'iot-headed-device-64'
	'iot-headed-device-32'
	'wearable-device'
	'wearable-emulator'
	'mobile-device'
	'mobile-emulator'
)

for target in "${targets[@]}"; do
	source "${current_source_directory}/${target}.sh"
	
	declare tarball="${current_source_directory}/${target}.tar.xz"
	declare directories='./usr ./lib'
	
	if [ -d "${sysroot}/lib64" ]; then
		directories+=' ./lib64'
	fi
	
	echo "- Packaging sysroot from '${sysroot}' to '${tarball}'"
	
	tar --directory="${sysroot}" --create --file=- ${directories} |  xz --quiet --threads=0 --compress -9 > "${tarball}"
done
