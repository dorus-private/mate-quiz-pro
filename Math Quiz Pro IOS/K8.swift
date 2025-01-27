//
//  K8.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import SwiftUI
import WidgetKit

struct K8: View {
    @State var termeMitMehrerenVariablen = false
    @State var binomischeFormeln = false
    @State var formelnNachVarAuflösen = false
    @State var multiplitierenVSummen = false
    @State var quadratwurzeln = false
    @ObservedObject var database = Database()
    
    @AppStorage("Klasse 8") var klasse8 = false
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
    @State private var selectedClass = ""
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @AppStorage("rolle") var rolle = 1
    @AppStorage("punkte", store: UserDefaults(suiteName: "group.PunkteMatheQuizPro")) var punkte = 1
    
    var body: some View {
        ZStack {
            if step == 0 {
                List {
                    Section("I. Terme mit mehreren Variablen") {
                        Toggle("Terme mit mehreren Variablen vereinfachen", isOn: $termeMitMehrerenVariablen)
                        Toggle("Multiplitieren von Summen", isOn: $multiplitierenVSummen)
                        Toggle("Binomische Formeln", isOn: $binomischeFormeln)
                        Toggle("Formeln nach Variablen auflösen", isOn: $formelnNachVarAuflösen)
                    }
                    Section("II. Wahrscheinlichkeiten") {
                        Text("Für dieses Thema gibt es momentan keine Aufgaben")
                    }
                    /*
                    Section("III. Reelle Zahlen") {
                        Toggle("Quadratwurzeln", isOn: $quadratwurzeln)
                    }
                     */
                }
                .tint(.blue)
                .navigationTitle(klasse8 ? "" : "Klasse 8")
            }
            
            VStack {
                if step == 1 {
                    AufgabenanzahlEinstellen(gesammtAufgaben: $gesammtAufgaben)
                } else if step == 2 {
                    SelectClass(selectedClass: $selectedClass)
                } else if step == 3 {
                    Spacer()
                    CounterView(bigText: false)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                withAnimation(.easeIn(duration: 0.75)) {
                                    step += 1
                                }
                            }
                        }
                } else if step == 4 {
                    Spacer()
                    if task.contains("rational_") {
                        
                    } else {
                        AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 20).attributedString, fontSize: 50)
                            .frame(height: 100)
                            .padding(.bottom, 10)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .onAppear() {
                                for i in 1...gesammtAufgaben + 10 {
                                    generateTask()
                                }
                                task = aufgaben[0]
                                lösung = lösungen[0]
                                tasksGenerated = 0
                            }
                    }
                } else if step == 5 {
                    BesprechungWarnung()
                } else if step == 6 {
                    BesprechungAufgaben(lösung: $lösung, selectedClass: $selectedClass, step: $step, gesammtAufgaben: $gesammtAufgaben, aufgaben: $aufgaben, lösungen: $lösungen, tasksGenerated: $tasksGenerated)
                }
                
                Spacer()
                if step == 2 {
                    Button("Keine Klasse wählen") {
                        step += 1
                        selectedClass = ""
                    }
                    .padding(10)
                }
                if selectedClass == "" || step != 6 {
                    HStack {
                        if step != 3 {
                            if step <= 2 {
                                Spacer()
                                    .frame(width: 20)
                                Button(action: {
                                    klasse8 = false
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
                                if step == 4 {
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
                                } else if step == 5 {
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
                                } else if step == 6 {
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
    }
    
    func termeMitMehrerenVariablenAufgaben() {
        task = ""
        let variables = ["x", "y", "z"]
        
        var taskComponents: [String] = []
        for _ in 1...3 {
            let variable = variables.randomElement()!
            let coefficient = Int.random(in: 1...10)
            taskComponents.append("\(coefficient)\(variable)")
        }
        
        for i in 0...taskComponents.count - 1 {
            if i == 0 {
                task = task + taskComponents[i] + " * "
            } else {
                let operatorVar = Int.random(in: 1...2)
                if i != taskComponents.count - 1 {
                    if operatorVar == 1 {
                        task = task + taskComponents[i] + " + "
                    } else {
                        task = task + taskComponents[i] + " - "
                    }
                } else {
                    task = task + taskComponents[i]
                }
            }
        }
        lösung = "kL"
        checkGeneratedTask()
    }

    func multiplitierenVSummenAufgabe() {
        let rI1 = Int.random(in: 1...15)
        let rI2 = Int.random(in: 5...10)
        
        let zwischenTask = "(a + \(rI1)) * (b - \(rI2))"
        let zwischenLösung = "ab + \(rI2)a + \(rI1)b - \(rI1 * rI2)"
        
        task = zwischenTask
        lösung = zwischenLösung
        checkGeneratedTask()
    }
    
    func binomischeFormelnAufgaben() {
        let binomischeFormel = Int.random(in: 1...3)
        let rI10 = Int.random(in: 2...20)
        
        if binomischeFormel == 1 {
            task = "(a + \(rI10))s".superscripted
            lösung = "as + \(2 * rI10)a + \(rI10 * rI10)".superscripted
        } else if binomischeFormel == 2 {
            task = "(a - \(rI10))s".superscripted
            lösung = "as - \(2 * rI10)a + \(rI10 * rI10)".superscripted
        } else {
            task = "(a + \(rI10)) * (a - \(rI10))"
            lösung = "as - \(rI10 * rI10)".superscripted
        }
        checkGeneratedTask()
    }
    
    func formelnNachVarAuflösenTask() {
        let formel = Int.random(in: 1...2)
            
        if formel == 1 {
            task = "Löse die Gleichung nach s auf \n v = s / t"
            lösung = "s = v * t"
        } else {
            task = "Löse die Gleichung nach t auf \n v = s / t"
            lösung = "t = s / v"
        }
        checkGeneratedTask()
    }
    
    func quadratwurzelnTask() {
        let rdI1 = Int.random(in: 5...20)
        let rdI2 = Int.random(in: 5...20)
        let rdITask = Int.random(in: 1...3)
        
        if rdITask == 1 {
            task = "√ aus \(rdI1)"
            lösung = ""
        }
    }
    
    func generateTask() {
        if binomischeFormeln {
            binomischeFormelnAufgaben()
        }
        if termeMitMehrerenVariablen {
            termeMitMehrerenVariablenAufgaben()
        }
        if formelnNachVarAuflösen {
            formelnNachVarAuflösenTask()
        }
        if multiplitierenVSummen {
            multiplitierenVSummenAufgabe()
        }
    }
    
    func checkGeneratedTask() {
        if tasksGenerated != gesammtAufgaben + 6 {
            aufgaben.append(task)
            lösungen.append(lösung)
            if tasksGenerated == 1 || tasksGenerated == 2 {
                aufgaben.removeAll()
                lösungen.removeAll()
            }
            tasksGenerated += 1
        }
    }
}

/*
struct K8: View {
    @State var exersices: [Exercise] = [BinomischeFormeln(active: false), TermeMitMehrerenVariablen(active: true)]
    @State var erstens = false
    @State var zweitens = false
    @State var termeMitMehrerenVariablen = false
    @State var binomischeFormeln = false
    @AppStorage("task") private var task = ""
    @State var aufgaben = [""]
    @State var startAufgaben = false
    @State var besprechung = false
    @State var aufgabeCounter = 0.0
    @State var aufgabenAnzahlUser = 5.0
    @State var anzahlEinstellen = false
    @State var eingabe = "5"
    @State var progress = 0.0
    @State var navigationTitle = "Klasse 8"
    @EnvironmentObject var externalDisplayContent: ExternalDisplayContent
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if startAufgaben == false {
                    if anzahlEinstellen == false {
                        Form {
                            Toggle("Terme mit mehreren Variablen vereinfachen", isOn: $termeMitMehrerenVariablen)
                            Toggle("Binomische Formeln", isOn: $binomischeFormeln)
                        }
                        List {
                            ForEach(exersices, content: { exercise in
                                Text(exercise.description)
                            })
                        }
                    } else {
                        Spacer()
                        Text("\(eingabe) Aufgaben")
                        Spacer()
                        KeyPad(string: $eingabe)
                        Spacer()
                        Text("Die Anzahl der Aufgaben muss über 5 sein, sonst können Sie nicht weiter drücken")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .frame(width: 450)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            navigationTitle = "Anzahl der Aufgaben einstellen"
                            progress = 0
                            withAnimation {
                                if anzahlEinstellen == false {
                                    anzahlEinstellen = true
                                } else {
                                    aufgabenAnzahlUser = Double(Int(eingabe) ?? 5)
                                    if aufgabenAnzahlUser > 4 {
                                        startAufgaben = true
                                        anzahlEinstellen = false
                                        repeatWithDelay(iterations: Int(aufgabenAnzahlUser), delay: 15) {_ in
                                            generateTask()
                                        }
                                    }
                                }
                            }
                        }, label: {
                            ZStack {
                                button
                                Text("Weiter")
                                    .foregroundColor(.white)
                            }
                        })
                        .disabled(termeMitMehrerenVariablen == false && binomischeFormeln == false || aufgabenAnzahlUser < 5)
                        Spacer()
                    }
                } else {
                    if besprechung == false {
                        ProgressView("", value: progress, total: aufgabenAnzahlUser)
                            .frame(width: geo.size.width - 30, height: 20)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        if task == "" {
                            Text("Besprechen Sie im nächsten Schritt die Aufgaben mit der gesammten Klasse")
                        }
                        Text(task)
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                    if besprechung {
                        Button(action: {
                            withAnimation {
                                navigationTitle = ""
                                if aufgabeCounter != aufgabenAnzahlUser + 1 {
                                    task = aufgaben[Int(aufgabeCounter)]
                                    aufgabeCounter += 1
                                    progress += 1
                                    if aufgabeCounter == 1 {
                                        navigationTitle = "Besprechung"
                                    } else {
                                        navigationTitle = "Besprechung Aufgabe \(Int(aufgabeCounter) - 1)"
                                    }
                                } else {
                                    aufgabeCounter = 0
                                    progress = 0
                                    besprechung = false
                                    startAufgaben = false
                                    task = ""
                                }
                            }
                        }, label: {
                            ZStack {
                                button
                                if task == "" {
                                    Text("Jetzt besprechen")
                                } else if aufgabeCounter == aufgabenAnzahlUser + 1 {
                                    Text("Fertig und zurück")
                                } else {
                                    Text("Weiter")
                                }
                            }
                            .foregroundColor(.white)
                        })
                    }
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
    
    var button: some View {
        HStack {
            Spacer()
                .frame(width: 10)
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(termeMitMehrerenVariablen == false && binomischeFormeln == false ? .gray : .blue)
                .frame(height: 50)
            Spacer()
                .frame(width: 10)
        }
    }
    
    func termeMitMehrerenVariablenAufgaben() {
        task = ""
        let variables = ["x", "y", "z"]
        
        var taskComponents: [String] = []
        for _ in 1...3 {
            let variable = variables.randomElement()!
            let coefficient = Int.random(in: 1...10)
            taskComponents.append("\(coefficient)\(variable)")
        }
        
        for i in 0...taskComponents.count - 1 {
            if i == 0 {
                task = task + taskComponents[i] + " * "
            } else {
                let operatorVar = Int.random(in: 1...2)
                if i != taskComponents.count - 1 {
                    if operatorVar == 1 {
                        task = task + taskComponents[i] + " + "
                    } else {
                        task = task + taskComponents[i] + " - "
                    }
                } else {
                    task = task + taskComponents[i]
                }
            }
        }
        aufgaben.append(task)
        print(task)
    }
    
    func binomischeFormelnAufgaben() {
        let binomischeFormel = Int.random(in: 1...3)
        if binomischeFormel == 1 {
            task = "(a + \(Int.random(in: 3...10)))2".superscripted
        } else if binomischeFormel == 2 {
            task = "(a - \(Int.random(in: 3...10)))2".superscripted
        } else {
            let rdNumber1 = Int.random(in: 2...20)
            task = "(a + \(rdNumber1)) * (a - \(rdNumber1))"
        }
        aufgaben.append(task)
    }
    
    func generateTask() {
        withAnimation {
            progress += 1
        }
        navigationTitle = "Aufgabe \(Int(progress))"
        if termeMitMehrerenVariablen == true && binomischeFormeln == true {
            let randomAufgabe = Int.random(in: 1...2)
            if randomAufgabe == 1 {
                termeMitMehrerenVariablenAufgaben()
            } else {
                binomischeFormelnAufgaben()
            }
        } else {
            if termeMitMehrerenVariablen {
                termeMitMehrerenVariablenAufgaben()
            }
            if binomischeFormeln {
                binomischeFormelnAufgaben()
            }
        }
    }
    
    private func repeatWithDelay(iterations: Int, delay: TimeInterval, action: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            for i in 0..<iterations {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * delay) {
                    action(i)
                    if i == iterations - 1 {
                        besprechung = true
                    }
                }
            }
        }
    }
}
*/

extension String {
    var superscripted: String {
        let superscriptMap: [Character: Character] = [
            "s": "²"
        ]
        return String(self.map { superscriptMap[$0] ?? $0 })
    }
}


struct K8_Previews: PreviewProvider {
    static var previews: some View {
        K8()
    }
}
