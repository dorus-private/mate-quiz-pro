//
//  AufgabenanzahlEinstellen.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 17.09.24.
//

import SwiftUI

struct AufgabenanzahlEinstellen: View {
    @Binding var gesammtAufgaben: Int
    
    var body: some View {
        VStack {
            Text("Aufgaben Anzahl einstellen")
                .font(.title)
                .padding(20)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        if gesammtAufgaben != 5 {
                            gesammtAufgaben -= 1
                        }
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(gesammtAufgaben == 5 ? .gray : .red)
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 35, height: 7.5)
                            .foregroundColor(.white)
                    }
                })
                if #available(iOS 16.0, *) {
                    Text("\(gesammtAufgaben)")
                        .font(.title2)
                        .padding(15)
                        .contentTransition(.numericText())
                } else {
                    Text("\(gesammtAufgaben)")
                        .font(.title2)
                        .padding(15)
                }
                Button(action: {
                    withAnimation {
                        gesammtAufgaben += 1
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 35, height: 7.5)
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 7.5, height: 35)
                            .foregroundColor(.white)
                    }
                })
                Spacer()
            }
            Spacer()
        }
    }
}
