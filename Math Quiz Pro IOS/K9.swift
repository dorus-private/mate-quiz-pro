//
//  K9.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.11.23.
//

import SwiftUI
import AVKit
import WidgetKit

struct InfoAufgaben: View {
    @AppStorage("rolle") var rolle = 1
    
    var body: some View {
        VStack {
            Text("Info")
                .font(.title)
                .padding(20)
            if rolle == 1 {
                Text("I. Bitten Sie die Schüler im kommenden Schritt die Aufgaben auf ein Schmierblatt zu lösen")
                    .multilineTextAlignment(.leading)
                    .padding(20)
                Image(systemName: "pencil.and.list.clipboard")
                    .resizable()
                    .scaledToFit()
                Text("II. Später wird ein Bildschirm kommen, der Sie darauf hinweisen wird, dass die Besprechung demnächst statt finden wird")
                    .multilineTextAlignment(.leading)
                    .padding(20)
                Image(systemName: "bubble.left.and.exclamationmark.bubble.right")
                    .resizable()
                    .scaledToFit()
                Spacer()
                    .frame(height: 20)
            } else {
                Text("I. Nehme dir ein Schmierblatt und notiere darauf alle Antworten der Aufgaben")
                    .multilineTextAlignment(.leading)
                    .padding(20)
                Image(systemName: "pencil.and.list.clipboard")
                    .resizable()
                    .scaledToFit()
                Text("II. Später wirst du darauf hingewiesen, wenn du deine Aufgaben korrigieren kannst")
                    .multilineTextAlignment(.leading)
                    .padding(20)
                Image(systemName: "bubble.left.and.exclamationmark.bubble.right")
                    .resizable()
                    .scaledToFit()
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}

struct K9: View {
    @State var audioPlayer: AVAudioPlayer!
    
    @State var potenzenMitGanzenHochzahlen = false
    @State var potenzenMitGleichenGrundzahlen = false
    @State var potenzenMitGleichenHochzahlen = false
    @State var potenzierenVonPotenzen = false
    @State var rationaleHochzahlen = false
    @State var kongruenzSätze = false
    @State var ähnlichkeitsSätze = false
    @State var schreibweisefx = false
    @State var funktionswertePrüfen = false
    @State var potenzFunktionenMitNatürlichenHochzahlen = false
    @State var exponentialFunktion = false
    @State var satzDesPythagoras = false
    @ObservedObject var database = Database()
    
    @AppStorage("Klasse 9") var klasse9 = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var step = 0
    @State var gesammtAufgaben = 5
    @AppStorage("task") private var task = ""
    @State var aufgaben = [""]
    @State var lösungen = [""]
    @State var lösung = ""
    @State var tasksGenerated = 0
    @State var showError1Alert = false
    @State var exponentVorzeichen = "Positiv/Negativ"
    @State private var selectedClass = ""
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @State var schüler = ""
    @State var student = Student(name: "Test", richtig: "0", falsch: "0", abwesend: "", klasse: "k", datum: "")
    @AppStorage("rolle") var rolle = 1
    @AppStorage("falscheantwort!Überspringen") var falscheantwortÜberspringen = true
    @AppStorage("punkte", store: UserDefaults(suiteName: "group.PunkteMatheQuizPro")) var punkte = 1
    @AppStorage("händer") var händer = 1
    
    var body: some View {
        VStack {
            if step == 0 {
                List {
                    Section("I. Potenzen") {
                        VStack {
                            Toggle("Potenzen mit ganzen Hochzahlen", isOn: $potenzenMitGanzenHochzahlen)
                            if potenzenMitGanzenHochzahlen {
                                Menu(content: {
                                    Button("Positiv/Negativ") {
                                        exponentVorzeichen = "Positiv/Negativ"
                                    }
                                    Button("Negativ") {
                                        exponentVorzeichen = "Negativ"
                                    }
                                    Button("Positiv") {
                                        exponentVorzeichen = "Positiv"
                                    }
                                }, label: {
                                    HStack {
                                        Text("  ➜ Exponent ist:")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        Spacer()
                                        Text(exponentVorzeichen)
                                    }
                                })
                            }
                        }
                        Toggle("Potenzen mit gleichen Grundzahlen", isOn: $potenzenMitGleichenGrundzahlen)
                        Toggle("Potenzen mit gleichen Hochzahlen", isOn: $potenzenMitGleichenHochzahlen)
                        Toggle("Potenzieren von Potenzen", isOn: $potenzierenVonPotenzen)
                        // Toggle("Rationale Hochzahlen", isOn: $rationaleHochzahlen)
                    }
                    Section("II. Kongruenz und Ähnlichkeit") {
                        Toggle("Kongruenzsätze", isOn: $kongruenzSätze)
                        Toggle("Ähnlichkeitssätze", isOn: $ähnlichkeitsSätze)
                    }
                    Section("III. Potenzfunktionen und Exponentialfunktionen") {
                        Toggle("Die Schreibweise f(x)", isOn: $schreibweisefx)
                        Toggle("Prüfen, ob Funktionswerte äquivalent sind", isOn: $funktionswertePrüfen)
                        Toggle("Potenzfunktionen mit natürlichen Exponenten (erkennen)", isOn: $potenzFunktionenMitNatürlichenHochzahlen)
                        Toggle("Exponentialfunktionen erkennen und wichtige Punkte ablesen", isOn: $exponentialFunktion)
                    }
                    Section("IV. Berechnungen im rechtwinkligen Dreieck") {
                        Toggle("Der Satz des Pythagoras", isOn: $satzDesPythagoras)
                    }
                }
                .navigationTitle(klasse9 ? "" : "Klasse 9")
                .tint(.blue)
            }
            
            VStack {
                if step == 1 {
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
                } else if step == 2 {
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
                                    selectedClass = klasse
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
                } else if step == 3 {
                    InfoAufgaben()
                } else if step == 4 {
                    Spacer()
                    CounterView(bigText: false)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                withAnimation(.easeIn(duration: 0.75)) {
                                    step += 1
                                }
                            }
                        }
                } else if step == 5 {
                    Spacer()
                        .onAppear() {
                            for i in 1...gesammtAufgaben + 100 {
                                generateTask()
                            }
                            task = aufgaben[0]
                            lösung = lösungen[0]
                            tasksGenerated = 0
                        }
                    if task.contains("rational_") {
                        
                    } else if task == "sss" || task == "Ssw" || task == "sws" || task == "wsw" || task == "x2" || task == "x3" || task == "x4" || task == "2^x" || task == "5*2^x" || task == "4^x" || task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" {
                        if task == "x2" || task == "x3" || task == "x4" {
                            Text("Ordne das passende Kärtchen zur Abbildung zu")
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .padding(20)
                        } else if task == "2^x" || task == "5*2^x" || task == "4^x" {
                            Text("Bestimme die Exponentialfunktion")
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .padding(20)
                        } else if task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" {
                            Text("Nenne den Satz des Pythagoras aus diesem Dreieck")
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .padding(20)
                        } else {
                            Text("Bestimme den Kongruenzsatz")
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .padding(20)
                        }
                        Spacer()
                        HStack {
                            VStack {
                                Image(task)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth: 120, minHeight: 120)
                                    .cornerRadius(15)
                                    .padding(20)
                                if task == "x2" || task == "x3" || task == "x4" {
                                    Spacer()
                                }
                            }
                            VStack {
                                if task == "x2" || task == "x3" || task == "x4" {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(height: 50)
                                            .foregroundColor(.blue)
                                        Text("f(x) = x²")
                                            .foregroundStyle(rolle == 1 ? .white : .black)
                                    }
                                    .padding(20)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.green)
                                            .frame(height: 50)
                                        Text("f(x) = x³")
                                            .foregroundStyle(rolle == 1 ? .white : .black)
                                    }
                                    .padding(20)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.purple)
                                            .frame(height: 50)
                                        Text("f(x) = x⁴")
                                            .foregroundStyle(rolle == 1 ? .white : .black)
                                    }
                                    .padding(20)
                                    Spacer()
                                }
                            }
                        }
                    } else if task.contains("^") {
                        AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 20).attributedString, fontSize: 50)
                            .frame(height: 100)
                            .padding(.bottom, 10)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    } else {
                        Text(task)
                            .font(.title)
                    }
                } else if step == 6 {
                    Spacer()
                    if rolle == 1 {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                            .padding(20)
                        Text("Besprechen Sie im nächsten Schritt die Aufgaben mit der gesammten Klasse")
                            .font(.largeTitle)
                            .padding(20)
                            .multilineTextAlignment(.center)
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Die Schüler können die Lösungen der Aufgaben auf dem externen Bildschirm nicht sehen")
                                .multilineTextAlignment(.center)
                            Spacer()
                                .frame(width: 20)
                        }
                    } else {
                        Text("Kontrolliere deine Lösung")
                    }
                } else if step == 7 {
                    ZStack {
                        VStack {
                            Spacer()
                                .onAppear {
                                    if selectedClass != "" {
                                        getStudent()
                                    }
                                }
                            if lösung != "kL" {
                                if lösung == "sss" || lösung == "Ssw" || lösung == "sws" || lösung == "wsw" || task == "x2" || task == "x3" || task == "x4" || task == "2^x" || task == "5*2^x" || task == "4^x" || task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" {
                                    if task == "x2" || task == "x3" || task == "x4" {
                                        Text("Ordne das passende Kärtchen zur Abbildung zu")
                                            .multilineTextAlignment(.center)
                                            .font(.title)
                                            .padding(20)
                                    } else if task == "2^x" || task == "5*2^x" || task == "4^x" {
                                        Text("Bestimme die Exponentialfunktion")
                                            .multilineTextAlignment(.center)
                                            .font(.title)
                                            .padding(20)
                                    } else if task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" {
                                        Text("Nenne den Satz des Pythagoras aus diesem Dreieck")
                                            .multilineTextAlignment(.center)
                                            .font(.title)
                                            .padding(20)
                                    } else {
                                        Text("Bestimme den Kongruenzsatz")
                                            .multilineTextAlignment(.center)
                                            .font(.title)
                                            .padding(20)
                                    }
                                    Spacer()
                                    Image(task == "2^x" || task == "5*2^x" || task == "4^x" || task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" ? task : lösung)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 120, minHeight: 120)
                                        .cornerRadius(15)
                                        .padding(20)
                                    if task == "x2" || task == "x3" || task == "x4" {
                                        if task == "x2" {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .frame(width: 100, height: 50)
                                                    .foregroundColor(.blue)
                                                Text("f(x) = x²")
                                                    .foregroundStyle(rolle == 1 ? .white : .black)
                                            }
                                            .padding(20)
                                        } else if task == "x3" {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.green)
                                                    .frame(width: 100, height: 50)
                                                Text("f(x) = x³")
                                                    .foregroundStyle(rolle == 1 ? .white : .black)
                                            }
                                            .padding(20)
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.purple)
                                                    .frame(width: 100, height: 50)
                                                Text("f(x) = x⁴")
                                                    .foregroundStyle(rolle == 1 ? .white : .black)
                                            }
                                            .padding(20)
                                        }
                                    } else {
                                        Text(lösung)
                                            .padding(20)
                                            .font(.title)
                                    }
                                } else {
                                    if task.contains("^") {
                                        AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 20).attributedString, fontSize: 25)
                                            .frame(height: 75)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                        AttributedTextView(attributedString: TextBindingManager(string: "\(lösung)", hoch: 20).attributedString, fontSize: 50)
                                            .frame(height: 100)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                    } else {
                                        Text(task)
                                            .font(.headline)
                                        Spacer()
                                        Text("Lösung")
                                            .multilineTextAlignment(.center)
                                        Text(lösung)
                                            .font(.title)
                                    }
                                }
                            } else {
                                Text("Diese Aufgabe hat keine Lösung eingespeichert")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 20).attributedString, fontSize: 50)
                                    .frame(height: 100)
                            }
                            Spacer()
                        }
                        if selectedClass != "" {
                            HStack {
                                if händer == 1 {
                                    Spacer()
                                    Text(schüler)
                                        .font(.largeTitle)
                                        .foregroundStyle(.cyan)
                                } else {
                                    Spacer()
                                        .frame(width: 20)
                                }
                                VStack {
                                    Button(action: {
                                        updateStudent(richtig: true, falsch: false, abwesend: false)
                                    }, label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.green)
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.white)
                                        }
                                    })
                                    Button(action: {
                                        updateStudent(richtig: false, falsch: true, abwesend: false)
                                    }, label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.red)
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.white)
                                        }
                                    })
                                    Button(action: {
                                        updateStudent(richtig: false, falsch: false, abwesend: true)
                                    }, label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.gray)
                                            Image(systemName: "person.fill.xmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.white)
                                        }
                                    })
                                }
                                if händer == 1 {
                                    Spacer()
                                        .frame(width: 20)
                                } else {
                                    Text(schüler)
                                        .font(.largeTitle)
                                        .foregroundStyle(.cyan)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                if step != 0 {
                    Spacer()
                } else {
                    Spacer()
                        .frame(height: 10)
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        Text("Für mehr nach unten scrollen")
                    }
                }
                if step == 2 {
                    Button("Keine Klasse wählen") {
                        step += 1
                        selectedClass = ""
                    }
                    .padding(10)
                }
                if selectedClass == "" || step != 7 {
                    HStack {
                        if step != 4 {
                            if step <= 3 {
                                Spacer()
                                    .frame(width: 20)
                                Button(action: {
                                    klasse9 = false
                                    dismiss()
                                }, label: {
                                    Image(systemName: "arrow.left.square.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(rolle == 1 ? .white : .cyan)
                                        .shadow(radius: rolle == 1 ? 0 : 5)
                                        .cornerRadius(15)
                                })
                            }
                            Button(action: {
                                if step == 5 {
                                    if tasksGenerated != gesammtAufgaben - 3 {
                                        tasksGenerated += 1
                                        task = aufgaben[tasksGenerated]
                                        punkte += 1
                                        WidgetCenter.shared.reloadAllTimelines()
                                    } else {
                                        step += 1
                                        task = "Besprechen"
                                        tasksGenerated = 0
                                    }
                                } else if step == 1 {
                                    gesammtAufgaben += 2
                                    if klassenListe == [] || rolle == 2 {
                                        step += 2
                                    } else {
                                        step += 1
                                    }
                                } else if step == 6 {
                                    task = aufgaben[0]
                                    lösung = lösungen[0]
                                    step += 1
                                } else if step == 0 {
                                    generateTask()
                                    if task == "" {
                                        showError1Alert = true
                                    } else {
                                        step += 1
                                    }
                                    aufgaben.removeAll()
                                    lösungen.removeAll()
                                    task = ""
                                    lösung = ""
                                    task = ""
                                    gesammtAufgaben = 5
                                } else if step == 7 {
                                    letzterSchritt()
                                } else {
                                    step += 1
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 50)
                                    Text("Weiter")
                                        .foregroundColor(.white)
                                }
                                .padding(20)
                            })
                            .disabled(step == 2 && selectedClass == "")
                            .alert(isPresented: $showError1Alert, content: {
                                Alert(title: Text("Error (1)"), message: Text("Sie haben keinen Aufgabentyp ausgewählt \n Bitte wählen Sie einen oder mehrere Aufgabentypen aus"), dismissButton: .cancel(Text("Ok")) {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        step = 0
                                    }
                                })
                            })
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Load items from UserDefaults when the view appears
            klassenListe = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
            step = 0
            selectedClass = ""
        }
    }
    
    func letzterSchritt() {
        if tasksGenerated != gesammtAufgaben - 2 {
            if tasksGenerated == 0 {
                tasksGenerated += 1
            }
            tasksGenerated += 1
            task = aufgaben[tasksGenerated - 1]
            lösung = lösungen[tasksGenerated - 1]
        } else {
            withAnimation(.easeOut(duration: 0.5)) {
                step = 0
                tasksGenerated = 0
            }
        }
        if selectedClass != "" {
            getStudent()
        }
    }
    
    func getStudent() {
        let randomStudent = Database().students.randomElement()
        if randomStudent?.klasse == selectedClass {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if randomStudent?.datum != dateFormatter.string(from: Date()) || randomStudent?.abwesend == "0" {
                schüler = randomStudent?.name ?? ""
                student = randomStudent!
            } else {
                if student.richtig == "0" && student.falsch == "0" && student.abwesend == "0" {
                    schüler = randomStudent?.name ?? ""
                    student = randomStudent!
                }
                getStudent()
            }
        } else {
            getStudent()
        }
    }
    
    func updateStudent(richtig: Bool, falsch: Bool, abwesend: Bool) {
        let sR = (Int(student.richtig) ?? 0)
        let sF = (Int(student.falsch) ?? 0)
        let sA = (Int(student.abwesend) ?? 0)
        if richtig {
            Database().updateStatus(for: student, richtig: "\(sR + 1)", falsch: "\(sF)", abwesend: "\(sA)")
            letzterSchritt()
        }
        if falsch {
            Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF + 1)", abwesend: "\(sA)")
            if falscheantwortÜberspringen {
               falscheAntwortSchülerBekommen()
            }
        }
        if abwesend {
            Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF)", abwesend: "\(sA + 1)")
            if falscheantwortÜberspringen {
                falscheAntwortSchülerBekommen()
            }
        }
    }
    
    func falscheAntwortSchülerBekommen() {
        let name = student.name
        getStudent()
        if student.name == name {
            falscheAntwortSchülerBekommen()
        }
    }
    
    func potenzenMitGanzenHochzahlenAufgaben() {
        let x = Int.random(in: 5...25)
        if exponentVorzeichen == "Positiv/Negativ" {
            let pos = Int.random(in: 1...2)
            if pos == 1 {
                task = "\(x)\u{207B}s".superscripted
                lösung = "1/\(x * x)"
            } else {
                task = "\(x)s".superscripted
                lösung = "\(x * x)"
            }
        } else if exponentVorzeichen == "Positiv" {
            task = "\(x)s".superscripted
            lösung = "\(x * x)"
        } else {
            task = "\(x)\u{207B}s".superscripted
            lösung = "1/\(x * x)"
        }
        checkGeneratedTask()
    }
    
    func potenzenMitGleichenGrundzahlenAufgaben() {
        let x = Int.random(in: 1...25)
        let n1 = Int.random(in: 1...4)
        let n2 = Int.random(in: 1...5)
        
        task = "\(x)^\(n1) * \(x)^\(n2)"
        lösung = "\(x)^\(n1 + n2)"
        checkGeneratedTask()
    }
    
    func potenzenMitGleichenHochzahlenAufgaben() {
        let x1 = Int.random(in: 1...10)
        let x2 = Int.random(in: 1...10)
        let n = Int.random(in: 2...9)
        
        task = "\(x1)^\(n) * \(x2)^\(n)"
        lösung = "\(x1 * x2)^\(n)"
        checkGeneratedTask()
    }
    
    func potenzierenVnPotenzenAufgaben() {
        let b = Int.random(in: 3...9)
        task = "(\(b)"
        let n1 = Int.random(in: 2...10)
        let n2 = Int.random(in: 5...10)
        if n1 == 2 {
            task += "²)"
        } else if n1 == 3 {
            task += "³)"
        } else if n1 == 4 {
            task += "⁴)"
        } else if n1 == 5 {
            task += "⁵)"
        } else if n1 == 6 {
            task += "⁶)"
        } else if n1 == 7 {
            task += "⁷)"
        } else if n1 == 8 {
            task += "⁸)"
        } else if n1 == 9 {
            task += "⁹)"
        } else {
            task += "¹⁰)"
        }
        
        if n2 == 2 {
            task += "²"
        } else if n2 == 3 {
            task += "³"
        } else if n2 == 4 {
            task += "⁴"
        } else if n2 == 5 {
            task += "⁵"
        } else if n2 == 6 {
            task += "⁶"
        } else if n2 == 7 {
            task += "⁷"
        } else if n2 == 8 {
            task += "⁸"
        } else if n2 == 9 {
            task += "⁹"
        } else {
            task += "¹⁰"
        }
        
        let previewLösung = Array("\(n1 * n2)")
        lösung = "\(b)"
        if previewLösung[0] == "2" {
            lösung += "²"
        } else if previewLösung[0] == "3" {
            lösung += "³"
        } else if previewLösung[0] == "4" {
            lösung += "⁴"
        } else if previewLösung[0] == "5" {
            lösung += "⁵"
        } else if previewLösung[0] == "6" {
            lösung += "⁶"
        } else if previewLösung[0] == "7" {
            lösung += "⁷"
        } else if previewLösung[0] == "8" {
            lösung += "⁸"
        } else if previewLösung[0] == "9" {
            lösung += "⁹"
        } else {
            lösung += "¹"
        }
        
        if previewLösung[1] == "2" {
            lösung += "²"
        } else if previewLösung[1] == "3" {
            lösung += "³"
        } else if previewLösung[1] == "4" {
            lösung += "⁴"
        } else if previewLösung[1] == "5" {
            lösung += "⁵"
        } else if previewLösung[1] == "6" {
            lösung += "⁶"
        } else if previewLösung[1] == "7" {
            lösung += "⁷"
        } else if previewLösung[1] == "8" {
            lösung += "⁸"
        } else if previewLösung[1] == "9" {
            lösung += "⁹"
        } else if previewLösung[1] == "0" {
            lösung += "⁰"
        } else {
            lösung += "¹"
        }
        
        checkGeneratedTask()
    }
    
    func rationaleHochzahlenAufgaben() {
        var x = Int.random(in: 1...25)
        let n = Int.random(in: 1...5)
        if n == 1 {
            task = "rational_\(x * x) 0,50"
            task = "rational_\(x)"
        } else if n == 2 {
            x = Int.random(in: 2...5)
            task = "rational_\(x * x * x) 0,33"
            task = "rational_\(x)"
        } else if n == 3 {
            x = Int.random(in: 2...3)
            task = "rational_\(x * x * x * x) 0.0.25"
            task = "rational_\(x * x * x * x) 0.0.25"
        }
        checkGeneratedTask()
    }
    
    func kongruenzsätzeAufgaben() {
        let ks = Int.random(in: 1...4)
        
        switch ks {
        case 1:
            task = "sws"
            lösung = "sws"
        case 2:
            task = "wsw"
            lösung = "wsw"
        case 3:
            task = "Ssw"
            lösung = "Ssw"
        case 4:
            task = "sss"
            lösung = "sss"
        default:
            task = "sss"
            lösung = "sss"
        }
        checkGeneratedTask()
    }
    
    func ähnlichkeitsSätzeAufgaben() {
        let rS = Int.random(in: 1...2)
        
        if rS == 1 {
            task = "Nenne den Ähnlichkeitssatz mit den Winkeln für zwei Dreiecke"
            lösung = "Wenn 𝛼 = 𝛼', β = β' und γ = γ', dann sind zwei Dreiecke kongruent"
        } else {
            task = "Nenne den Ähnlichkeitssatz mit den Seitenverhältnissen für zwei Dreiecke"
            lösung = "Wenn 𝛼 = 𝛼', β = β' und γ = γ', dann gilt: a'/a = b'/b = c'/c"
        }
        checkGeneratedTask()
    }
    
    func schreibweisefxAufgaben() {
        let x = Int.random(in: 2...5)
        let a = Int.random(in: 2...5)
        let c = Int.random(in: 10...100)
        task = "Berechne den Wert für x = \(x) \nf(x) = \(a)x² + \(c)"
        lösung = "f(\(x)) = \(a * x * x + c)"
        checkGeneratedTask()
    }
    
    func funktionswertePrüfenAufgabe() {
        let x = Int.random(in: 2...5)
        let a = Int.random(in: 2...5)
        let c = Int.random(in: 10...100)
        let prüfen = Int.random(in: 1...2)
        if prüfen == 1 {
            task = "Prüfe, ob f(\(x)) = f(-\(x)) für folgende Funktion: \nf(x) = \(a)x² + \(c)"
            lösung = "Das ist richtig, denn: f(\(x)) = \(a * x * x + c); f(-\(x)) = \(a * x * x + c)"
        } else {
            task = "Prüfe, ob f(\(x)) = f(-\(x)) für folgende Funktion: \nf(x) = \(a)x³ + \(c)"
            lösung = "Das ist falsch, denn: f(\(x)) = \(a * x * x * x + c); f(-\(x)) = \(a * x * x + c)"
        }
        checkGeneratedTask()
    }
    
    func potenzFunktionenMitNatürlichenHochzahlenAufgaben() {
        let rF = Int.random(in: 1...3)
        switch rF {
        case 1:
            task = "x2"
            lösung = "x2"
        case 2:
            task = "x3"
            lösung = "x3"
        default:
            task = "x4"
            lösung = "x4"
        }
        checkGeneratedTask()
    }
    
    func exponentialFunktionAufgaben() {
        let rF = Int.random(in: 1...3)
        switch rF {
        case 1:
            task = "4^x"
            lösung = "f(x) = 4^x"
        case 2:
            task = "2^x"
            lösung = "f(x) = 2^x"
        default:
            task = "5*2^x"
            lösung = "f(x) = 5 * 2^x"
        }
        checkGeneratedTask()
    }
    
    func satzDesPythagorasAufgaben() {
        let rS = Int.random(in: 1...5)
        switch rS {
        case 1:
            task = "DEF"
            lösung = "e² + f² = d²"
        case 2:
            task = "GHI"
            lösung = "h² + i² = g²"
        case 3:
            task = "JKL"
            lösung = "k² + l² = j²"
        case 4:
            task = "MNO"
            lösung = "n² + o² = m²"
        default:
            task = "PQR"
            lösung = "q² + r² = p²"
        }
        checkGeneratedTask()
    }
    
    func generateTask() {
        if potenzenMitGanzenHochzahlen {
            potenzenMitGanzenHochzahlenAufgaben()
        }
        if potenzenMitGleichenGrundzahlen {
            potenzenMitGleichenGrundzahlenAufgaben()
        }
        if potenzenMitGleichenHochzahlen {
            potenzenMitGleichenHochzahlenAufgaben()
        }
        if potenzierenVonPotenzen {
            potenzierenVnPotenzenAufgaben()
        }
        if rationaleHochzahlen {
            rationaleHochzahlenAufgaben()
        }
        if kongruenzSätze {
            kongruenzsätzeAufgaben()
        }
        if ähnlichkeitsSätze {
            ähnlichkeitsSätzeAufgaben()
        }
        if schreibweisefx {
            schreibweisefxAufgaben()
        }
        if funktionswertePrüfen {
            funktionswertePrüfenAufgabe()
        }
        if potenzFunktionenMitNatürlichenHochzahlen {
            potenzFunktionenMitNatürlichenHochzahlenAufgaben()
        }
        if exponentialFunktion {
            exponentialFunktionAufgaben()
        }
        if satzDesPythagoras {
            satzDesPythagorasAufgaben()
        }
    }
    
    func checkGeneratedTask() {
        aufgaben.append(task)
        lösungen.append(lösung)
        if tasksGenerated == 1 || tasksGenerated == 2 {
            aufgaben.removeAll()
            lösungen.removeAll()
        }
        tasksGenerated += 1
    }
}

struct AttributedTextView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    
    let attributedString: NSAttributedString
    let fontSize: CGFloat

    init(attributedString: NSAttributedString, fontSize: CGFloat) {
        self.attributedString = attributedString
        self.fontSize = fontSize
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.attributedText = attributedString
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        if colorScheme == .dark {
            textView.textColor = .white
        } else {
            textView.textColor = .black
        }
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
        uiView.font = UIFont.systemFont(ofSize: fontSize)
        uiView.textAlignment = .center
        uiView.backgroundColor = .clear
        if colorScheme == .dark {
            uiView.textColor = .white
        } else {
            uiView.textColor = .black
        }
    }
}

class TextBindingManager: ObservableObject {
    @Published var string: String
    @Published var hoch: Int
    var attributedString: NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string)

        let pattern = #"\d+\^\d+"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))

        for match in matches {
            if match.numberOfRanges == 1 {
                let range = match.range
                mutableAttributedString.setAttributes([.font: UIFont.systemFont(ofSize: 5), .baselineOffset: hoch], range: NSRange(location: range.location + range.length - 1, length: 1))
            }
        }
        
        let finalString = NSMutableAttributedString(attributedString: mutableAttributedString)
        finalString.mutableString.replaceOccurrences(of: "^", with: "", options: [], range: NSRange(location: 0, length: finalString.length))

        return finalString
    }

    init(string: String, hoch: Int) {
        self.string = string
        self.hoch = hoch
    }
}
