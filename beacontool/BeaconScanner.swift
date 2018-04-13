//
//  BeaconScanner.swift
//  beacontool
//
//  Created by Suolapeikko on 24/11/17.
//  Copyright © 2017 Suolapeikko. All rights reserved.
//

import Foundation
import CoreBluetooth

class BeaconScanner: NSObject, CBCentralManagerDelegate {
    
    var cbManager: CBCentralManager!
    var timer: Timer!
    var type: BeaconType!
    
    init(type: BeaconType) {
        self.type = type
    }
    
    func scanWithInterval(_ interval: Int) {

        if(type == BeaconType.iBeacon) {
            print("Starting to scan for iBeacons using time interval of \(interval) seconds")
        }
        
        // Define serial dispatch queue
        let scanQueue:DispatchQueue = DispatchQueue(label: "com.suolapeikko.scannerqueue", attributes: [])
        
        // Initiate CBManager with dispatch queue
        cbManager = CBCentralManager(delegate: self, queue: scanQueue)
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(scan), userInfo: nil, repeats: true)
    }
    
    /// Scanning for bluetooth peripherals
    @objc func scan() {
        
        // Scan for Bluetooth peripherals
        if(cbManager != nil && cbManager.state.rawValue==CBCentralManagerState.poweredOn.rawValue) {
            cbManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /// Found one, so checking if it is iBeacon
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let data = Beacon(peripheral: peripheral, advertisementData: advertisementData as NSDictionary, RSSI: RSSI)
        data.checkAdvertisementDataForPossibleiBeaconData()
    }
    
    /// Reacting to bluetooth peripheral manager's state change
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if(!(central.state.rawValue == CBCentralManagerState.poweredOn.rawValue)) {
            print("In order to user this tool, Bluetooth must be switched on\n")
            exit(EXIT_FAILURE)
        }
    }
}
