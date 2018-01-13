#!/usr/bin/env bash
set -e;

__error() {
	RED='\033[0;31m';
	NC='\033[0m';
	DT=$(date '+%F %T');
	(>&2 echo -e "${YELLOW}[$DT]\t$(basename $0)\t${1:-"UNKNOWN ERROR"}${NC}");
	exit 1;
}

for i in "$@"; do
	case $i in
		-h=*|--hex=*)
			opt_hex="${i#*=}";
			shift # past argument=value
		;;
		*)
			(>&2 echo "Invalid argument: ${i}");
			exit 1;
		;;
	esac
done

[[ -z "${opt_hex// }" ]] && (>&2 echo "missing file to flash") && exit 1;
[[ ! -f "${opt_hex}" ]] && (>&2 echo "hex file (${opt_hex}) does not exist.") && exit 1;


PULL_REPOSITORY="${DOCKER_REGISTRY:-"docker.artifactory.bit13.local"}";


uart=$(docker run -d \
	--user 0 \
	-v /dev/ttyACM0:/tmp/simavr-uart0 \
	-t "${PULL_REPOSITORY}/camalot/mega2560simulator");

sleep 5s;

if [[ ! -e /dev/ttyACM0 ]]; then
	YELLOW='\033[0;33m';
	NC='\033[0m';
	DT=$(date '+%F %T');
	(>&2 echo -e "${YELLOW}[$DT]\t$(basename $0)\tDevice /dev/ttyACM0 not found. Skipping avrdude tests.${NC}");
	exit 255;
fi


avrdude -p m2560 -c arduino -P /dev/ttyACM0 -C /usr/local/etc/avrdude.conf -D -U "flash:w:${opt_hex}:i"
# avrdude -p m2560 -c avrispmkII -P /dev/ttyACM0 -C /usr/local/etc/avrdude.conf -D -U flash:v:${opt_hex}:i

marlin_data=$(python /bin/marlin-identify.py -d '/dev/ttyACM0' -s 250000);

[[ ! $marlin_data =~ echo:Marlin ]] && __error "Unable to located Marlin version";
[[ ! $marlin_data =~ FIRMWARE_NAME:Marlin ]] && __error "Unable to located Marlin FIRMWARE_NAME";


docker kill "$uart" && docker rm "$uart";
