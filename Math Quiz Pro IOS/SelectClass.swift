//
//  Select class.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 06.09.24.
//

import SwiftUI

struct SelectClass: View {
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @Binding var selectedClass: String
    
    var body: some View {
        VStack {
            Text("Bitte wählen Sie eine Klasse aus, aus der zufällige Schüler in der Besprechungsrunde erscheinen werden")
                .multilineTextAlignment(.center)
                .padding(20)
            HStack {
                Spacer()
                    .frame(width: 20)
                List(klassenListe, id: \.self) { klasse in
                    HStack {
                        Text(klasse)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                if selectedClass == klasse {
                                    selectedClass = ""
                                } else {
                                    selectedClass = klasse
                                }
                            }
                        }, label: {
                            if selectedClass != klasse {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .frame(width: 20, height: 20)
                            }
                        })
                    }
                }
                .cornerRadius(15)
                Spacer()
                    .frame(width: 20)
            }
        }
    }
}
