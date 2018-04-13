# beacontool

A command line utility for macOS that can either broadcast iBeacon signal or scan for iBeacons.

## Usage
`$ ./beacontool 
beacontool: iBeacon command line utility

         Usage:
         beacontool -b                           Broadcast iBeacon signal with generated uuid, minor, major and power values
         beacontool -b <uid> <n> <n> <n>         Broadcast iBeacon signal with custom uuid, minor, major and power values
         beacontool -s <n>                       Scan for any iBeacon signals in <n> second intervals
         beacontool -g                           Generate UUID value
`
