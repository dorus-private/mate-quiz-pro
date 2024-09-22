//
//  TabBarOben.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.12.23.
//

import SwiftUI

struct ProblemBeschreibung: View {
    var zeigen: Bool
    var title: String
    @Binding var beschreibung: String
    
    var body: some View {
        if zeigen {
            HStack {
                Spacer()
                    .frame(width: 20)
                VStack {
                    HStack {
                        Text(title)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Text("Beschreiben Sie das Problem:")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    TextEditor(text: $beschreibung)
                    Spacer()
                        .frame(height: 10)
                }
                Spacer()
                    .frame(width: 20)
            }
        }
    }
}

struct Auswählen: View {
    var selected: Bool
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                    HStack {
                        Spacer()
                            .frame(width: 10)
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                .frame(width: 30, height: 30)
                                .foregroundColor(selected ? .green : .gray)
                            Spacer()
                        }
                        Spacer()
                            .frame(width: 10)
                        Text(title)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                Spacer()
                    .frame(width: 20)
            }
            Spacer()
                .frame(height: 10)
        }
    }
}

struct TabBarOben: View {
    @AppStorage("isAirPlayActive") var isAirplayActive = false
    @State var airplayHeight: CGFloat = 25
    @State var versionView = false
    @State var einstellungen = false
    @State var melekIcon = false
    @State var showIcon = false
    @State var showFehlerMelden = false
    @AppStorage("actuallyView") var actuallyView = "Unterricht"
    @State var rechtschreibfehler = false
    @State var rechtschreibfehlerBeschreibung = "-"
    @State var absturz = false
    @State var absturzBeschreibung = "-"
    @State var funktionsFehler = false
    @State var funktionsFehlerBeschreibung = "-"
    @State var sonstige = false
    @State var sonstigeÜberschrift = ""
    @State var sonstigeBeschreibung = ""
    @AppStorage("rolle") var rolle = 1
    
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
                        .shadow(radius: rolle == 1 ? 0 : 5)
                    HStack {
                        Text("AirPlay könnte aktiviert sein")
                            .foregroundColor(.black)
                            .padding(20)
                        Spacer()
                        if #available(iOS 17.0, *) {
                            Image(systemName: "airplayvideo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .symbolEffect(.variableColor, options: .repeating.speed(0.5))
                                .foregroundColor(.blue)
                                .padding(20)
                        } else {
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
                }
                Spacer()
                    .frame(width: 10)
            } else if rolle != 1 {
                SocialMedia()
                    .frame(height: 67.5)
                    .onTapGesture {
                        let Username =  "leon.apps_de" // Your Instagram Username here
                        let appURL = URL(string: "instagram://user?username=\(Username)")!
                        let application = UIApplication.shared
                        
                        if application.canOpenURL(appURL) {
                            application.open(appURL)
                        } else {
                            // if Instagram app is not installed, open URL inside Safari
                            let webURL = URL(string: "https://www.instagram.com/leon.apps_de/")!
                            application.open(webURL)
                        }
                    }
            } else {
                Spacer()
            }
            /*
            Button(action: {
               showFehlerMelden = true
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 50, height: 50)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }
            })
            Spacer()
                .frame(width: 20)
             */
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
        .sheet(isPresented: $showFehlerMelden) {
            NavigationView {
                VStack {
                    Text("Fehlermeldung für den Bereich \"\(actuallyView)\"")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Text("Sie haben ein Fehler im Bereich \(actuallyView) gefunden? \n Dann teilen Sie uns diesen mit, indem Sie den folgenden Schritten folgen")
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                    NavigationLink(destination: {
                        VStack {
                            ScrollView {
                                VStack {
                                    Text("Wählen Sie die Art des Fehlers aus")
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                        .padding(20)
                                    Button(action: {
                                        rechtschreibfehler.toggle()
                                    }, label: {
                                        Auswählen(selected: rechtschreibfehler, title: "Rechtschreibfehler")
                                    })
                                    Button(action: {
                                        absturz.toggle()
                                    }, label: {
                                        Auswählen(selected: absturz, title: "Unerwarteter Absturz")
                                    })
                                    Button(action: {
                                        funktionsFehler.toggle()
                                    }, label: {
                                        Auswählen(selected: funktionsFehler, title: "Funktionsfehler")
                                    })
                                    Button(action: {
                                        sonstige.toggle()
                                    }, label: {
                                        Auswählen(selected: sonstige, title: "Sonstige")
                                    })
                                    if sonstige {
                                        HStack {
                                            Spacer()
                                                .frame(width: 20)
                                            VStack {
                                                Text("Bitte geben Sie eine Überschrift für den nicht genannten Fehler")
                                                Spacer()
                                                    .frame(height: 10)
                                                TextField("Überschrift", text: $sonstigeÜberschrift)
                                                    .textFieldStyle(.roundedBorder)
                                            }
                                            Spacer()
                                                .frame(width: 20)
                                        }
                                    }
                                }
                            }
                            Spacer()
                            NavigationLink(destination: {
                                VStack {
                                    ScrollView {
                                        VStack {
                                            ProblemBeschreibung(zeigen: rechtschreibfehler, title: "Rechtschreibfehler", beschreibung: $rechtschreibfehlerBeschreibung)
                                            ProblemBeschreibung(zeigen: absturz, title: "Unerwarteter Absturz", beschreibung: $absturzBeschreibung)
                                            ProblemBeschreibung(zeigen: funktionsFehler, title: "Funktionsfehler", beschreibung: $funktionsFehlerBeschreibung)
                                            ProblemBeschreibung(zeigen: rechtschreibfehler, title: sonstigeÜberschrift, beschreibung: $sonstigeBeschreibung)
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        UIApplication.shared.open(makeEmailURL(subject: "Fehlermeldung bei Mathe Quiz Pro", body: "Sehr geehrter Entwickler, \nich nutze oft Ihre App Mathe Quiz Pro. Dabei sind bei mir einige Fehler aufgetreten, die ich Ihnen mitteilen möchte: \n \nRechtschreibfehler:\n\(rechtschreibfehlerBeschreibung)\n \nUnerwarteter Absturz: \n\(absturzBeschreibung) \n \nFunktionsfehler: \n \n\(funktionsFehlerBeschreibung) \n \n\(sonstigeÜberschrift) \n\(sonstigeBeschreibung) \n \nIch würde mir gerne wünschen, dass diese Fehler in den kommenden Updates behoben werden. \n \nVielen Dank im Voraus."))
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(height: 50)
                                            Text("Weiter")
                                                .foregroundStyle(.white)
                                        }
                                    })
                                    .padding(20)
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 50)
                                    Text("Weiter")
                                        .foregroundStyle(.white)
                                }
                            })
                            .padding(20)
                        }
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 50)
                            Text("Weiter")
                                .foregroundStyle(.white)
                        }
                    })
                    .padding(20)
                }
            }
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
                    ForEach(0..<200) { _ in
                        Star()
                            .padding(5)
                    }
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
                .preferredColorScheme(.dark)
            }
        }
        .sheet(isPresented: $versionView) {
            NavigationView {
                VStack {
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
                        }
                        Section("5.0") {
                            NavigationLink("5.0", destination: {
                                WasIstNeuView5_0()
                                    .navigationTitle("5.0")
                            })
                        }
                        Section("6.0") {
                            NavigationLink("6.0", destination: {
                                WasIstNeu6_0()
                                    .navigationTitle("6.0")
                            })
                            NavigationLink("6.1", destination: {
                                WasIstNeu6_1()
                                    .navigationTitle("6.1")
                            })
                            NavigationLink("6.2", destination: {
                                WasIstNeu6_2()
                                    .navigationTitle("6.2")
                            })
                            NavigationLink("6.3", destination: {
                                WasIstNeu6_3()
                                    .navigationTitle("6.3")
                            })
                            NavigationLink("6.3.1", destination: {
                                WasIstNeu6_3_1()
                                    .navigationTitle("6.3.1")
                            })
                        }
                        Section("7.0") {
                            NavigationLink("7.0", destination: {
                                WasIstNeu7()
                                    .navigationTitle("7.0")
                            })
                            NavigationLink("7.0.1", destination: {
                                WasIstNeu7_0_1()
                                    .navigationTitle("7.0.1")
                            })
                            NavigationLink("7.1", destination: {
                                WasIstNeu7_1()
                                    .navigationTitle("7.1")
                            })
                        }
                        Section("8.0") {
                            NavigationLink("8.0", destination: {
                                WasIstNeu8_0()
                                    .navigationTitle("8.0")
                            })
                            NavigationLink("8.1") {
                                WasIstNeuView(title: "8.1", text: "Die Funktion Kopfrechnen unterstützt das Anzeigen der Schüler in zufälliger Reihenfolge: \nHierbei bekommt der Lehrer immer 2 Schüler auf seinem Bildschirm angezeigt und eine Aufgabe, die diese lösen müssen. Sobald einer der beiden Schüler die Aufgabe richtig löst, klickt der Lehrer den richtigen Schüler an, welcher dann eine Runde weiter ist. Der andere fliegt dann aus dem Spiel und kann erst im nächsten Spiel wieder mitmachen. Dies geht dann so lange weiter, bis dann am Ende nur noch 2 Schüler aus der Klasse im Spiel sind.")
                            }
                        }
                    }
                    .navigationTitle("Was ist neu?")
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
    
    private func makeEmailURL(subject: String, body: String) -> URL {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=leonsular@gmail.com&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=leon.sular@gmail.com&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:leon.sular@gmail.com?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        }
        
        return defaultUrl!
    }
}

struct SocialMedia: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .yellow, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 5)
                .padding(10)
            Text("Folgen Sie uns auf Instagram")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(10)
        }
    }
}

#Preview {
    TabBarOben()
}
