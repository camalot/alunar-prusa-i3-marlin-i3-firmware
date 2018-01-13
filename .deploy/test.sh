#!/usr/bin/env bash
set -e;

__error() {
	RED='\033[0;31m';
	NC='\033[0m';
	DT=$(date '+%F %T');
	(>&2 echo -e "${RED}[$DT]\t$(basename $0)\t${1:-"UNKNOWN ERROR"}${NC}");
	exit 100;
}

__warning() {
	YELLOW='\033[0;33m';
	NC='\033[0m';
	DT=$(date '+%F %T');
	(>&2 echo -e "${YELLOW}[$DT]\t$(basename $0)\t${1:-"UNKNOWN ERROR"}${NC}");
}

kill_mega() {
	docker kill "$1" ||  docker rm "$1";
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

mkdir -p /tmp/simduino;

uart=$(docker run -d \
	--user 0 \
	-v /tmp/simduino:/dev/pts \
	"${PULL_REPOSITORY}/camalot/mega2560simulator:latest");
	# --device=/dev/ttyACM0:/dev/pts/0 \

sleep 5s;
wait_count=0;

echo "";
echo "Waiting for device to become ready.";
while [ $wait_count -lt 60 ]; do
	[ -e /tmp/simduino/0 ] && wait_count=99;
	sleep 1s;
	wait_count=$[$wait_count+1];
	echo -n '.';
done
echo "";

[ $wait_count -ne 99 ] && kill_mega "$uart" && __warning "Timeout exceeded waiting for device to become ready." && exit 255;

if [[ ! -L /tmp/simduino/0 ]]; then
	kill_mega "$uart";
	__warning "Device /tmp/simduino/0 not found. Skipping avrdude tests.";
	exit 255;
fi


avrdude -p m2560 -c arduino -P /tmp/simduino/0 -C /usr/local/etc/avrdude.conf -D -U "flash:w:${opt_hex}:i"
# avrdude -p m2560 -c avrispmkII -P /tmp/simduino/0 -C /usr/local/etc/avrdude.conf -D -U flash:v:${opt_hex}:i

marlin_data=$(python /bin/marlin-identify.py -d '/tmp/simduino/0' -s 250000);

[[ ! $marlin_data =~ echo:Marlin ]] && __error "Unable to located Marlin version";
[[ ! $marlin_data =~ FIRMWARE_NAME:Marlin ]] && __error "Unable to located Marlin FIRMWARE_NAME";

kill_mega "$uart";
