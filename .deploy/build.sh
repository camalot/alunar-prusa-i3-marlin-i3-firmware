#!/usr/bin/env bash
set -e;

for i in "$@"; do
	case $i in
		-if=*|--ino-file=*)
			opt_ino_file="${i#*=}";
			shift # past argument=value
		;;
		-ip=*|--ino-path=*)
			opt_ino_path="${i#*=}";
			shift # past argument=value
		;;
		-b=*|--board=*)
			opt_board="${i#*=}";
			shift # past argument=value
		;;
		*)
			(>&2 echo "Invalid argument: ${i}");
			exit 1;
		;;
	esac
done

mkdir -p "${WORKSPACE}/build";
mkdir -p "${WORKSPACE}/dist";

echo "#define USE_JENKINS_VERSIONING" >> "${WORKSPACE}/${opt_ino_path}/Configuration_Alunar.h";
sed -i 's|{{CI_BUILD_VERSION}}|${CI_BUILD_VERSION}|g' "${WORKSPACE}/${opt_ino_path}/Configuration_Alunar.h"

arduino-builder \
	--compile \
	-verbose \
	-warnings default \
	-hardware /arduino/hardware \
	-tools /arduino/hardware/tools \
	-tools /arduino/tools-builder \
	-libraries /arduino/libraries \
	-fqbn ${BOARD_ID} \
	-build-path "${WORKSPACE}/build" \
	"${WORKSPACE}/${opt_ino_path}/${opt_ino_file}";
mv ${WORKSPACE}/build/${opt_ino_file}.hex ${WORKSPACE}/dist/${CI_PROJECT_NAME}-${CI_BUILD_VERSION}.hex
mv ${WORKSPACE}/build/${opt_ino_file}.with_bootloader.hex ${WORKSPACE}/dist/${CI_PROJECT_NAME}-${CI_BUILD_VERSION}-with_bootloader.hex
