//
//  ContentView.swift
//  BluetoothConnection
//
//  Created by Sudeepa Pal on 26/09/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager() // Bluetooth manager instance

    var body: some View {
        VStack {
            // Bluetooth Toggle Button
            Button(action: {
                print("This Function is getting called")
                bluetoothManager.toggleBluetooth()
            }) {
                Label(bluetoothManager.isBluetoothEnabled ? "Turn Off Bluetooth" : "Turn On Bluetooth", systemImage: bluetoothManager.isBluetoothEnabled ? "wifi.slash" : "wifi")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(bluetoothManager.isBluetoothEnabled ? Color.red : Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }

            Text("Bluetooth is \(bluetoothManager.isBluetoothEnabled ? "enabled" : "disabled")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)

            Divider()

            
            Text("Discovered Peripherals")
                .font(.headline)
                .padding(.top, 10)

            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                HStack {
                    Text(peripheral.name ?? "Unknown")
                        .font(.body)
                    Spacer()
                    Button(action: {
                        print("Connected with bluetooth peripheral")
                        bluetoothManager.connectToPeripheral(peripheral)
                    }) {
                        Label("Connect", systemImage: "link")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())

            Divider()

            if let connectedPeripheral = bluetoothManager.connectedPeripheral {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Connected to \(connectedPeripheral.name ?? "Unknown")")
                        .font(.headline)
                        .padding(.top, 10)

                    List {
                        ForEach(bluetoothManager.discoveredServices, id: \.uuid) { service in
                            Section(header: Text("Service: \(service.uuid)")
                                .font(.subheadline)
                                .foregroundColor(.primary)) {
                                ForEach(bluetoothManager.discoveredCharacteristics.filter { $0.service == service }, id: \.uuid) { characteristic in
                                    Text("Characteristic: \(characteristic.uuid)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
