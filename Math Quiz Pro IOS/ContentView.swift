//
//  ContentView.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import SwiftUI
import Foundation
import StoreKit
import TipKit

struct ChangeViewTip: Tip {
    var id: String
    
    var title: Text {
        Text("Neues Design")
    }
    
    var message: Text? {
        Text("Tippen Sie auf die drei Punkte unten, um durch die App zu navigieren")
    }
    
    var image: Image? {
        Image(systemName: "iphone.gen1")
    }
}

struct ViewPickerView: View {
    var image: String
    var text: String
    var tint: Color
    @AppStorage("actuallyView") var actuallyView = "Unterricht"
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                    .frame(width: 20)
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                Spacer()
                    .frame(width: 10)
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.white)
                        .frame(height: 50)
                    Text(text)
                }
            }
            .foregroundColor(actuallyView == text ? .gray : tint)
            .frame(width: 300)
            Spacer()
        }
    }
}

struct ContentView: View {
    @ObservedObject var externalDisplayContent = ExternalDisplayContent()
    @AppStorage("task") private var task = ""
    @AppStorage("device") var device = ""
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    @AppStorage ("cV") var cV = 0
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("day") var day = 0
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("new") var new = ""
    @State var showNewView = false
    @AppStorage("feedback") var feedback = 0
    @State var showViewPicker = false
    @AppStorage("actuallyView") var actuallyView = "Unterricht"
    var viewNavigatorTip =  ChangeViewTip(id: "viewNavigator")
    
    var cView: some View {
        GeometryReader { geo in
            ZStack {
                if showViewPicker {
                    Rectangle()
                        .background(
                            .regularMaterial,
                            in: RoundedRectangle(cornerRadius: 1, style: .continuous)
                        )
                        .ignoresSafeArea(.all)
                }
                VStack {
                    TabBarOben()
                    if #available(iOS 17.0, *) {
                        TipView(viewNavigatorTip, arrowEdge: .top)
                            .padding(.horizontal, 20)
                    }
                    if actuallyView == "Unterricht" {
                        Schule(geo: geo)
                    } else if actuallyView == "Werkzeuge" {
                        Werkzeuge()
                    } else if actuallyView == "Schülereinstellungen" {
                        SchülerEinstellungen()
                    } else if actuallyView == "Nachhilfe" {
                        Nachhilfe()
                    }
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showViewPicker.toggle()
                        }
                    }, label: {
                        Spacer()
                            .frame(width: 20)
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 50, height: 50)
                                Image(systemName: showViewPicker ? "xmark" : "ellipsis")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 15)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                                .frame(width: 10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                    .foregroundColor(.white)
                                Text(actuallyView)
                            }
                            Spacer()
                                .frame(width: 20)
                        }
                    })
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .task {
            if #available(iOS 17.0, *) {
                // Configure and load your tips at app launch.
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
            }
        }
        .overlay {
            if showViewPicker {
                ZStack {
                    VStack {
                        Rectangle()
                            .background(
                                .regularMaterial,
                                in: RoundedRectangle(cornerRadius: 1, style: .continuous)
                            )
                        Spacer()
                            .frame(height: 50)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showViewPicker = false
                        }
                    }
                    VStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showViewPicker = false
                                actuallyView = "Werkzeuge"
                            }
                        }, label: {
                            ViewPickerView(image: "wrench.and.screwdriver.fill", text: "Werkzeug", tint: .mint)
                        })
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showViewPicker = false
                                actuallyView = "Nachhilfe"
                            }
                        }, label: {
                            ViewPickerView(image: "questionmark.bubble.fill", text: "Nachhilfe", tint: .yellow)
                        })
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showViewPicker = false
                                actuallyView = "Unterricht"
                            }
                        }, label: {
                            ViewPickerView(image: "graduationcap.fill", text: "Unterricht", tint: .blue)
                        })
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showViewPicker = false
                                actuallyView = "Schülereinstellungen"
                            }
                        }, label: {
                            ViewPickerView(image: "person.2.fill", text: "Schülereinstellungen", tint: .blue)
                        })
                        Spacer()
                            .frame(height: 75)
                    }
                    .statusBar(hidden: true)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if cV == 1 {
                cView
                    .sheet(isPresented: $showNewView) {
                        NavigationView {
                            WasIstNeuView5_0()
                                .navigationTitle("Was ist neu?")
                        }
                    }
            } else if cV == 0 {
                LS()
            } else {
                ZStack {
                    VStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.mint)
                        Spacer()
                            .frame(height: 10)
                        Circle()
                            .frame(width: 275, height: 250)
                            .foregroundColor(.mint)
                            .padding(0)
                    }
                    VStack {
                        Spacer()
                            .frame(height: 140)
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 285, height: 125)
                    }
                    VStack {
                        Spacer()
                            .frame(height: 112.5)
                        HStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 25, height: 200)
                                .foregroundColor(.mint)
                                .padding(7)
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 25, height: 200)
                                .foregroundColor(.mint)
                                .padding(7)
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 25, height: 200)
                                .foregroundColor(.mint)
                                .padding(7)
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 25, height: 200)
                                .foregroundColor(.mint)
                                .padding(7)
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 25, height: 200)
                                .foregroundColor(.mint)
                                .padding(7)
                        }
                    }
                    VStack {
                        Spacer()
                            .frame(height: 312.5)
                        ZStack {
                            Rectangle()
                                .foregroundColor(.mint)
                                .frame(width: 250, height: 50)
                            if #available(iOS 16.0, *) {
                                Text("MGL")
                                    .font(.system(.title, weight: .bold))
                                    .foregroundStyle(.white)
                            } else {
                                Text("MGL")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                withAnimation(.easeIn(duration: 1.0)) {
                    let currentDate = Date()
                    let calendar = Calendar.current
                    let dayOfWeek = calendar.component(.weekday, from: currentDate)
                    if day == dayOfWeek {
                        cV = 1
                    } else {
                        day = dayOfWeek
                        cV = 0
                    }
                }
                if appVersion != new {
                    new = appVersion ?? ""
                    showNewView = true
                }
                /*
                 if feedback == 5 {
                     if #available(iOS 16.0, *) {
                         
                     }
                 } else {
                     feedback += 1
                 }
                 */
            } else if newPhase == .inactive {
                let currentDate = Date()
                let calendar = Calendar.current
                let dayOfWeek = calendar.component(.weekday, from: currentDate)
                if day == dayOfWeek {
                    cV = 1
                } else {
                    cV = 2
                }
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}

struct Star: View {
    @State private var xOffset: CGFloat = 0.0
    @State private var yOffset: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    @State private var color = 0
    @State private var fgColor: Color = Color.white
    var star: some View {
        Circle()
            .fill(Color.white)
            .frame(width: height, height: height)
            .offset(x: xOffset, y: yOffset)
            .onAppear {
                self.xOffset = CGFloat.random(in: -500...500)
                self.yOffset = CGFloat.random(in: -500...500)
                self.animateStar()
            }
    }

    private func animateStar() {
        color = Int.random(in: 0...1)
        if color == 0 {
            withAnimation {
                fgColor = Color.white
            }
        } else {
            withAnimation {
                fgColor = Color.blue
            }
        }
        
        let newHeight = CGFloat.random(in: 0...10)
        if newHeight < height {
            withAnimation(.easeOut(duration: 3.0)) {
                height = newHeight
            }
        } else {
            withAnimation(.easeIn(duration: 3.0)) {
                height = newHeight
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.animateStar()
        }
    }
    
    var body: some View {
        star
    }
}

struct WasIstNeuView: View {
    var title: String
    var text: String
    
    var body: some View {
        Form {
            Text(text)
        }
        .navigationTitle(title)
    }
}

struct WasIstNeuView5_0: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section("Shortcuts") {
                    HStack {
                        Image(systemName: "waveform.badge.mic")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Öffnen Sie die Klassen schneller mit der Shortcut App oder mit Siri")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("Design") {
                    HStack {
                        Image(systemName: "iphone.gen2")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Der Home Bildschirm wurde übersichtlicher unterteilt und eine kleiner Designfehler wurde behoben")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("Neuer Bereich") {
                    HStack {
                        Image(systemName: "questionmark.bubble.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Für Schüler*innen ist der Nachhilfebereich dazugekommen")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("Fehlerbehebungen") {
                    HStack {
                        Image(systemName: "gear.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Wir haben einige Fehler bei der 8. und 9. Klasse behoben")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
            }
            Button(action: {
                dismiss()
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

struct WasIstNeuView4_0: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section("Design") {
                    HStack {
                        Image(systemName: "iphone.gen2")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Der Home Bildschirm wurde übersichtlicher unterteilt und eine kleiner Designfehler wurde behoben")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("Neue Funktionen") {
                    HStack {
                        Image(systemName: "chair")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Es gibt ein neuen Abschnitt, wo die Lehrer eine Sitzordnung für alle Ihre Klassen hinzufügen können")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                    HStack {
                        Image(systemName: "person.2.wave.2.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Die Lautstärkemessung wurde hinzugefügt")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
            }
            Button(action: {
                dismiss()
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

struct WasIstNeuView3_0: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section("Design") {
                    HStack {
                        Image(systemName: "iphone.gen2")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Der Home Bildschirm hat einen neues Design")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                    HStack {
                        Image("MelekIcon")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 50, height: 50)
                        Text("Ein neues App Icon")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("AirPlay") {
                    HStack {
                        Image(systemName: "airplayvideo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Sobald AirPlay aktiviert ist, erscheint eine Benachrichtigung auf dem Home Bildschirm")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("Klassenliste") {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("In der Klassenliste können Sie mehrere Klassen eintragen und die dazugehörigen Schüler hinzufügen \nBei der Besprechung mit der Klasse wird nur Ihnen ein zufälliger Schüler angezeigt, der die Übung beantworten könnte. \nZudem können Sie in den Einstellungen den Status von allen Schülern sehen (Abwesend, richtige Antworten, falsche Antworten)")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
                Section("Datenschutz") {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Die Klassenliste und alle anderen Daten sind lokal auf Ihr Gerät gespeichert")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
            }
            Button(action: {
                dismiss()
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

struct KlasseNav: View {
    var klasse: Int
    var übungen: String
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                Text("Klasse \(klasse)")
                    .foregroundColor(.white)
            }
            Spacer()
                .frame(height: 0)
            Rectangle()
                .frame(width: 5, height: 15)
                .foregroundColor(.white)
            Spacer()
                .frame(height: 0)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray)
                VStack {
                    HStack {
                        Text("Übungen: \n \(übungen)")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .padding(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

