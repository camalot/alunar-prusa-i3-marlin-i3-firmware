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

[[ -z "${opt_ino_file}" ]] && (>&2 echo "Missing --ino-file param") && exit 1;
[[ -z "${opt_ino_path}" ]] && (>&2 echo "Missing --ino-file param") && exit 1;
[[ -z "${opt_board}" ]] && (>&2 echo "Missing --board param") && exit 1;

INO_PATH="${opt_ino_path}";
INO_FILE="${opt_ino_file}";
BOARD_ID="${opt_board}";
dt=$(date '+%F %T');

mkdir -p "${WORKSPACE}/build";
mkdir -p "${WORKSPACE}/dist";

echo "#define USE_JENKINS_VERSIONING" >> "${WORKSPACE}/${INO_PATH}/Configuration_Alunar.h";
sed -i 's|{{CI_BUILD_VERSION}}|${CI_BUILD_VERSION}|g' "${WORKSPACE}/${INO_PATH}/Configuration_Alunar.h"
sed -i 's|{{CI_BUILD_DATE}}|${dt}|g' "${WORKSPACE}/${INO_PATH}/Configuration_Alunar.h"

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
	"${WORKSPACE}/${INO_PATH}/${INO_FILE}";
	
mv ${WORKSPACE}/build/${INO_FILE}.hex ${WORKSPACE}/dist/${CI_PROJECT_NAME}-${CI_BUILD_VERSION}.hex
mv ${WORKSPACE}/build/${INO_FILE}.with_bootloader.hex ${WORKSPACE}/dist/${CI_PROJECT_NAME}-${CI_BUILD_VERSION}-with_bootloader.hex
