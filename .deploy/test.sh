#!/usr/bin/env bash
set -e;

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
if [[ -e /dev/ttyACM0 ]]; then
	avrdude -p m2560 -c avrispmkII -P /dev/ttyACM0 -C /usr/local/etc/avrdude.conf -D -U flash:w:${opt_hex}:i
else 
	YELLOW='\033[0;33m';
	NC='\033[0m';
	DT=$(date '+%F %T');
	(>&2 printf "${YELLOW}[$DT]\t$(basename $0)\tDevice /dev/ttyACM0 not found. Skipping avrdude tests.${NC}");
fi
# avrdude -p m2560 -c avrispmkII -P /dev/ttyACM0 -C /usr/local/etc/avrdude.conf -D -U flash:v:${opt_hex}:i

# get baud rate
# speed=$(stty -F /dev/ttyACM0 speed);
# set baud
# stty -F /dev/ttyACM0 115200;

