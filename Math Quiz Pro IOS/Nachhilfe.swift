//
//  Nachhilfe.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.01.24.
//

import SwiftUI

struct RotateDevice: View {
    var verticalDrehen: Bool
    
    @State var image = ""
    @State var degrees = 0.0
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @AppStorage("task") private var task = ""
    
    var body: some View {
        VStack {
            Text("Bitte drehen Sie Ihr Gerät, damit Sie fortfahren können")
            Spacer()
            HStack {
                Spacer()
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: degrees))
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.mint)
        .onAppear {
            task = ""
            if UIDevice.current.userInterfaceIdiom == .phone {
                if verticalDrehen {
                    image = "iphone.gen1.landscape"
                } else {
                    image = "iphone.gen1"
                }
            } else {
                if verticalDrehen {
                    image = "ipad.gen1.landscape"
                } else {
                    image = "ipad.gen1"
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeIn(duration: 0.5)) {
                if degrees == 90.0 {
                    degrees = 0.0
                } else {
                    degrees = 90.0
                }
            }
        }
    }
}

struct NachhilfeNavigationView: View {
    var geo: GeometryProxy
    var image: String
    var title: String
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                        .frame(width: 20)
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                    Spacer()
                        .frame(width: 20)
                }
                VStack {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 35)
                        Text(title)
                            .foregroundColor(.black)
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.forward.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.blue)
                        Spacer()
                            .frame(width: 30)
                    }
                    Spacer()
                }
            }
            .frame(height: geo.size.height / 3)
            Spacer()
                .frame(height: 5)
            HStack {
                Spacer()
                Text("Vom Entwickler")
                    .foregroundStyle(.gray)
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.green)
                Spacer()
                    .frame(width: 20)
            }
            Spacer()
                .frame(height: 20)
        }
    }
}

struct Nachhilfe: View {
    var body: some View {
        GeometryReader { geo in
            if UIDevice.current.userInterfaceIdiom == .phone {
                if geo.size.width > geo.size.height {
                    RotateDevice(verticalDrehen: true)
                } else {
                    NavigationLink(destination: {
                        VStack {
                            NavigationLink(destination: {
                                ScrollView {
                                    HStack {
                                        Spacer()
                                            .frame(width: 20)
                                        VStack {
                                            Text("1. Potenzgesetz \nPotenzen mit gleicher Basis")
                                                .font(.title2)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.indigo)
                                            spacerH15
                                            Text("Potenzen mit gleicher Basis werden multipliziert, indem man ihre Basis behält und die Exponenten addiert: \nBsp: a³ * a ⁷ = a³⁺⁷ = a¹⁰")
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.mint)
                                            spacerH15
                                            Text("Potenzen mit gleicher Basis werden dividiert, indem man ihre Basis behält und die Exponenten subtrahiert: \nBsp: a⁷ : a ³ = a⁷⁻³ = a⁴")
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.mint)
                                            spacerH20
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(height: 5)
                                                .foregroundColor(.white)
                                            spacerH15
                                            Text("2. Potenzgesetz \nPotenzen mit gleichen Exponenten")
                                                .font(.title2)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.indigo)
                                            spacerH15
                                            Text("Potenzen mit gleichen Exponenten werden miteinander multipliziert bzw. dividiert, indem man den gemeinseman Exponenten behält: \n 1. Bsp: 6ª : 3ª = (6 : 3)ª = 2ª \n2. Bsp: 8ª * 4ª = (8 * 4)ª = 32ª")
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.mint)
                                            spacerH20
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(height: 5)
                                                .foregroundColor(.white)
                                            spacerH15
                                            Text("3. Potenzieren von Potenzen")
                                                .font(.title2)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.indigo)
                                            spacerH15
                                            Text("Eine Potenz wird potenziert, indem man die Exponenten miteinander multipliziert: \nBesp: (a⁷)⁹ = a⁷﹡⁹ = a⁶³")
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.mint)
                                            spacerH20
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(height: 5)
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                            .frame(width: 20)
                                    }
                                }
                                .navigationTitle("Potenzgesetze")
                            }, label: {
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(height: 50)
                                        Text("Potenzgesetze")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                        .frame(width: 20)
                                }
                            })
                            spacerH15
                            /*
                            NavigationLink(destination: {
                                ScrollView {
                                    HStack {
                                        Spacer()
                                            .frame(width: 20)
                                        VStack {
                                            Text("I. Potenzgleichungen")
                                                .font(.title)
                                                .foregroundStyle(.indigo)
                                            spacerH20
                                            Text("Es gibt mehrere Arten von Potenzgleichungen:")
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(.mint)
                                            spacerH15
                                            
                                        }
                                        Spacer()
                                            .frame(width: 20)
                                    }
                                }
                                .navigationTitle("Potenz und Wurzelgleichungen")
                            }, label: {
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(height: 50)
                                            .foregroundStyle(.green)
                                        Text("Potenz und Wurzel Gleichungen")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                        .frame(width: 20)
                                }
                            })
                             */
                            Spacer()
                        }
                        .navigationTitle("Potenzen und Potenzgesetze")
                    }, label: {
                        NachhilfeNavigationView(geo: geo, image: "Potenzen", title: "Potenzen und Potenzgesetze")
                    })
                }
            }
        }
    }
    
    var spacerH20: some View {
        Spacer()
            .frame(height: 20)
    }
    
    var spacerH15: some View {
        Spacer()
            .frame(height: 15)
    }
}
