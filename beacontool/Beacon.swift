//
//  Beacon.swift
//  beacontool
//
//  Created by Suolapeikko on 24/11/17.
//  Copyright © 2019 Suolapeikko. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Beacon {
    
    // iBeacon attributes for broadcasting
    var beaconKey = "kCBAdvDataAppleBeaconKey";
    var uuid: NSUUID!
    var major: UInt16!
    var minor: UInt16!
    var power: Int8!
    
    // iBeacon attributes for scanning
    var peripheral: CBPeripheral!
    var advertisementData: NSDictionary!
    var RSSI: NSNumber!
    
    /// Custom iBeacon initialization for scanning
    init(peripheral: CBPeripheral, advertisementData: NSDictionary, RSSI: NSNumber) {
        
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.RSSI = RSSI
    }
    
    /// Custom iBeacon initialization for broadcasting
    init(uuid: String, major: Int, minor: Int, power: Int) {
        
        self.uuid = NSUUID.init(uuidString: uuid)!
        self.major = UInt16(major)
        self.minor = UInt16(minor)
        self.power = Int8(power)
    }
    
    /// Broadcast advertisement data
    func beaconBroadcastAdvertisement() -> NSDictionary? {
        
        let bufferSize = 21
        let beaconKey: NSString = "kCBAdvDataAppleBeaconKey";
        
        var advertisementBytes = [CUnsignedChar](repeating: 0, count: bufferSize)
        
        uuid.getBytes(&advertisementBytes)
        
        advertisementBytes[16] = CUnsignedChar(major >> 8)
        advertisementBytes[17] = CUnsignedChar(major & 255)
        
        advertisementBytes[18] = CUnsignedChar(minor >> 8)
        advertisementBytes[19] = CUnsignedChar(minor & 255)
        
        advertisementBytes[20] = CUnsignedChar(bitPattern: power)
        
        let advertisement = Data(bytes: Array<UInt8>(advertisementBytes), count: bufferSize)
        
        return NSDictionary(object: advertisement, forKey: beaconKey)
    }

    /// Check supplied bluetooth advertisement data and print it out if it's type is iBeacon
    func checkAdvertisementDataForPossibleiBeaconData() {
        
        let beaconStandard: [CUnsignedChar] = [0x4c, 0x00, 0x02, 0x15]
        var data = advertisementData.value(forKey: "kCBAdvDataManufacturerData")

        if(data != nil) {

            data = data as! Data
            var beaconStandardBytes = [CUnsignedChar](repeating: 0, count: 4)
            (data! as AnyObject).getBytes(&beaconStandardBytes, range: NSMakeRange(0,4))

            if((data! as AnyObject).length >= 25 && beaconStandardBytes.elementsEqual(beaconStandard)) {
                
                var uuidBytes = [CUnsignedChar](repeating: 0, count: 16)
                (data! as AnyObject).getBytes(&uuidBytes, range: NSMakeRange(4, 16))
                let uuid = NSUUID.init(uuidBytes: uuidBytes) as UUID
                
                var majorBytes = ushort()
                (data! as AnyObject).getBytes(&majorBytes, range: NSMakeRange(20,2))
                let major = NSSwapShort(majorBytes)

                var minorBytes = ushort()
                (data! as AnyObject).getBytes(&minorBytes, range: NSMakeRange(22,2))
                let minor = NSSwapShort(minorBytes)

                var powerBytes = Int8()
                (data! as AnyObject).getBytes(&powerBytes, range: NSMakeRange(24,1))
                let power = powerBytes
                
                let distance = calculateBeaconDistance(Int(power), RSSI: Int(truncating: RSSI))
                print("UUID=\(uuid.uuidString), major=\(major), minor=\(minor), power=\(power), RSSI=\(String(describing: RSSI)), Distance=\(String(format: "%.2f", distance))m")
            }
        }
    }
    
    /// Beacon distance calculator for approximate distance
    func calculateBeaconDistance(_ power: Int, RSSI: Int) -> Double {
        
        let ratio = Double(RSSI) * 1.0 / Double(power)

        if (ratio < 1.0) {
            return pow(ratio, 10.0)
        }
        else {
            let accuracy =  (0.89976) * pow(ratio, 7.7095) + 0.111
            return round(10*accuracy) / 10
        }
    }
}
