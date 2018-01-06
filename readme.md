# Alunar M508 Marlin Firmware

This is (usually) the latest [Marlin](https://github.com/MarlinFirmware/Marlin) firmware tweaked and tailored for the Alunar M508 3D Printer. The settings are what work for my machine, with my setup, it may not be perfect for you.

### Flash Firmware From Binaries

1. Download the [latest binary release](https://github.com/camalot/alunar-prusa-i3-marlin-i3-firmware/releases/latest).
1. Extract the zip file
1. Download Arduino IDE (if you haven't already)
	- You could also get binaries for [avrdude](http://www.nongnu.org/avrdude/).
1. Open console window to avrdude binary directory. 
	- Windows: `c:\Program Files(x86)\Arduino\hardware\tools\avr\bin
	- Linux/macOS: `/<arduino-dir>/hardware/tools/avr/bin`
1. Run the following command:
```
$ avrdude -p m2560 -c avrispmkII -P /dev/ttyACM0 -C /<arduino-dir>/hardware/tools/avr/etc/avrdude.conf -D -U flash:w:/PATH/TO/FIRMWARE.HEX:i
```
`/dev/ttyACM0` may not be the port that the device is connected to on your machine. On a Windows machine, this value will be something like `COM4`

### Flash Firmware From Source

1. Download Arduino IDE (if you haven't already)
1. Clone / Download this repository
1. Connect USB from Mainboard to PC
1. Open Arduino
1. Open `Marlin/Marlin.ino`
1. Set board under `Tools` menu to `Arduino Mega 2560 or Mega ADK`
1. Choose USB serial port
1. Upload firmware to board `File -> Upload (CTRL+U)`

![](https://github.com/camalot/alunar-prusa-i3-marlin-i3-firmware/raw/develop/assets/finish-A.jpg)
