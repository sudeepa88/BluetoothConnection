//
//  BluetoothManager.swift
//  BluetoothConnection
//
//  Created by Sudeepa Pal on 26/09/24.
//



import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var connectedPeripheral: CBPeripheral?
    @Published var discoveredServices = [CBService]()
    @Published var discoveredCharacteristics = [CBCharacteristic]()

    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // CBCentral manger

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBluetoothEnabled = true
            centralManager.scanForPeripherals(withServices: nil, options: nil) // Scan for all services
        } else {
            isBluetoothEnabled = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }

   
    
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        centralManager.stopScan()
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil) // Connect to the peripheral
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        connectedPeripheral = peripheral
        peripheral.discoverServices(nil) // Discover all services
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        connectedPeripheral = nil
        discoveredServices.removeAll()
        discoveredCharacteristics.removeAll()
    }

    // Peripheral connection 

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            discoveredServices = services
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service) // Discover all characteristics for each service
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            discoveredCharacteristics.append(contentsOf: characteristics)
        }
    }

    // Example function to read a value from a characteristic
    func readValue(for characteristic: CBCharacteristic) {
        connectedPeripheral?.readValue(for: characteristic)
    }

    // Example function to write a value to a characteristic
    func writeValue(data: Data, for characteristic: CBCharacteristic) {
        connectedPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }

    func toggleBluetooth() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
            centralManager = nil
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
}

