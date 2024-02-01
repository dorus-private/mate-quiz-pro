//
//  Schule.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.12.23.
//

import SwiftUI

struct Schule: View {
    var geo: GeometryProxy
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 20)
                if geo.size.width > geo.size.height {
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
                            KlasseNav(klasse: 9, übungen: "\n• Potenzen mit ganzen Hochzahlen \n• Potenzen mit gleichen Grundzahlen \n• Potnezen mit gleichen Hochzahlen")
                        })
                        Spacer()
                            .frame(width: 20)
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
                                KlasseNav(klasse: 9, übungen: "\n• Potenzen mit ganzen Hochzahlen \n• Potenzen mit gleichen Grundzahlen \n• Potnezen mit gleichen Hochzahlen")
                            })
                            Spacer()
                                .frame(width: 20)
                        }
                    }
                }
            }
        }
    }
}
