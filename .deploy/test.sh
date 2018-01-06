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

avrdude -p m2560 -c avrispmkII -P /dev/ttyACM0 -C /usr/local/etc/avrdude.conf -D -U flash:w:${opt_hex}:i

# avrdude -p m2560 -c avrispmkII -P /dev/ttyACM0 -C /usr/local/etc/avrdude.conf -D -U flash:v:${opt_hex}:i
