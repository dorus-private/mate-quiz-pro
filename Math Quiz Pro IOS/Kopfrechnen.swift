//
//  Kopfrechnen.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 23.02.24.
//

import SwiftUI

struct Kopfrechnen: View {
    // mathematical tasks
    @State var multiplikation = false
    @State var division = false
    @State var addition = false
    @State var subtraktion = false
    @State var automatisch = false
    
    //system setup
    @State var showAutomatischInfo = false
    @Environment(\.dismiss) var dismiss
    @State var step = 0
    @AppStorage("task") private var task = ""
    @State var lösung = ""
    @AppStorage("rolle") var rolle = 1
    @AppStorage("punkte", store: UserDefaults(suiteName: "group.PunkteMatheQuizPro")) var punkte = 1
    
    // Student class
    @State private var selectedClass = ""
    @ObservedObject var database = Database()
    @State private var studentsInClass9b: [Student] = []
    @State private var currentPair: [Student] = []
    @State private var nextRound: [Student] = []
    @State private var showWinner = false
    @State private var winner: Student?
    @State private var showNewRoundAlert = false
    @State private var isFirstRound = true
    
    var body: some View {
        ZStack {
            if step == 0 {
                List {
                    Section("") {
                        Toggle("Multiplikation", isOn: $multiplikation)
                        Toggle("Division", isOn: $division)
                        Toggle("Addition", isOn: $addition)
                        Toggle("Subtraktion", isOn: $subtraktion)
                    }
                    .disabled(automatisch)
                    HStack {
                        Toggle("Automatisch", isOn: $automatisch)
                            .onChange(of: automatisch) { newValue in
                                if automatisch {
                                    multiplikation = true
                                    division = true
                                    addition = true
                                    subtraktion = true
                                }
                            }
                    }
                }
                .tint(.blue)
            }
            VStack {
                if step == 2 {
                    Spacer()
                    if showWinner && selectedClass != "", let winner = winner {
                        Text("Der Sieger ist \(winner.name)")
                            .font(.largeTitle)
                            .padding()
                    } else if showNewRoundAlert && selectedClass != "" {
                        Text(isFirstRound ? "Spiel starten" : "Neue Runde starten!")
                            .font(.title2)
                            .padding()
                        
                        Button(action: {
                            showNewRoundAlert = false
                            startNextRound()
                            isFirstRound = false
                        }) {
                            Text(isFirstRound ? "Start" : "Runde starten")
                                .font(.title)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Text(task)
                            .font(.title)
                            .padding(20)
                        Text(lösung)
                            .font(.title2)
                    }
                    if selectedClass != ""  && showNewRoundAlert == false && showWinner == false {
                        if currentPair.count == 2 || currentPair.count == 3 {
                            Text("Drücken Sie auf den Schüler, der die Aufgabe richtig beantwortet hat")
                                .font(.title2)
                                .padding()
                            HStack {
                                ForEach(currentPair, id: \.id) { student in
                                    Button(action: {
                                        for cs in currentPair {
                                            if cs == student {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                    updateStudent(student: student, richtig: true, falsch: false, abwesend: false)
                                                }
                                            } else {
                                                updateStudent(student: student, richtig: false, falsch: true, abwesend: false)
                                            }
                                        }
                                        advanceStudent(student)
                                        generateTask()
                                    }) {
                                        Text(student.name)
                                            .font(.title)
                                            .padding()
                                            .background(Color.blue.opacity(0.7))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                } else if step == 1 {
                    SelectClass(selectedClass: $selectedClass)
                }
                Spacer()
                HStack {
                    Spacer()
                        .frame(width: 20)
                    Button(action: {
                        dismiss()
                    }, label: {
                        ZStack {
                            if step <= 1 {
                                Image(systemName: "arrow.left.square.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(rolle == 1 ? .white : .cyan)
                                    .shadow(radius: rolle == 1 ? 0 : 5)
                                    .cornerRadius(15)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 100, height: 50)
                                    .foregroundColor(.red)
                                Text("Stop")
                                    .foregroundStyle(.white)
                            }
                        }
                    })
                    if step != 2 || selectedClass == "" || showWinner {
                        Button(action: {
                            withAnimation {
                                if step == 0 {
                                    if multiplikation == true || division == true || addition == true || subtraktion == true || automatisch == true {
                                        step += 1
                                    }
                                } else if step == 1 {
                                    step += 1
                                    initializeGame()
                                } else if step == 2 && showWinner {
                                    initializeGame()
                                }
                                generateTask()
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                    .foregroundColor(multiplikation == true || division == true || addition == true || subtraktion == true || automatisch == true ? .blue : .gray)
                                if step == 1 {
                                    Text(selectedClass == "" ? "Keine Klasse wählen" : "Weiter")
                                        .foregroundStyle(.white)
                                } else if step == 2 && showWinner {
                                    Text("Neues Spiel starten")
                                        .foregroundStyle(.white)
                                } else {
                                    Text(step == 0 ? "Weiter" : "Nächste Aufgabe")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(20)
                        })
                        .disabled(multiplikation == true || division == true || addition == true || subtraktion == true || automatisch == true ? false : true)
                    } else {
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Kopfrechnen")
    }
    
    // Tasks logic
    func generateTask() {
        let randomInt = Int.random(in: 1...4)
        if randomInt == 1 {
            mal()
        } else if randomInt == 2 {
            geteilt()
        } else if randomInt == 3 {
            plus()
        } else {
            minus()
        }
        punkte += 2
    }
    
    func mal() {
        if multiplikation {
            let nummer1 = Int.random(in: 10...20)
            let nummer2 = Int.random(in: 6...10)
            task = "\(nummer1) * \(nummer2)"
            lösung = "\(nummer1 * nummer2)"
        } else {
            generateTask()
        }
    }
    
    func geteilt() {
        if division {
            let nummer1 = Int.random(in: 10...20)
            let nummer2 = Int.random(in: 6...10)
            task = "\(nummer1 * nummer2) : \(nummer2)"
            lösung = "\(nummer1)"
        } else {
            generateTask()
        }
    }
    
    func plus() {
        if addition {
            let nummer1 = Int.random(in: 51...500)
            let nummer2 = Int.random(in: 51...250)
            task = "\(nummer1) + \(nummer2)"
            lösung = "\(nummer1 + nummer2)"
        } else {
            generateTask()
        }
    }
    
    func minus() {
        if subtraktion {
            let nummer1 = Int.random(in: 51...500)
            let nummer2 = Int.random(in: 51...250)
            if nummer1 < nummer2 {
                task = "\(nummer2) - \(nummer1)"
                lösung = "\(nummer2 - nummer1)"
            } else {
                task = "\(nummer1) - \(nummer2)"
                lösung = "\(nummer1 - nummer2)"
            }
        } else {
            generateTask()
        }
    }
   
    // Students logic
    func initializeGame() {
        // Filtere Schüler der Klasse 9b und speichere sie in einer temporären Liste
        studentsInClass9b = []
        currentPair = []
        nextRound = []
        showWinner = false
        winner = nil
        showNewRoundAlert = false
        isFirstRound = true
        studentsInClass9b = database.students.filter { $0.klasse == selectedClass }
        studentsInClass9b.shuffle()
        showNewRoundAlert = true
    }
    
    func advanceStudent(_ student: Student) {
        // Füge den ausgewählten Schüler zur nächsten Runde hinzu
        nextRound.append(student)
        
        // Überprüfe, ob noch Schüler übrig sind, die gegeneinander antreten müssen
        if !studentsInClass9b.isEmpty {
            startNextRound()
        } else {
            // Überprüfe, ob wir den Sieger haben oder ob wir eine neue Runde starten müssen
            if nextRound.count == 1 {
                winner = nextRound.first
                showWinner = true
            } else if nextRound.count == 3 {
                // Drei Schüler sind übrig, zeige alle drei an
                currentPair = nextRound
                nextRound.removeAll()
            } else {
                // Setze für die nächste Runde die Schüler zurück
                studentsInClass9b = nextRound
                nextRound.removeAll()
                showNewRoundAlert = true
            }
        }
    }
    
    func startNextRound() {
        // Zeige das nächste Schülerpaar an oder alle drei Schüler, wenn nur noch drei übrig sind
        if studentsInClass9b.count == 3 {
            // Füge den letzten übrig gebliebenen Schüler hinzu
            currentPair = studentsInClass9b
            studentsInClass9b = []
        } else if studentsInClass9b.count >= 2 {
            currentPair = Array(studentsInClass9b.prefix(2))
            studentsInClass9b = Array(studentsInClass9b.dropFirst(2))
        } else if studentsInClass9b.count == 0 && nextRound.count == 3 {
            // Wenn genau drei Schüler übrig sind, zeige alle drei an
            currentPair = nextRound
            nextRound.removeAll()
        }
    }
    
    func updateStudent(student: Student, richtig: Bool, falsch: Bool, abwesend: Bool) {
        let sR = (Int(student.richtig) ?? 0)
        let sF = (Int(student.falsch) ?? 0)
        let sA = (Int(student.abwesend) ?? 0)
        if richtig {
            Database().updateStatus(for: student, richtig: "\(sR + 1)", falsch: "\(sF)", abwesend: "\(sA)")
        }
        if falsch {
            Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF + 1)", abwesend: "\(sA)")
        }
        if abwesend {
            Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF)", abwesend: "\(sA + 1)")
        }
    }
}

#Preview {
    Kopfrechnen()
}

struct KopfrechnenRunden: View {
    @ObservedObject var database = Database()
    @State private var studentsInClass9b: [Student] = []
    @State private var currentPair: [Student] = []
    @State private var nextRound: [Student] = []
    @State private var showWinner = false
    @State private var winner: Student?
    @State private var showNewRoundAlert = false
    @State private var isFirstRound = true
    
    var body: some View {
        VStack {
            if showWinner, let winner = winner {
                Text("Der Sieger ist \(winner.name)")
                    .font(.largeTitle)
                    .padding()
            } else if showNewRoundAlert {
                Text(isFirstRound ? "Spiel starten" : "Neue Runde starten!")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    showNewRoundAlert = false
                    startNextRound()
                    isFirstRound = false
                }) {
                    Text(isFirstRound ? "Start" : "Runde starten")
                        .font(.title)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else if currentPair.count == 2 || currentPair.count == 3 {
                Text("Wähle den Schüler, der die Aufgabe richtig beantwortet hat:")
                    .font(.title2)
                    .padding()
                HStack {
                    ForEach(currentPair, id: \.id) { student in
                        Button(action: {
                            advanceStudent(student)
                        }) {
                            Text(student.name)
                                .font(.title)
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear(perform: initializeGame)
    }
    
    func initializeGame() {
        // Filtere Schüler der Klasse 9b und speichere sie in einer temporären Liste
        studentsInClass9b = database.students.filter { $0.klasse == "9b" }
        studentsInClass9b.shuffle()
        showNewRoundAlert = true
    }
    
    func advanceStudent(_ student: Student) {
        // Füge den ausgewählten Schüler zur nächsten Runde hinzu
        nextRound.append(student)
        
        // Überprüfe, ob noch Schüler übrig sind, die gegeneinander antreten müssen
        if !studentsInClass9b.isEmpty {
            startNextRound()
        } else {
            // Überprüfe, ob wir den Sieger haben oder ob wir eine neue Runde starten müssen
            if nextRound.count == 1 {
                winner = nextRound.first
                showWinner = true
            } else if nextRound.count == 3 {
                // Drei Schüler sind übrig, zeige alle drei an
                currentPair = nextRound
                nextRound.removeAll()
            } else {
                // Setze für die nächste Runde die Schüler zurück
                studentsInClass9b = nextRound
                nextRound.removeAll()
                showNewRoundAlert = true
            }
        }
    }
    
    func startNextRound() {
        // Zeige das nächste Schülerpaar an oder alle drei Schüler, wenn nur noch drei übrig sind
        if studentsInClass9b.count == 3 {
            // Füge den letzten übrig gebliebenen Schüler hinzu
            currentPair = studentsInClass9b
            studentsInClass9b = []
        } else if studentsInClass9b.count >= 2 {
            currentPair = Array(studentsInClass9b.prefix(2))
            studentsInClass9b = Array(studentsInClass9b.dropFirst(2))
        } else if studentsInClass9b.count == 0 && nextRound.count == 3 {
            // Wenn genau drei Schüler übrig sind, zeige alle drei an
            currentPair = nextRound
            nextRound.removeAll()
        }
    }
}
