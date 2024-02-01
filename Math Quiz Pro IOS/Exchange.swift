//
//  Exchange.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 20.12.23.
//

import CoreBluetooth
import SwiftUI
import Foundation

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    @Published var receivedData: String = ""
    @Published var sendData: String = ""

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func start() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func sendData1() {
        guard let peripheral = peripheral,
              let data = sendData.data(using: .utf8),
              let characteristic = findCharacteristic() else {
            return
        }

        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }

    private func findCharacteristic() -> CBCharacteristic? {
        // TODO: Implement logic to find the characteristic
        return nil
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        centralManager.stopScan()
        self.peripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value, let receivedString = String(data: data, encoding: .utf8) {
            receivedData = receivedString
            NotificationCenter.default.post(name: Notification.Name("ReceivedDataNotification"), object: receivedString)
        }
    }
}




struct Exchange: View {
    @StateObject private var bluetoothManager = BluetoothManager()

        var body: some View {
            VStack {
                Text("Received Data: \(bluetoothManager.receivedData)")

                TextField("Enter Data to Send", text: $bluetoothManager.sendData)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send Data") {
                    bluetoothManager.sendData1()
                }
                .padding()
            }
            .onAppear {
                bluetoothManager.start()
            }
        }
}

#Preview {
    Exchange()
}
