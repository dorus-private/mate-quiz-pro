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
import SplineRuntime

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
    @AppStorage("verknüpfungstart") var verknüpfungstart = 0
    @AppStorage("Einführung") var einführung = true
    @State var einführungSheet = false
    @AppStorage("rolle") var rolle = 1
    
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
                        TipView(viewNavigatorTip, arrowEdge: .none)
                            .padding(.horizontal, 20)
                    }
                    if actuallyView == "Unterricht" || actuallyView == "Übungen" {
                        Schule(geo: geo)
                    } else if actuallyView == "Werkzeuge" {
                        Werkzeuge()
                    } else if actuallyView == "Einstellungen" {
                        Einstellungen()
                    } else if actuallyView == "Nachhilfe" {
                        Nachhilfe()
                    } else if actuallyView == "Schüler" {
                        Schülereinstellungen()
                    } else if actuallyView == "Punkte" {
                        Punkte()
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
                                if #available(iOS 17.0, *) {
                                    Image(systemName: showViewPicker ? "xmark" : "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 15)
                                        .foregroundColor(.white)
                                        .contentTransition(.symbolEffect(.replace))
                                } else {
                                    Image(systemName: showViewPicker ? "xmark" : "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 15)
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer()
                                .frame(width: 10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                    .foregroundColor(.white)
                                    .shadow(radius: rolle == 1 ? 0 : 5)
                                Text(actuallyView)
                            }
                            Spacer()
                                .frame(width: 20)
                        }
                    })
                    Spacer()
                        .frame(height: 20)
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
        .onAppear {
            if actuallyView == "Schülereinstellungen" {
                actuallyView = "Einstellungen"
            }
        }
        .overlay {
            if showViewPicker {
                VStack {
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
                                    actuallyView = "Nachhilfe"
                                }
                            }, label: {
                                ViewPickerView(image: "questionmark.bubble.fill", text: "Nachhilfe", tint: .yellow)
                            })
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    showViewPicker = false
                                    if rolle == 1 {
                                        actuallyView = "Unterricht"
                                    } else {
                                        actuallyView = "Übungen"
                                    }
                                }
                            }, label: {
                                ViewPickerView(image: "graduationcap.fill", text: rolle == 1 ? "Unterricht" : "Übungen", tint: .blue)
                            })
                            if rolle == 1 {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        showViewPicker = false
                                        actuallyView = "Schüler"
                                    }
                                }, label: {
                                    ViewPickerView(image: "person.3.sequence.fill", text: "Schüler", tint: .blue)
                                })
                            } else {
                                Spacer()
                                    .frame(height: 25)
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        showViewPicker = false
                                        actuallyView = "Punkte"
                                    }
                                }, label: {
                                    ViewPickerView(image: "trophy.circle.fill", text: "Punkte", tint: .blue)
                                })
                            }
                            Spacer()
                                .frame(height: 25)
                            if rolle == 1 {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        showViewPicker = false
                                        actuallyView = "Werkzeuge"
                                    }
                                }, label: {
                                    ViewPickerView(image: "wrench.and.screwdriver.fill", text: "Werkzeug", tint: .mint)
                                })
                                Spacer()
                                    .frame(height: 25)
                            }
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    showViewPicker = false
                                    actuallyView = "Einstellungen"
                                }
                            }, label: {
                                ViewPickerView(image: "gear", text: "Einstellungen", tint: .green)
                            })
                            Spacer()
                                .frame(height: 75)
                        }
                        .statusBar(hidden: true)
                    }
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if cV == 1 {
                cView
                    .sheet(isPresented: $showNewView) {
                        VStack {
                            Text("Was ist neu?")
                                .font(.title)
                                .padding(20)
                            WasIstNeu8_0()
                            Button(action: {
                                showNewView = false
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 50)
                                    Text("Fertig")
                                        .foregroundStyle(.white)
                                }
                            })
                            .padding(20)
                        }
                    }
                    .sheet(isPresented: $einführungSheet) {
                        Einführung()
                            .interactiveDismissDisabled(true)
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
                if appVersion != new && einführung == false {
                    new = appVersion ?? ""
                    showNewView = true
                } else if einführung {
                    einführungSheet = true
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
    @AppStorage("rolle") var rolle = 1
    
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
                if rolle == 1 {
                    fgColor = Color.white
                } else {
                    fgColor = Color.black
                }
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
                Section("Neue Funktionen") {
                    HStack {
                        Image(systemName: "person.crop.circle.dashed")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        Text("Setzen Sie den Status Ihrer Klasse zurück, nachdem Sie die Mündlichen Noten erstellt haben")
                            .multilineTextAlignment(.leading)
                            .padding(10)
                    }
                }
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
                        Image(systemName: "gearshape.fill")
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
    @AppStorage("rolle") var rolle = 1
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .shadow(radius: rolle == 1 ? 0 : 5)
                Text("Klasse \(klasse)")
                    .foregroundColor(.white)
            }
            Spacer()
                .frame(height: 0)
            Rectangle()
                .frame(width: 5, height: 15)
                .foregroundColor(rolle == 1 ? .white : .black)
            Spacer()
                .frame(height: 0)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray)
                    .shadow(radius: rolle == 1 ? 0 : 5)
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

struct WasIstNeu6_0: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Kopfrechnen Abschnitt")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Üben Sie Ihr Kopfrechnen alleine oder mit der gesammten Klasse")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Rollenzuteilung")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Sie können entscheiden, warum Sie die App benutzen, sodass die App Ihnen ein angepasstes Design vorschlagen kann")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "app.badge")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Pushbenachrichtigung")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Bleiben Sie mit der Pushbenachrichtigung auf dem neustem Stand")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    Text("Fehlerbehebungen")
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
    }
}

struct WasIstNeu6_1: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Neue Aufgaben")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Die 9. Klasse hat 7 neue Aufgaben dazu bekommen!")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Countdown")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Die Schrift vom Countdown wurde auf dem externen Bldschirm größer gemacht, sodass alle den Countdown gut sehen können")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu6_2: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Einstellungen für die Aufgaben")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Sie können in den Einstellungen einstellen, ob ein anderer Schüler angezeigt werden soll, wenn der vorherige Schüler die Aufgabe falsch beantwortet hat")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "airplayvideo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Externer Bildschirm (Warte Bildschirm)")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Sie können entscheiden, welches Motiv auf dem Externen Bildschirm angezeigt werden soll, solange Sie die Aufgaben für die Schüler einstellen \nÖffnen Sie dafür die Einstellungen")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu6_3: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Das Hausnummernspiel")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Für Lehrer, die ein iPad besitzen, ist das Hausnummernspiel neu dazu gekommen. Man findet dies unter dem Tab \"Unterricht\" ")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu6_3_1: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Das Hausnummernspiel")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Neues Design: \nDem Gewinner wird auf Ihrem Bildschirm und auf dem externen Bildschirm ein Feuerwerk angezeigt. \n \nFehlerbehebung: \nEs gab einen kleinen Fehler, wenn man das Spiel nochmal spielen wollte. Dieser wurde jetzt behoben.")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "airplayvideo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Der externe Bildschirm")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Fehlerbehebungen von Aktualisierungen auf dem externen Bildschirm und vom Design")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu7: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "medal")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Punkte")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Die Schüler bekommen eine Challenge: \nSammelt Punkte, um aufzusteigen und Erfolge einzuholen")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "iphone.gen1")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Neues Design")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Wir haben das Yin and Yang Design eingeführt: \nHierbei ändert sich die Farbe je nach Rolle. \nIst man ein Lehrer oder eine Lehrerin, so nimmt der Hintergrund in der ganzen App die Farbe schwarz an. \nIst man ein Schüler, oder eine Schülerin, so nimmt der Hintergrund die Farbe weiß an.")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Das Hausnummernspiel")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Fehlerbehebung: \nWenn Sie keine Sitzordnung für die gewählte Klasse erstellt haben, dann werden Sie gewarnt und können nicht fortfahren, bis Sie eine Sitzordnung erstellt wird")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu7_0_1: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "ipad.gen1")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Design")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Mehrere Designfehler sind jetzt behoben")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu7_1: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "airplayvideo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Bildschirmübertragung")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("In der Bildschirmsynchronisierung werden jetzt alle Informationen so gut wie möglich übertragen")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "deskclock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Counter")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Der Counter hat ein neues Design bekommen und sieht jetzt futuristischer aus")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "ipad.gen1")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Anpassbares Design")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Stellen Sie in den Einstellungen ein, ob Sie Links- oder Rechtshänder sind, damit die Buttons einfacher zu erreichen sind")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct WasIstNeu8_0: View {
    var body: some View {
        Form {
            Section("") {
                HStack {
                    Image(systemName: "ladybug")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Fehlerbehebungen & Feedback")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Wir haben uns Feedback von Lehrern geholt und versucht alles in diesem Update einfließen zu lassen: \n- Schüler können jetzt mit der Taste Enter zur Klassenliste hinzugefügt werden \n- Die Klassen Liste ist alphabetisch nach dem Vornamen sortiert \n- Lange Namen passen problemlos in die Sitze der Sitzordnung rein \n- Korrektur von Rechtschreibfehlern \n- Beim Hausnummern Spiel kann man die Lösung zurücksetzen, falls man falsch gedrückt hatte")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "platter.filled.bottom.iphone")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Widget")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Bist du ein Schüler? \nDann behalte deinen Rang viel besser im Blick mit dem neuen \"Status Widget\" für den Home Bildschirm")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
            Section("") {
                HStack {
                    Image(systemName: "textformat.size")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Spacer()
                        .frame(width: 10)
                    VStack {
                        HStack {
                            Text("Textgröße")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text("Die Textgröße für den Externen Bildschirm ist jetzt in den Einstellungen anpassbar")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 10)
                }
            }
        }
    }
}

struct Einführung: View {
    @AppStorage("Einführungsschritt") var step = 0
    @AppStorage("rolle") var rolle = 1
    @AppStorage("Einführung") var einführung = true
    @StateObject var notificationManager = NotificationManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if step <= 3 {
                Text("Neu bei Mathe Quiz Pro")
                    .font(.title)
                    .padding(20)
            }
            if step == 0 || step == 4 {
                WasIstNeu8_0()
            } else if step == 1 {
                Text("Bitte wählen Sie eine Rolle aus, für ein angepasstes Design. \nDie Rolle kann später in den Einstellungen umgeändert werden")
                    .multilineTextAlignment(.center)
                    .padding(10)
                Form {
                    Picker(selection: $rolle, label: Text("Rolle")) {
                        Text("Lehrer").tag(1)
                        Text("Schüler").tag(2)
                    }
                }
            } else if step == 2 {
                Text("Erlauben Sie der App, Ihnen Pushbenachrichtigungen zu senden")
                    .multilineTextAlignment(.center)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 5)
                Text("Mathe Quiz Pro wird Sie so auf dem neustem Stand halten, indem Sie schnell erfahren, wann es ein neues Update gibt")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                Spacer()
                Image(systemName: "app.badge")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red)
                    .frame(width: 100, height: 100)
            } else if step == 3 {
                if rolle == 1 {
                    Text("Super! Sie haben alle nötigen Konfigurationsschritte druchgeführt. Jetzt können Sie die App weiterhin normal nutzen.")
                        .multilineTextAlignment(.center)
                        .padding(10)
                } else {
                    Text("Super! Du hast alle nötigen Konfigurationsschritte druchgeführt. Jetzt kannst du die App weiterhin normal nutzen.")
                        .multilineTextAlignment(.center)
                        .padding(10)
                }
                Spacer()
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.green)
                    .frame(width: 100, height: 100)
            }
            Spacer()
            if step <= 4 {
                HStack {
                    Spacer()
                        .frame(width: 20)
                    Button(action: {
                        if step == 4 {
                            dismiss()
                        } else {
                            step += 1
                            if step == 3 {
                                Task {
                                    await notificationManager.request()
                                }
                            } else if step == 4 {
                                einführung = false
                                dismiss()
                            }
                        }
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                            if step < 2 {
                                Text("Weiter")
                                    .foregroundStyle(.white)
                            } else if step == 2 {
                                Text("Erlauben")
                                    .foregroundStyle(.white)
                            } else {
                                Text("Feritg")
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 50)
                    })
                    Spacer()
                        .frame(width: 20)
                }
                Spacer()
                    .frame(height: 10)
                if step == 2 {
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Button("Später in den Einstellungen") {
                            step += 1
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                        .frame(height: 20)
                } else {
                    Spacer()
                        .frame(height: 10)
                }
            }
        }
    }
}
