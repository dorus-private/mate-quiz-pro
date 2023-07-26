//
//  K8.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import SwiftUI

struct K8: View {
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
                            .background(Color.white)
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

extension String {
    var superscripted: String {
        let superscriptMap: [Character: Character] = [
            "2": "²"
        ]
        return String(self.map { superscriptMap[$0] ?? $0 })
    }
}


struct K8_Previews: PreviewProvider {
    static var previews: some View {
        K8()
    }
}
