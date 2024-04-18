//
//  Punkte.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 03.04.24.
//

import SwiftUI
import EffectsLibrary

struct bcPunkte: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .padding()
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }
}

struct Punkte: View {
    @AppStorage("PunkteSammeln") var punkteSammeln = true
    @AppStorage("punkte", store: UserDefaults(suiteName: "group.PunkteMatheQuizPro")) var punkte = 1
    
    var body: some View {
        GeometryReader { geo in
            if geo.size.width > geo.size.height {
                RotateDevice(verticalDrehen: true)
            } else {
                VStack {
                    ZStack {
                        bcPunkte()
                        VStack {
                            HStack {
                                Text("Rang")
                                    .padding(.leading, 30)
                                    .padding(.top, 30)
                                    .font(.title3)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                Image(systemName: "figure.strengthtraining.functional")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.green)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 5)
                                    .foregroundColor(punkte >= 10 ? .cyan : .gray)
                                Image(systemName: "figure.walk")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(punkte >= 10 ? .cyan : .gray)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 5)
                                    .foregroundColor(punkte >= 50 ? .indigo : .gray)
                                Image(systemName: "figure.walk.motion")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(punkte >= 50 ? .indigo : .gray)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 5)
                                    .foregroundColor(punkte >= 100 ? .blue : .gray)
                                Image(systemName: "figure.highintensity.intervaltraining")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(punkte >= 100 ? .blue : .gray)
                                Spacer()
                                Spacer()
                                    .frame(width: 25)
                            }
                            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? geo.size.height / 7 - 80 : geo.size.height / 21)
                            Spacer()
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                Text("Junior \nMathematiker")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.green)
                                Spacer()
                                Text("Fortgeschrittener \nMathematiker")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(punkte >= 10 ? .cyan : .gray)
                                Spacer()
                                Text("Schneller \nMathematiker")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(punkte >= 50 ? .indigo : .gray)
                                Spacer()
                                Text("Senior \nMathematiker")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(punkte >= 100 ? .blue : .gray)
                                Spacer()
                                    .frame(width: 30)
                            }
                            .font(.caption)
                            Spacer()
                        }
                    }
                    .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? geo.size.height / 4 : geo.size.height / 3.5)
                    Spacer()
                        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10)
                    ZStack {
                        bcPunkte()
                        VStack {
                            ZStack {
                                if punkte >= 100 {
                                    FireworksView()
                                }
                                Circle()
                                    .stroke(
                                        Color.pink.opacity(0.5),
                                        lineWidth: 30
                                    )
                                Circle()
                                    .trim(from: 0, to: CGFloat(punkte) * 0.01)
                                    .stroke(
                                        Color.pink,
                                        // 1
                                        style: StrokeStyle(
                                            lineWidth: 30,
                                            lineCap: .round
                                        )
                                    )
                                    .rotationEffect(.degrees(-90))
                                if punkte < 100 {
                                    Text("Noch \(100 - punkte) Punkte bis zum \nSenior Mathematiker")
                                        .multilineTextAlignment(.center)
                                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .title2)
                                } else {
                                    FireworksView()
                                    Text("Tolle Leistung! Du hast viel gelernt!")
                                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .title2)
                                    
                                }
                            }
                            .padding(45)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Punkte()
}
