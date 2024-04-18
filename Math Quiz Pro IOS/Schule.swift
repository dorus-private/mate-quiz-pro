//
//  Schule.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.12.23.
//

import SwiftUI
struct MiniGameView: View {
    var geo: GeometryProxy
    var image: String
    var text: String
    @AppStorage("rolle") var rolle = 1
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad  {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(rolle == 1 ? .white : .black)
                RoundedRectangle(cornerRadius: 10)
                    .padding(5)
                    .foregroundColor(.purple)
                VStack {
                    Spacer()
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                    Text(text)
                        .font(.caption2)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .padding(10)
                }
            }
            .frame(width: geo.size.width > geo.size.height ? geo.size.width / 8 : geo.size.width / 6, height: geo.size.width > geo.size.height ? geo.size.height / 5 : geo.size.height / 7)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(rolle == 1 ? .white : .black)
                RoundedRectangle(cornerRadius: 10)
                    .padding(5)
                    .foregroundColor(.purple)
                VStack {
                    Spacer()
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                    Text(text)
                        .font(.caption2)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .padding(10)
                }
            }
            .frame(width: geo.size.width / 4.5, height: geo.size.height / 7)
        }
    }
}

struct Schule: View {
    var geo: GeometryProxy
    @AppStorage("task") private var task = ""
    @AppStorage("rolle") var rolle = 1
    
    var body: some View {
        ScrollView {
            VStack {
                if (UIDevice.current.userInterfaceIdiom == .phone && geo.size.height > geo.size.width) || UIDevice.current.userInterfaceIdiom == .pad {
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        ScrollView(.horizontal) {
                            HStack {
                                NavigationLink(destination: {
                                    Kopfrechnen()
                                        .navigationTitle("Kopfrechnen")
                                }, label: {
                                    MiniGameView(geo: geo, image: "brain.head.profile.fill", text: "Kopfrechnen")
                                })
                                if UIDevice.current.userInterfaceIdiom == .pad && rolle == 1 {
                                    Spacer()
                                        .frame(width: 10)
                                    NavigationLink(destination: {
                                        Hausnummern()
                                            .navigationTitle("Hausnummern Spiel")
                                    }, label: {
                                        MiniGameView(geo: geo, image: "house.fill", text: "Hausnummern")
                                    })
                                }
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 15)
                }
                if geo.size.width > geo.size.height {
                    if UIDevice.current.userInterfaceIdiom == .pad  {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            NavigationLink(destination: {
                                K8()
                            }, label: {
                                KlasseNav(klasse: 8, übungen: "\n• Terme mit mehreren Variablen vereinfachen \n• Multiplizieren von Summen \n• Binomische Formeln \n• Terme nach Variablen auflösen")
                            })
                            Spacer()
                                .frame(width: 20)
                            NavigationLink(destination: {
                                K9()
                            }, label: {
                                KlasseNav(klasse: 9, übungen: "\n• Potenzen \n• Kongruenz & Ähnlichkeit \n• Potenzfunktionen \n• Exponentialfunktionen")
                            })
                            Spacer()
                                .frame(width: 20)
                        }
                    } else {
                        RotateDevice(verticalDrehen: false)
                    }
                } else {
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            NavigationLink(destination: {
                                K8()
                            }, label: {
                                KlasseNav(klasse: 8, übungen: "\n• Terme mit mehreren Variablen vereinfachen \n• Multiplizieren von Summen \n• Binomische Formeln \n• Terme nach Variablen auflösen")
                            })
                            Spacer()
                                .frame(width: 20)
                        }
                        Spacer()
                            .frame(height: 20)
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            NavigationLink(destination: {
                                K9()
                            }, label: {
                                KlasseNav(klasse: 9, übungen: "\n• Potenzen \n• Kongruenz & Ähnlichkeit \n• Potenzfunktionen \n• Exponentialfunktionen")
                            })
                            Spacer()
                                .frame(width: 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            task = ""
        }
    }
}
