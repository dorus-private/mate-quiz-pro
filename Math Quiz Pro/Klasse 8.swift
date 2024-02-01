//
//  Klasse 8.swift
//  Math Quiz Pro
//
//  Created by Leon Șular on 14.07.23.
//

import SwiftUI

struct Klasse_8: View {
    @State var termeMitMehrerenVariablen = false
    @State var binomischeFormeln = false
    @State var formelnNachVarAuflösen = false
    @State var multiplitierenVSummen = false
    @State var quadratwurzeln = false
    
    @Environment(\.dismiss) var dismiss
    @State var step = 0
    @State var eingabe = "5"
    @State var gesammtAufgaben = 5
    @State private var task = ""
    @State var aufgaben = [""]
    @State var lösungen = [""]
    @State var lösung = ""
    @State var tasksGenerated = 0
    @State var showError1Alert = false
    
    var body: some View {
        ZStack {
            if step == 0 {
                List {
                    Section("I. Terme mit mehreren Variablen") {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.5)) {
                                termeMitMehrerenVariablen.toggle()
                            }
                        }, label: {
                            HStack {
                                Text("Terme mit mehreren Variablen vereinfachen")
                                if termeMitMehrerenVariablen {
                                    toggleTrue
                                } else {
                                    toggleFalse
                                }
                            }
                        })
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.5)) {
                                multiplitierenVSummen.toggle()
                            }
                        }, label: {
                            HStack {
                                Text("Multiplitieren von Summen")
                                if multiplitierenVSummen {
                                    toggleTrue
                                } else {
                                    toggleFalse
                                }
                            }
                        })
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.5)) {
                                binomischeFormeln.toggle()
                            }
                        }, label: {
                            HStack {
                                Text("Binomische Formeln")
                                if binomischeFormeln {
                                    toggleTrue
                                } else {
                                    toggleFalse
                                }
                            }
                        })
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.5)) {
                                formelnNachVarAuflösen.toggle()
                            }
                        }, label: {
                            HStack {
                                Text("Formeln nach Variablen auflösen")
                                if formelnNachVarAuflösen {
                                    toggleTrue
                                } else {
                                    toggleFalse
                                }
                            }
                        })
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
                .navigationTitle("Klasse 8")
            }
            
            VStack {
                if step == 1 {
                    Spacer()
                    Text("\(eingabe) Aufgaben")
                    Spacer()
                    KeyPad(string: $eingabe)
                    Spacer()
                    Text("Die Anzahl der Aufgaben muss über 5 oder 5 sein, sonst können Sie nicht weiter drücken")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .frame(width: 450)
                    Spacer()
                } else if step == 2 {
                    Spacer()
                    CounterView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                withAnimation(.easeIn(duration: 0.75)) {
                                    step += 1
                                }
                            }
                        }
                } else if step == 3 {
                    Spacer()
                    Text("\(task)")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    .onAppear() {
                        for i in 1...gesammtAufgaben + 10 {
                            generateTask()
                        }
                        task = aufgaben[0]
                        lösung = lösungen[0]
                        tasksGenerated = 0
                    }
                } else if step == 4 {
                    Spacer()
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
                        Text("Bei bestimmten Aufgaben wird Ihnen die Lösung der zugehörigen Aufgabe auf Ihr Display gezeigt. Die Schüler können diese auf dem externen Bildschirm nicht sehen.")
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(width: 20)
                    }
                } else if step == 5 {
                    Spacer()
                    Text("\(task)")
                        .font(.largeTitle)
                        .padding(20)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                HStack {
                    if step != 2 {
                        if step == 0 {
                            Spacer()
                                .frame(width: 20)
                            Button(action: {
                                dismiss()
                            }, label: {
                                Text("zurück")
                            })
                            Spacer()
                        }
                        Button(action: {
                            gesammtAufgaben = (Int(eingabe) ?? 5) + 2
                            if step == 3 {
                                if tasksGenerated != gesammtAufgaben - 3 {
                                    tasksGenerated += 1
                                    task = aufgaben[tasksGenerated]
                                } else {
                                    step += 1
                                    task = "Besprechen"
                                    tasksGenerated = 0
                                }
                            } else if step == 4 {
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
                                gesammtAufgaben = 0
                            } else if step == 5 {
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
                            } else {
                                step += 1
                            }
                        }, label: {
                            Text("weiter")
                                .foregroundColor(eingabe == "4" || eingabe == "3" || eingabe == "2" || eingabe == "1" || eingabe == "0" ? .gray : .accentColor)
                                .cornerRadius(15)
                                .ignoresSafeArea(.all)
                        })
                        .alert(isPresented: $showError1Alert, content: {
                            Alert(title: Text("Error (1)"), message: Text("Sie haben keinen Aufgabentyp ausgewählt \n Bitte wählen Sie einen oder mehrere Aufgabentypen aus"), dismissButton: .cancel(Text("Ok")) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    step = 0
                                }
                            })
                        })
                        .disabled(eingabe == "4" || eingabe == "3" || eingabe == "2" || eingabe == "1" || eingabe == "0")
                        .padding(20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
    
    var toggleTrue: some View {
        ZStack {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.green)
            }
            HStack {
                Spacer()
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.white)
            }
        }
        .shadow(radius: 5)
    }
    
    var toggleFalse: some View {
        ZStack {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.gray)
            }
            HStack {
                Spacer()
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.white)
                Spacer()
                    .frame(width: 55)
            }
        }
        .shadow(radius: 5)
    }
}

struct Klasse_8_Previews: PreviewProvider {
    static var previews: some View {
        Klasse_8()
    }
}

extension String {
    var superscripted: String {
        let superscriptMap: [Character: Character] = [
            "s": "²"
        ]
        return String(self.map { superscriptMap[$0] ?? $0 })
    }
}

struct CounterView: View {
    @State var startProgress = 0.0
    @State var startProgressText = 0
    @AppStorage("task") private var task = ""
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: startProgress)
                .stroke(
                    Color.pink,
                    // 1
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            Text("\(startProgressText)")
                .font(.largeTitle)
        }
        .padding(50)
        .onAppear() {
            task = "Counter"
            startProgressText = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.75)) {
                    startProgress = 0.33333
                    startProgressText = 2
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeIn(duration: 0.75)) {
                    startProgress = 0.66666
                    startProgressText = 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                withAnimation(.easeIn(duration: 0.75)) {
                    startProgress = 1.0
                    startProgressText = 0
                }
            }
        }
    }
}
