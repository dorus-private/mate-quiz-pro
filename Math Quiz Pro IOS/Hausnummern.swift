//
//  Hausnummern.swift
//  Math Quiz Pro
//
//  Created by Leon Șular on 01.04.24.
//

import SwiftUI
import EffectsLibrary

struct Hausnummern: View {
    @State var step = 0
    @AppStorage("rolle") var rolle = 1
    @Environment (\.dismiss) var dismiss
    @State private var selectedClass = ""
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @AppStorage("task") private var task = ""
    @State var lösung = 1
    @State var schüler: [String] = []
    @State var index = 0
    @State var UIIndex = 0
    @AppStorage("klassenKamerad") private var klassenKamerad = ""
    @AppStorage("StatusHausnummern") var statusHausnummern = ""
    @State var warning = false
    @AppStorage("actuallyView") var actuallyView = "Unterricht"
    @AppStorage("punkte", store: UserDefaults(suiteName: "group.PunkteMatheQuizPro")) var punkte = 1
    @AppStorage("händer") var händer = 1
    @AppStorage("statusFarbe") var statusFarbe = true
    @State var stateSchüler = ""
    @State var falscheSchülerListe: [String]  = []
    
    var step0: some View {
        VStack {
            Text("Willkommen beim Spiel Hausnummern")
                .font(.title)
                .padding(20)
            HStack {
                Spacer()
                    .frame(width: 20)
                Text("Regeln:")
                    .font(.title2)
                    .padding(.bottom, 10)
                Spacer()
            }
            Text("Die Schüler müssen nacheinander von 1 bis ins Unendliche zählen, doch hierbei gibt es mehrere Schwierigkeiten: \n1. Sie müssen die Zahlen, die eine 3 oder eine 7 enthalten überspringen \n2. Sie müssen die Zahlen, die durch 3 oder 7 teilbar sind auch überspringen \n \nSagt ein Schüler eine falsche Zahl, so fliegt er aus der Runde. \n \n \nFür die Reihenfolge werden Ihnen die Schüler auf Ihr Gerät und auf dem extern Bildschirm angezeigt, wenn Sie die Sitzordnung unter dem Tab \"Schüler\" konfiguriert haben. \n \nUm zu prüfen, ob die Schüler richtig antworten, sehen nur Sie auf Ihrem Bildschirm die Antwort.")
                .multilineTextAlignment(.leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            Spacer()
        }
    }
    
    var step1: some View {
        VStack {
            if klassenListe != [] {
                Spacer()
                    .frame(height: 20)
                Text("Bitte Wählen Sie eine Klasse aus")
                    .font(.title)
                    .padding(.horizontal, 20)
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
                .padding(20)
                Text("Versichern Sie sich, dass Sie einen Sitzplan für die ausgewählte Klasse erstellt haben")
                    .padding(.horizontal, 20)
            } else {
                Text("Bevor es weiter geht")
                    .font(.title)
                    .padding(20)
                Spacer()
                Text("Bitte gehen Sie zurück und öffnen Sie den Tab \"Schüler\" und konfigurieren Sie dort eine Klassenliste")
                    .padding(20)
                Spacer()
            }
        }
    }
    
    var step3: some View {
        ZStack {
            VStack {
                if schüler.count == 1 {
                    Spacer()
                        .onAppear {
                            task = "Ende"
                            klassenKamerad = schüler[0]
                        }
                } else {
                    Spacer()
                    if #available(iOS 16.0, *) {
                        Text("\(lösung)")
                            .font(.largeTitle)
                            .contentTransition(.numericText())
                    } else {
                        Text("\(lösung)")
                            .font(.largeTitle)
                    }
                    Text("\(klassenKamerad)")
                        .font(.title)
                        .padding(20)
                    if falscheSchülerListe.contains(klassenKamerad) {
                        Text("Achtung, dieser Schüler hatte in der letzten Runde möglicherweise die Aufgabe falsch beantwortet")
                            .foregroundStyle(.red)
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    if lösung != 1 {
                        Button(action: {
                            falscheSchülerListe.append(stateSchüler)
                            withAnimation(.easeInOut(duration: 0.25)) {
                                lösung = 1
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.red)
                                Text("Lösung zurücksetzen")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                        })
                        .frame(maxWidth: 200, maxHeight: 100)
                    }
                }
            }
            HStack {
                if händer == 1 {
                    Spacer()
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
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                if step == 0 {
                    step0
                } else if step == 1 {
                    step1
                } else if step == 2 {
                    CounterView(bigText: false)
                        .onAppear {
                            task = "Counter"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if !warning {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                        withAnimation(.easeIn(duration: 0.75)) {
                                            step += 1
                                            task = "Hausnummer"
                                        }
                                    }
                                }
                            }
                        }
                } else if step == 3 {
                    if task != "Ende" {
                        step3
                    } else {
                        ZStack {
                            FireworksView()
                            FireworksView()
                            VStack {
                                Text("Fertig")
                                    .font(.title)
                                    .padding(20)
                                Spacer()
                                Text("Der Sieger ist: \(schüler[0])")
                                    .font(.largeTitle)
                                Spacer()
                            }
                        }
                    }
                }
                HStack {
                    if step <= 1 || task == "Ende" {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "arrow.left.square.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(rolle == 1 ?  .white : .black)
                                .cornerRadius(15)
                        })
                        Button(action: {
                            if task == "Ende" && step == 3 {
                                step = 0
                                schüler = []
                                falscheSchülerListe = []
                                stateSchüler = ""
                            } else {
                                step += 1
                                if step == 2 {
                                    schüler = []
                                    var studentName = UserDefaults().string(forKey: "1 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "2 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "3 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "4 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "5 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "6 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "7 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "8 | 4, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    
                                    studentName = UserDefaults().string(forKey: "8 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "7 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "6 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "5 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "4 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "3 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "2 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "1 | 3, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    
                                    studentName = UserDefaults().string(forKey: "1 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "2 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "3 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "4 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "5 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "6 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "7 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "8 | 2, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    
                                    studentName = UserDefaults().string(forKey: "8 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "7 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "6 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "5 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "4 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "3 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "2 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    studentName = UserDefaults().string(forKey: "1 | 1, \(selectedClass)") ?? ""
                                    if studentName != "" {
                                        schüler.append(studentName)
                                    }
                                    
                                    for student in schüler {
                                        print(student)
                                    }
                                    
                                    if schüler != [] {
                                        klassenKamerad = schüler[0]
                                        punkte += 5
                                    } else {
                                        print("Warning!!!")
                                        warning = true
                                    }
                                }
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                    .foregroundColor(step == 1 && klassenListe == [] ? .gray : step == 1 && selectedClass == "" ? .gray : .blue)
                                if task == "Ende" && step == 3 {
                                    Text("Nochmal spielen")
                                        .foregroundStyle(.white)
                                } else {
                                    Text(step == 1 ? "Los geht's" : "Weiter")
                                        .foregroundStyle(.white)
                                }
                            }
                        })
                        .disabled(step == 1 && klassenListe == [] ? true : step == 1 && selectedClass == "" ? true : false)
                    }
                }
                .padding(20)
                .alert(isPresented: $warning) {
                    Alert(
                        title: Text("Error (2)"),
                        message: Text("Sie haben für die Klasse \(selectedClass) keine Sitzordnung konfiguriert"),
                        primaryButton: .cancel(
                            Text("Sitzordnung konfigurieren"),
                            action: {
                                dismiss()
                                actuallyView = "Schüler"
                            }
                        ),
                        secondaryButton: .default(
                            Text("Andere Klasse wählen"),
                            action: {
                                step = 1
                            }
                        )
                    )
                }
            }
            if warning {
                Color.black
                    .ignoresSafeArea(.all)
            }
        }
    }
    
    func zählen() {
        lösung += 1
        let lString = "\(lösung)"
        if lString.contains("3") || lString.contains("7") || lösung % 7 == 0 || lösung % 3 == 0 {
            zählen()
        }
    }
    
    func updateStudent(richtig: Bool, falsch: Bool, abwesend: Bool) {
        task = "Hausnummer"
        if schüler.count  != 1 {
            let studentIndex = schüler[index]
            if let student = Database().students.enumerated().first(where: {$0.element.name == studentIndex})?.element {
                let sR = (Int(student.richtig) ?? 0)
                let sF = (Int(student.falsch) ?? 0)
                let sA = (Int(student.abwesend) ?? 0)
                stateSchüler = student.name
                if richtig {
                    Database().updateStatus(for: student, richtig: "\(sR + 1)", falsch: "\(sF)", abwesend: "\(sA)")
                    if index < schüler.count - 1  {
                        index += 1
                    } else {
                        index = 0
                    }
                    zählen()
                    UIIndex = index
                    klassenKamerad = schüler[UIIndex]
                }
                if falsch {
                    withAnimation(.easeIn(duration: 0.25)) {
                        statusHausnummern = "f"
                    }
                    Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF + 1)", abwesend: "\(sA)")
                    if index == schüler.count - 1  {
                        index = 0
                        UIIndex = 0
                    }
                    schüler = schüler.filter(){$0 != student.name}
                    klassenKamerad = schüler[UIIndex]
                    lösung = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeOut(duration: 0.25)) {
                            statusHausnummern = ""
                        }
                    }
                }
                if abwesend {
                    Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF)", abwesend: "\(sA + 1)")
                    if index == schüler.count - 1  {
                        index = 0
                        UIIndex = 0
                    }
                    schüler = schüler.filter(){$0 != student.name}
                    klassenKamerad = schüler[UIIndex]
                }
            }
        } else {
            task = "Ende"
        }
    }
}

#Preview {
    Hausnummern()
}
