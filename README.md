# BluetoothConnection App
**BluetoothConnection** is a SwiftUI app that scans for, connects to, and interacts with Bluetooth Low Energy (BLE) devices using Apple's CoreBluetooth framework.
### Features
* Scan for nearby Bluetooth devices.
* Display discovered devices.
* Connect to selected devices.
### Requirements
* iOS 13.0+ (must use a physical device, as Bluetooth doesn’t work in the simulator).
* Xcode 12.0+.
### Setup
1. Clone the repository
   ```
   git clone https://github.com/yourusername/BluetoothConnection.git
   open BluetoothConnection.xcodeproj
   ```

2. Run the app on a physical device to enable Bluetooth functionality.

### Code Overview
* > BluetoothManager.swift
   Manages Bluetooth operations.
* > ContentView.swift
  Displays the list of devices, services, and characteristics.
