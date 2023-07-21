//
//  Klasse 8.swift
//  Math Quiz Pro
//
//  Created by Leon Șular on 14.07.23.
//

import SwiftUI

struct K: View {
    @State private var task = ""
    @State private var userInput = ""
    @State private var showResult = false
    @State private var result = ""
    
    var body: some View {
        VStack {
            Text("Vereinfache den Term:")
                .font(.headline)
                .padding()
            
            Text(task)
                .font(.title)
                .padding()
            
            Button(action: {
                checkAnswer()
            }) {
                Text("Überprüfen")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            if showResult {
                Text(result)
                    .font(.title)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                generateTask()
            }) {
                Text("Nächste Aufgabe")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: {
            generateTask()
        })
    }
    
    func generateTask() {
        task = ""
        let variables = ["x", "y", "z"]
        let numVariables = Int.random(in: 2...3)
        
        var taskComponents: [String] = []
        for _ in 1...numVariables {
            let variable = variables.randomElement()!
            let coefficient = Int.random(in: 1...10)
            taskComponents.append("\(coefficient)\(variable)")
        }
        
        for i in 0...taskComponents.count - 1 {
            let operatorVar = Int.random(in: 1...4)
            if i != taskComponents.count - 1 {
                if operatorVar == 1 {
                    task = task + taskComponents[i] + " + "
                } else if operatorVar == 2 {
                    task = task + taskComponents[i] + " - "
                } else {
                    task = task + taskComponents[i] + " * "
                }
            } else {
                task = task + taskComponents[i]
            }
        }
        showResult = false
        result = ""
    }
    
    func checkAnswer() {
        // Implementiere hier deine eigene Logik zur Vereinfachung des Benutzerterms
        // Vergleiche den vereinfachten Benutzerterm mit dem vereinfachten ursprünglichen Term
        // Setze showResult auf true und result auf das Ergebnis der Überprüfung
        
        // Beispiellogik zur Vereinfachung: Einfache Ausgabe des Benutzerterms
        result = "Vereinfachter Term: \(userInput)"
        showResult = true
    }
}


struct Thema: Identifiable {
    var thema: String
    var ausgewählt: Bool
    var id = UUID()
}

struct Klasse_8: View {
    @State var erstens = false
    @State var zweitens = false
    @State var termeMitMehrerenVariablen = false
    @State var binomischeFormeln = false
    @State private var task = ""
    @State var aufgaben = [""]
    @State var startAufgaben = false
    @State var besprechung = false
    @State var aufgabeCounter = 0.0
    @State var aufgabenAnzahlUser = 5.0
    @State var anzahlEinstellen = false
    @State var eingabe = "5"
    @State var progress = 0.0
    @State var navigationTitle = "Klasse 8"
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if startAufgaben == false {
                    if anzahlEinstellen == false {
                        Form {
                            Button(action: {
                                withAnimation {
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
                                withAnimation {
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
                        Button("Weiter") {
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
                        }
                        .frame(height: 110)
                        Spacer()
                    }
                } else {
                    if besprechung == false {
                        ZStack {
                            VStack {
                                Spacer()
                                    .frame(height: 7.5)
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: geo.size.width, height: 55)
                                    .foregroundColor(.blue)
                            }
                            ProgressView("", value: progress, total: aufgabenAnzahlUser)
                                .frame(width: geo.size.width - 30)
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        if task == "" {
                            Text("Besprechen Sie im nächsten Schritt die Aufgaben mit der gesammten Klasse")
                        }
                        Text(task)
                            .font(.system(size: 225))
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
                                }
                            }
                        }, label: {
                            if task == "" {
                                Text("Jetzt besprechen")
                            } else if aufgabeCounter == aufgabenAnzahlUser + 1 {
                                Text("Fertig und zurück")
                            } else {
                                Text("Weiter")
                            }
                        })
                    }
                }
            }
            .navigationTitle(navigationTitle)
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
    
    func termeMitMehrerenVariablenAufgaben() {
        task = ""
        let variables = ["x", "y", "z"]
        let numVariables = Int.random(in: 2...3)
        
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

struct Klasse_8_Previews: PreviewProvider {
    static var previews: some View {
        Klasse_8()
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
