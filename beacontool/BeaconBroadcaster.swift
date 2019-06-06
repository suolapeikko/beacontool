//
//  BeaconBroadcaster.swift
//  beacontool
//
//  Created by Suolapeikko on 24/11/17.
//  Copyright © 2019 Suolapeikko. All rights reserved.
//

import Foundation
import CoreBluetooth

class BeaconBroadcaster: NSObject, CBPeripheralManagerDelegate {
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    var data: Beacon!

    /// Starting with fixed iBeacon data
    override init() {
        
        super.init()
        
        // Define serial dispatch queue
        let beaconQueue:DispatchQueue = DispatchQueue(label: "com.suolapeikko.broadcastqueue", attributes: [])

        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: beaconQueue, options: nil)
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

    /// Broadcastsing iBeacon as Bluetooth advertisement
    func startBroadcasting() {
        
        print("Broadcasting: UUID=\(data.uuid.uuidString), major=\(String(describing: data.major)), minor=\(String(describing: data.minor)), power=\(String(describing: data.power))")
        bluetoothPeripheralManager.startAdvertising((data.beaconBroadcastAdvertisement() as! [String : AnyObject]))
    }
    
    /// Reacting to Bluetooth peripheral manager's state change
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if(!(bluetoothPeripheralManager.state.rawValue == CBManagerState.poweredOn.rawValue)) {
            print("In order to user this tool, Bluetooth must be switched on\n")
            exit(EXIT_FAILURE)
        }
    }
}
