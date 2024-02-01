//
//  TabBarOben.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.12.23.
//

import SwiftUI

struct TabBarOben: View {
    @AppStorage("isAirPlayActive") var isAirplayActive = false
    @State var airplayHeight: CGFloat = 25
    @State var versionView = false
    @State var einstellungen = false
    @State var melekIcon = false
    @State var showIcon = false
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            Button(action: {
                melekIcon = true
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 50, height: 50)
                    Image("MelekIcon")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 40, height: 40)
                }
            })
            if isAirplayActive {
                Spacer()
                    .frame(width: 10)
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                        .foregroundColor(.white)
                    HStack {
                        Text("AirPlay ist aktiviert")
                            .foregroundColor(.black)
                            .padding(20)
                        Spacer()
                        Image(systemName: "airplayvideo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: airplayHeight, height: airplayHeight)
                            .foregroundColor(.blue)
                            .padding(20)
                            .onAppear {
                                changeFrames()
                            }
                    }
                }
                Spacer()
                    .frame(width: 10)
            } else {
                Spacer()
            }
            Button(action: {
                versionView = true
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 50, height: 50)
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            })
            Spacer()
                .frame(width: 20)
        }
        .fullScreenCover(isPresented: $melekIcon) {
            GeometryReader { geo in
                if geo.size.width < geo.size.height {
                    ZStack {
                        NavigationView {
                            VStack {
                                if showIcon {
                                    ZStack {
                                        ForEach(0..<200) { _ in
                                            Star()
                                                .padding(5)
                                        }
                                        if geo.size.width < geo.size.height {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: geo.size.width - 40, height: geo.size.width - 40)
                                                .padding(20)
                                                .foregroundColor(.white)
                                                .shadow(color: .white, radius: 15)
                                            Image("MelekIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geo.size.width - 50, height: geo.size.width - 50)
                                                .cornerRadius(15)
                                                .padding(30)
                                        }
                                    }
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.gray)
                                        .shadow(color: .white, radius: 15)
                                        .padding(20)
                                    Text("Mit dem neuen App Icon möchte unsere App Designerin Melek zeigen, dass in der Mathematik alles bis zum Unendlichen gehen kann.\nDies bedeutet, dass uns nie die Ideen ausgehen werden und wir \"Unendlich viele Ideen\" haben")
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(20)
                                }
                            }
                            .onDisappear {
                                withAnimation(.easeOut(duration: 1.0)) {
                                    showIcon = false
                                }
                            }
                            .onAppear {
                                withAnimation(.easeIn(duration: 1.0)) {
                                    showIcon = true
                                }
                            }
                            .navigationTitle("Infinity Math")
                        }
                    }
                } else {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: geo.size.height - 40, height: geo.size.height - 40)
                                .padding(20)
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 15)
                            Image("MelekIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.height - 50, height: geo.size.height - 50)
                                .cornerRadius(15)
                                .padding(30)
                        }
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.gray)
                                    .padding(20)
                                Text("Mit dem neuen App Icon möchte unsere App Designerin Melek zeigen, dass in der Mathematik alles bis zum Unendlichen gehen kann.\nDies bedeutet, dass uns nie die Ideen ausgehen werden und wir \"Unendlich viele Ideen\" haben")
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(20)
                            }
                            Spacer()
                                .frame(width: 30)
                        }
                    }
                }
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            melekIcon = false
                            showIcon = false
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                        })
                        .padding(20)
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $versionView) {
            NavigationView {
                ZStack {
                    List {
                        Section("2.0") {
                            NavigationLink("2.0", destination: {
                                WasIstNeuView(title: "2.0", text: "Ein neues Design \nNeue Aufgaben in der Klassenstufe 8 \nAlle Aufgaben enthalten eine Lösung (außer die Termaufgaben)")
                            })
                            NavigationLink("2.1", destination: {
                                WasIstNeuView(title: "2.1", text: "Die Klassenstufe 9 wurde neu hinzugefügt")
                            })
                            NavigationLink("2.1.1", destination: {
                                WasIstNeuView(title: "2.1.1", text: "Fehlerbehebungen: \nRechtschreibfehler \nUI Fehler: Die Schrift bei der 9. Klassenstufe und auf dem Externenbildschirm war im Darkmode nicht lesbar \n \nNeu: \nEin neuer Ladebildschirm")
                            })
                        }
                        Section("3.0") {
                            NavigationLink("3.0", destination: {
                                WasIstNeuView3_0()
                                    .navigationTitle("3.0")
                            })
                        }
                        Section("4.0") {
                            NavigationLink("4.0", destination: {
                                WasIstNeuView4_0()
                                    .navigationTitle("4.0")
                            })
                            NavigationLink("5.0", destination: {
                                WasIstNeuView5_0()
                                    .navigationTitle("4.1")
                            })
                        }
                    }
                    .navigationTitle("Was ist neu?")
                    VStack {
                        Spacer()
                        Button(action: {
                            versionView = false
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                Text("Fertig")
                                    .foregroundColor(.white)
                            }
                        })
                        .padding(20)
                    }
                }
            }
        }
    }
    
    func changeFrames() {
        withAnimation(.easeIn(duration: 3.0)) {
            airplayHeight = 40
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.changeFrames()
        }
        withAnimation(.easeOut(duration: 3.0)) {
            airplayHeight = 20
        }
    }
}

#Preview {
    TabBarOben()
}
