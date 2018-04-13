//
//  BeaconBroadcaster.swift
//  beacontool
//
//  Created by Suolapeikko on 24/11/17.
//  Copyright © 2017 Suolapeikko. All rights reserved.
//

import Foundation
import CoreBluetooth

class BeaconBroadcaster: NSObject, CBPeripheralManagerDelegate {
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    var data: Beacon!

    /// Starting with fixed iBeacon data
    override init() {
        
        super.init()
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        data = Beacon(uuid: UUID().uuidString, major: 65535, minor: 1, power: -58)
    }

    /// Starting with attributed iBeacon data
    init(uuid: String, major: Int, minor: Int, power: Int) {
        
        super.init()
        
        // Define serial dispatch queue
        let beaconQueue:DispatchQueue = DispatchQueue(label: "com.suolapeikko.broadcastqueue", attributes: [])
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: beaconQueue, options: nil)
        data = Beacon(uuid: uuid, major: major, minor: minor, power: power)
    }

    /// Broadcastsing iBeacon as bluetooth advertisement
    func startBroadcasting() {
        
        print("Broadcasting: UUID=\(data.uuid.uuidString), major=\(data.major), minor=\(data.minor), power=\(data.power)")
        bluetoothPeripheralManager.startAdvertising((data.beaconBroadcastAdvertisement() as! [String : AnyObject]))
    }
    
    /// Reacting to bluetooth peripheral manager's state change
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if(!(bluetoothPeripheralManager.state.rawValue == CBPeripheralManagerState.poweredOn.rawValue)) {
            print("In order to user this tool, Bluetooth must be switched on\n")
            exit(EXIT_FAILURE)
        }
    }
}
