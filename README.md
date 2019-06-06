# beacontool

A command line utility for macOS that can either broadcast iBeacon signal or scan for iBeacons.

## Usage

         Usage:
         beacontool -b                           Broadcast iBeacon signal with generated uuid, major, minor and power values
         beacontool -b <uid> <n> <n> <n>         Broadcast iBeacon signal with custom uuid, major, mimor and power values
         beacontool -s <n>                       Scan for any iBeacon signals in <n> second intervals
         beacontool -g

## Examples

Scan in 2 second intervals: ` $ ./beacontool -s 2`

Generate UUID value: `$ ./beacontool -g`

Broadcast with generated values: `./beacontool -b`

Broadcast with custom values: `./beacontool -b 9995FD81-3988-43CD-896A-E545F9273802 65535 1 -58`
