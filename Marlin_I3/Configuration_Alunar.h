#define CONFIG_H_ALUNAR

#define STRING_CONFIG_H_AUTHOR "@camalot (Ryan Conrad)" // Who made the changes.
#define SHOW_BOOTSCREEN
#define STRING_SPLASH_LINE1 DETAILED_BUILD_VERSION // will be shown during bootup in line 1
#define STRING_SPLASH_LINE2 WEBSITE_URL         // will be shown during bootup in line 2

/**
   * Verbose version identifier which should contain a reference to the location
   * from where the binary was downloaded or the source code was compiled.
   */
#if ENABLED(USE_JENKINS_VERSIONING)
	#define DETAILED_BUILD_VERSION "[M" SHORT_BUILD_VERSION "] [{{CI_BUILD_VERSION}}]"
	// #define STRING_DISTRIBUTION_DATE "{{CI_BUILD_DATE}}"
#else
	#define DETAILED_BUILD_VERSION SHORT_BUILD_VERSION
	#define STRING_DISTRIBUTION_DATE "2017-12-25 12:00"
#endif

// Optional custom name for your RepStrap or other custom machine
// Displayed in the LCD "Ready" message
#define CUSTOM_MACHINE_NAME "3D Printer"
#define MACHINE_NAME "3D Printer"
#define SOURCE_CODE_URL "https://github.com/camalot/alunar-prusa-i3-marlin-i3-firmware"

// Define this to set a unique identifier for this printer, (Used by some programs to differentiate between machines)
// You can use an online service to generate a random UUID. (eg http://www.uuidgenerator.net/version4)
#define MACHINE_UUID "21a92960-ce8e-4db3-8763-db376e2097aa"

#define WEBSITE_URL "http://fuku.io"


// This defines the number of extruders
#define EXTRUDERS 1
//// The following define selects which power supply you have. Please choose the one that matches your setup
// 1 = ATX
// 2 = X-Box 360 203Watts (the blue wire connected to PS_ON and the red wire to VCC)

#define POWER_SUPPLY 1

/**
 * --NORMAL IS 4.7kohm PULLUP!-- 1kohm pullup can be used on hotend sensor, using correct resistor and table
 *
 * Temperature sensors available:
 *
 *    -3 : thermocouple with MAX31855 (only for sensor 0)
 *    -2 : thermocouple with MAX6675 (only for sensor 0)
 *    -1 : thermocouple with AD595
 *     0 : not used
 *     1 : 100k thermistor - best choice for EPCOS 100k (4.7k pullup)
 *     2 : 200k thermistor - ATC Semitec 204GT-2 (4.7k pullup)
 *     3 : Mendel-parts thermistor (4.7k pullup)
 *     4 : 10k thermistor !! do not use it for a hotend. It gives bad resolution at high temp. !!
 *     5 : 100K thermistor - ATC Semitec 104GT-2 (Used in ParCan & J-Head) (4.7k pullup)
 *     6 : 100k EPCOS - Not as accurate as table 1 (created using a fluke thermocouple) (4.7k pullup)
 *     7 : 100k Honeywell thermistor 135-104LAG-J01 (4.7k pullup)
 *    71 : 100k Honeywell thermistor 135-104LAF-J01 (4.7k pullup)
 *     8 : 100k 0603 SMD Vishay NTCS0603E3104FXT (4.7k pullup)
 *     9 : 100k GE Sensing AL03006-58.2K-97-G1 (4.7k pullup)
 *    10 : 100k RS thermistor 198-961 (4.7k pullup)
 *    11 : 100k beta 3950 1% thermistor (4.7k pullup)
 *    12 : 100k 0603 SMD Vishay NTCS0603E3104FXT (4.7k pullup) (calibrated for Makibox hot bed)
 *    13 : 100k Hisens 3950  1% up to 300°C for hotend "Simple ONE " & "Hotend "All In ONE"
 *    20 : the PT100 circuit found in the Ultimainboard V2.x
 *    60 : 100k Maker's Tool Works Kapton Bed Thermistor beta=3950
 *    66 : 4.7M High Temperature thermistor from Dyze Design
 *    70 : the 100K thermistor found in the bq Hephestos 2
 *
 *       1k ohm pullup tables - This is atypical, and requires changing out the 4.7k pullup for 1k.
 *                              (but gives greater accuracy and more stable PID)
 *    51 : 100k thermistor - EPCOS (1k pullup)
 *    52 : 200k thermistor - ATC Semitec 204GT-2 (1k pullup)
 *    55 : 100k thermistor - ATC Semitec 104GT-2 (Used in ParCan & J-Head) (1k pullup)
 *
 *  1047 : Pt1000 with 4k7 pullup
 *  1010 : Pt1000 with 1k pullup (non standard)
 *   147 : Pt100 with 4k7 pullup
 *   110 : Pt100 with 1k pullup (non standard)
 *
 *         Use these for Testing or Development purposes. NEVER for production machine.
 *   998 : Dummy Table that ALWAYS reads 25°C or the temperature defined below.
 *   999 : Dummy Table that ALWAYS reads 100°C or the temperature defined below.
 *
 * :{ '0': "Not used", '1':"100k / 4.7k - EPCOS", '2':"200k / 4.7k - ATC Semitec 204GT-2", '3':"Mendel-parts / 4.7k", '4':"10k !! do not use for a hotend. Bad resolution at high temp. !!", '5':"100K / 4.7k - ATC Semitec 104GT-2 (Used in ParCan & J-Head)", '6':"100k / 4.7k EPCOS - Not as accurate as Table 1", '7':"100k / 4.7k Honeywell 135-104LAG-J01", '8':"100k / 4.7k 0603 SMD Vishay NTCS0603E3104FXT", '9':"100k / 4.7k GE Sensing AL03006-58.2K-97-G1", '10':"100k / 4.7k RS 198-961", '11':"100k / 4.7k beta 3950 1%", '12':"100k / 4.7k 0603 SMD Vishay NTCS0603E3104FXT (calibrated for Makibox hot bed)", '13':"100k Hisens 3950  1% up to 300°C for hotend 'Simple ONE ' & hotend 'All In ONE'", '20':"PT100 (Ultimainboard V2.x)", '51':"100k / 1k - EPCOS", '52':"200k / 1k - ATC Semitec 204GT-2", '55':"100k / 1k - ATC Semitec 104GT-2 (Used in ParCan & J-Head)", '60':"100k Maker's Tool Works Kapton Bed Thermistor beta=3950", '66':"Dyze Design 4.7M High Temperature thermistor", '70':"the 100K thermistor found in the bq Hephestos 2", '71':"100k / 4.7k Honeywell 135-104LAF-J01", '147':"Pt100 / 4.7k", '1047':"Pt1000 / 4.7k", '110':"Pt100 / 1k (non-standard)", '1010':"Pt1000 / 1k (non standard)", '-3':"Thermocouple + MAX31855 (only for sensor 0)", '-2':"Thermocouple + MAX6675 (only for sensor 0)", '-1':"Thermocouple + AD595",'998':"Dummy 1", '999':"Dummy 2" }
 */
#define TEMP_SENSOR_0 1
#define TEMP_SENSOR_1 0
#define TEMP_SENSOR_2 0
#define TEMP_SENSOR_3 0
#define TEMP_SENSOR_BED 1

#define PIDTEMP
#if ENABLED(PIDTEMP)
	#define  DEFAULT_Kp 18.5
	#define  DEFAULT_Ki 0.92
	#define  DEFAULT_Kd 92.84
#endif // PIDTEMP

//#define PIDTEMPBED
#if ENABLED(PIDTEMPBED)

	#define  DEFAULT_bedKp 79.90
	#define  DEFAULT_bedKi 14.10
	#define  DEFAULT_bedKd 109.41

	// FIND YOUR OWN: "M303 E-1 C8 S90" to run autotune on the bed at 90 degreesC for 8 cycles.

#endif // PIDTEMPBED

// The minimal temperature defines the temperature below which the heater will not be enabled It is used
// to check that the wiring to the thermistor is not broken.
// Otherwise this would lead to the heater being powered on all the time.
#define HEATER_0_MINTEMP 5
#define HEATER_1_MINTEMP 5
#define HEATER_2_MINTEMP 5
#define BED_MINTEMP 5

// When temperature exceeds max temp, your heater will be switched off.
// This feature exists to protect your hotend from overheating accidentally, but *NOT* from thermistor short/failure!
// You should use MINTEMP for thermistor short/failure protection.
#define HEATER_0_MAXTEMP 240
#define HEATER_1_MAXTEMP 240
#define HEATER_2_MAXTEMP 240
#define BED_MAXTEMP 115


#define Z_HOMING_HEIGHT 4  // (in mm) Minimal z height before homing (G28) for Z clearance above the bed, clamps, ...
                             // Be sure you have this distance over your Z_MAX_POS in case.


// The center of the bed is at (X=0, Y=0)
//#define BED_CENTER_AT_0_0

// Manually set the home position. Leave these undefined for automatic settings.
// For DELTA this is the top-center of the Cartesian print volume.
//#define MANUAL_X_HOME_POS 145
//#define MANUAL_Y_HOME_POS 145
//#define MANUAL_Z_HOME_POS 0 // Distance between the nozzle to printbed after homing

// Use "Z Safe Homing" to avoid homing with a Z probe outside the bed area.
//
// With this feature enabled:
//
// - Allow Z homing only after X and Y homing AND stepper drivers still enabled.
// - If stepper drivers time out, it will need X and Y homing again before Z homing.
// - Move the Z probe (or nozzle) to a defined XY point before Z Homing when homing all axes (G28).
// - Prevent Z homing when the Z probe is outside bed area.

#define X_MAX_POS 220
#define X_MIN_POS 0
#define Y_MAX_POS 220
#define Y_MIN_POS 0
#define Z_MAX_POS 185
#define Z_MIN_POS 0

#define X_MAX_LENGTH (X_MAX_POS - X_MIN_POS)
#define Y_MAX_LENGTH (Y_MAX_POS - Y_MIN_POS)
#define Z_MAX_LENGTH (Z_MAX_POS - Z_MIN_POS)




#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,400,92.6}  // default steps per unit
#define DEFAULT_MAX_FEEDRATE          {400, 400, 4, 25}    // (mm/sec)
#define DEFAULT_MAX_ACCELERATION      {9000,9000,20,10000}    // X, Y, Z, E maximum start speed for accelerated moves. E default values are good for skeinforge 40+, for older versions raise them a lot.
//
// #define DEFAULT_ACCELERATION          3000    // X, Y, Z and E max acceleration in mm/s^2 for printing moves
// #define DEFAULT_RETRACT_ACCELERATION  3000   // X, Y, Z and E max acceleration in mm/s^2 for retracts
// #define DEFAULT_TRAVEL_ACCELERATION   3000    // X, Y, Z acceleration in mm/s^2 for travel (non printing) moves


#define REPRAP_DISCOUNT_SMART_CONTROLLER


// Mechanical endstop with COM to ground and NC to Signal uses "false" here (most common setup).
#define X_MIN_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.
#define Y_MIN_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.
#define Z_MIN_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.
#define X_MAX_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.
#define Y_MAX_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.
#define Z_MAX_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.
#define Z_MIN_PROBE_ENDSTOP_INVERTING true  // set to true to invert the logic of the endstop.


#define Z_SAFE_HOMING

#if ENABLED(Z_SAFE_HOMING)
  #define Z_SAFE_HOMING_X_POINT ((X_MIN_POS + X_MAX_POS) / 2)    // X point for Z homing when homing all axis (G28).
  #define Z_SAFE_HOMING_Y_POINT ((Y_MIN_POS + Y_MAX_POS) / 2)    // Y point for Z homing when homing all axis (G28).

  // #define Z_SAFE_HOMING_X_POINT 145    // X point for Z homing when homing all axis (G28).
  // #define Z_SAFE_HOMING_Y_POINT 145    // Y point for Z homing when homing all axis (G28).

#endif
