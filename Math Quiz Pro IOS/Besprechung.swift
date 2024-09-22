//
//  Besprechung.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 17.09.24.
//

import SwiftUI

struct BesprechungWarnung: View {
    @AppStorage("rolle") var rolle = 1
    
    var body: some View {
        VStack {
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
        }
    }
}
struct BesprechungAufgaben: View {
    @Binding var lösung: String
    @Binding var selectedClass: String
    @Binding var step: Int
    @Binding var gesammtAufgaben: Int
    @Binding var aufgaben: [String]
    @Binding var lösungen: [String]
    @Binding var tasksGenerated: Int
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("task") private var task = ""
    @AppStorage("falscheantwort!Überspringen") var falscheantwortÜberspringen = true
    @AppStorage("rolle") var rolle = 1
    @State var schüler = ""
    @State var student = Student(name: "Test", richtig: "0", falsch: "0", abwesend: "", klasse: "k", datum: "")
    
    var body: some View {
        VStack {
            Spacer()
            if lösung != "kL" {
                AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 20).attributedString, fontSize: 25)
                    .frame(height: 75)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                AttributedTextView(attributedString: TextBindingManager(string: "\(lösung)", hoch: 20).attributedString, fontSize: 50)
                    .frame(height: 100)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            } else {
                Text("Diese Aufgabe hat keine Lösung eingespeichert")
                    .font(.title)
                    .multilineTextAlignment(.center)
                AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 20).attributedString, fontSize: 50)
                    .frame(height: 100)
            }
            if selectedClass != "" {
                Spacer()
                    .onAppear {
                        getStudent()
                    }
                Text(schüler)
                    .font(.title)
                    .foregroundColor(rolle == 1 ? .white : .black)
                HStack {
                    Spacer()
                    Button(action: {
                        updateStudent(richtig: true, falsch: false, abwesend: false)
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                    })
                    Button(action: {
                        updateStudent(richtig: false, falsch: true, abwesend: false)
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.red)
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                    })
                    Button(action: {
                        updateStudent(richtig: false, falsch: false, abwesend: true)
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                            Image(systemName: "person.fill.xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                    })
                    Spacer()
                        .frame(width: 20)
                }
                Spacer()
            }
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
        letzterSchritt()
    }
    
    func falscheAntwortSchülerBekommen() {
        let name = student.name
        getStudent()
        if student.name == name {
            falscheAntwortSchülerBekommen()
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
}
