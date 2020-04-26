//
//  main.swift
//  beacontool
//
//  Created by Suolapeikko on 23/11/17.
//  Copyright © 2019 Suolapeikko. All rights reserved.
//

import Foundation

let args = CommandLine.arguments
let argCount = CommandLine.arguments.count
var errorFlag = false

enum BeaconType {
    case iBeacon
}

// Check if there is incompatible number of arguments
if(!(argCount == 2 || argCount == 3 || argCount == 6)) {
    errorFlag = true
}

// Check if the main argument does not match
if(argCount == 2 && !(args[1] == "-b" || args[1] == "-g")) {
    errorFlag = true
}

// Check custom scan arguments
if(argCount == 3 && !(args[1] == "-s")) {
    errorFlag = true
}

// Check custom broadcast arguments
if(argCount == 6 && !(args[1] == "-b")) {
    errorFlag = true
}

if(errorFlag) {
    print("beacontool: iBeacon command line utility (Version 1.0)\n");
    print("   Usage:");
    print("   beacontool -b                           Broadcast iBeacon signal with generated uuid, major, minor and power values");
    print("   beacontool -b <uid> <n> <n> <n>         Broadcast iBeacon signal with custom uuid, major, minor and power values");
    print("   beacontool -s <n>                       Scan for any iBeacon signals in <n> second intervals");
    print("   beacontool -g                           Generate UUID value");
    exit(EXIT_FAILURE)
}

// Broadcast with generated values
if(argCount == 2 && args[1] == "-b") {
    let beacon = BeaconBroadcaster()
    beacon.startBroadcasting()
    RunLoop.current.run()
}

// Broadcast with specified values
if(argCount == 6 && args[1] == "-b")
{
    let uuid = args[2]
    let major:Int? = Int(args[3])
    let minor:Int? = Int(args[4])
    let power:Int? = Int(args[5])
    
    if(major==nil || minor==nil || power==nil) {
        print("Please provide numeric values for mandatory options minor, major and power")
        exit(EXIT_FAILURE)
    }
    
    let beacon = BeaconBroadcaster(uuid: uuid, major: major!, minor: minor!, power: power!)
    beacon.startBroadcasting()
    RunLoop.current.run()
}

// Scan for iBeacons
if(argCount == 3 && args[1] == "-s") {
    let scanner = BeaconScanner(type: BeaconType.iBeacon)

    let interval:Int? = Int(args[2])
    
    if(interval==nil) {
        print("Please provide numeric value for time interval (seconds)")
        exit(EXIT_FAILURE)
    }

    scanner.scanWithInterval(interval!)
    RunLoop.current.run()
}

// Generate UUIID
if(argCount == 2 && args[1] == "-g") {
    print(UUID().uuidString)
    exit(EXIT_SUCCESS)
}


