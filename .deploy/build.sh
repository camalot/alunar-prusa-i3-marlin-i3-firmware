#!/usr/bin/env bash
set -e;
mkdir -p ${WORKSPACE}/dist;
# temp full path

arduino-builder \
	--compile \
	-verbose \
	-warnings more \
	-hardware /arduino/hardware \
	-tools /arduino/hardware/tools \
	-tools /arduino/tools-builder \
	-libraries /arduino/libraries \
	-fqbn ${BOARD_ID} \
	-build-path '${WORKSPACE}/dist' \
	'${INO_PATH}';

pushd .;
zip --verbose ${CI_PROJECT_NAME}-${CI_BUILD_VERSION}.zip -xi ./*.hex
ls -lFa ${WORKSPACE}/dist;
popd;
