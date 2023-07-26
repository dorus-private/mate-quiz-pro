//
//  KeyPad.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import Foundation
import SwiftUI

struct KeyPadButton: View {
    var key: String
    @AppStorage("device") var device = ""
    
    var body: some View {
        if device == "IPhone" {
            if key == "" {
                Color.clear
                    .frame(width: 40, height: 40)
            } else {
                Button(action: { self.action(self.key) }) {
                    Color.blue
                        .cornerRadius(10)
                        .overlay(Text(key).foregroundColor(.white))
                }
                .shadow(radius: 1)
                .frame(width: 40, height: 40)
            }
        }  else {
            if key == "" {
                Color.clear
                    .frame(width: 100, height: 100)
            } else {
                Button(action: { self.action(self.key) }) {
                    Color.blue
                        .cornerRadius(10)
                        .overlay(Text(key).foregroundColor(.white).font(.largeTitle))
                }
                .frame(width: 100, height: 100)
                .shadow(radius: 3)
            }
        }
    }

    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }

    @Environment(\.keyPadButtonAction) var action: (String) -> Void
}

extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get { self[KeyPadButton.ActionKey.self] }
        set { self[KeyPadButton.ActionKey.self] = newValue }
    }
}

#if DEBUG
struct KeyPadButton_Previews: PreviewProvider {
    static var previews: some View {
        KeyPadButton(key: "8")
            .padding()
            .frame(width: 80, height: 80)
            .previewLayout(.sizeThatFits)
    }
}
#endif

struct KeyPadRow: View {
    var keys: [String]

    var body: some View {
        HStack {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
            }
        }
    }
}

struct KeyPad: View {
    @Binding var string: String
    @AppStorage("device") var device = ""
    
    var body: some View {
        ZStack {
            if device == "IPhone" {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.cyan)
                    .frame(width: 150, height: 195)
                    .shadow(radius: 10)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.cyan)
                    .frame(width: 350, height: 450)
                    .shadow(radius: 10)
            }
            VStack {
                KeyPadRow(keys: ["1", "2", "3"])
                KeyPadRow(keys: ["4", "5", "6"])
                KeyPadRow(keys: ["7", "8", "9"])
                KeyPadRow(keys: ["", "0", "⌫"])
            }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
        }
    }

    private func keyWasPressed(_ key: String) {
        switch key {
        case "." where string.contains("."): break
        case "." where string == "0": string += key
        case "⌫":
            string.removeLast()
            if string.isEmpty { string = "0" }
        case _ where string == "0": string = key
        default: string += key
        }
    }
}
