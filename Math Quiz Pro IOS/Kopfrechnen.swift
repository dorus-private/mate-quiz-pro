//
//  Kopfrechnen.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 23.02.24.
//

import SwiftUI

struct Kopfrechnen: View {
    @State var multiplikation = false
    @State var division = false
    @State var addition = false
    @State var subtraktion = false
    @State var automatisch = false
    @State var showAutomatischInfo = false
    @Environment(\.dismiss) var dismiss
    @State var step = 0
    @AppStorage("task") private var task = ""
    @State var lösung = ""
    @State private var selectedClass = ""
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @AppStorage("rolle") var rolle = 1
    
    @State var showedStudent1: Student = Student(name: "", richtig: "", falsch: "", abwesend: "", klasse: "", datum: "")
    @State var showedStudent2: Student = Student(name: "", richtig: "", falsch: "", abwesend: "", klasse: "", datum: "")
    @State var showedStudent3: Student = Student(name: "", richtig: "", falsch: "", abwesend: "", klasse: "", datum: "")
    
    @State var students: [Student] = []
    @State var studentsWeiter: [Student] = []
    
    @AppStorage("punkte", store: UserDefaults(suiteName: "group.PunkteMatheQuizPro")) var punkte = 1
    
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
                    Text(task)
                        .font(.title)
                        .padding(20)
                    Text(lösung)
                        .font(.title2)
                    if selectedClass != "" {
                        Spacer()
                            .frame(height: 50)
                        HStack {
                            Text(showedStudent1.name)
                                .font(.title)
                                .padding(10)
                            Button(action: {
                                updateStudent(student: showedStudent1, richtig: true, falsch: false, abwesend: false)
                                updateStudent(student: showedStudent2, richtig: false, falsch: true, abwesend: false)
                                updateStudent(student: showedStudent3, richtig: false, falsch: true, abwesend: false)
                                generateTask()
                                showStudent()
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
                                updateStudent(student: showedStudent1, richtig: false, falsch: false, abwesend: true)
                                showedStudent1 = getStudent()
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
                        }
                        Text("gegen")
                            .font(.title2)
                        HStack {
                            Text(showedStudent2.name)
                                .font(.title)
                                .padding(10)
                            Button(action: {
                                updateStudent(student: showedStudent2, richtig: true, falsch: false, abwesend: false)
                                updateStudent(student: showedStudent1, richtig: false, falsch: true, abwesend: false)
                                updateStudent(student: showedStudent3, richtig: false, falsch: true, abwesend: false)
                                generateTask()
                                showStudent()
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
                                updateStudent(student: showedStudent2, richtig: false, falsch: false, abwesend: true)
                                showedStudent2 = getStudent()
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
                            if showedStudent3.name != "" {
                                Text("gegen")
                                    .font(.title2)
                                HStack {
                                    Text(showedStudent3.name)
                                        .font(.title)
                                        .padding(10)
                                    Button(action: {
                                        updateStudent(student: showedStudent3, richtig: true, falsch: false, abwesend: false)
                                        updateStudent(student: showedStudent1, richtig: false, falsch: true, abwesend: false)
                                        updateStudent(student: showedStudent2, richtig: false, falsch: true, abwesend: false)
                                        generateTask()
                                        showStudent()
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
                                        updateStudent(student: showedStudent3, richtig: false, falsch: false, abwesend: true)
                                        showedStudent3 = Student(name: "", richtig: "", falsch: "", abwesend: "", klasse: "", datum: "")
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
                                }
                            }
                        }
                    }
                } else if step == 1 {
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
                                    withAnimation {
                                        if selectedClass == klasse {
                                            selectedClass = ""
                                        } else {
                                            selectedClass = klasse
                                        }
                                    }
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
                    if step != 2 || selectedClass == "" {
                        Button(action: {
                            withAnimation {
                                if step == 0 {
                                    if multiplikation == true || division == true || addition == true || subtraktion == true || automatisch == true {
                                        step += 2 // wenn Klasse dazu kommt, dann auf 1 setzen
                                    }
                                } /*else if step == 1 {
                                    step += 1
                                    initialiseStudnts()
                                    showedStudent1 = getStudent()
                                    showedStudent2 = getStudent()
                                    print(students)
                                }*/
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
    
    func initialiseStudnts() {
        students = []
        studentsWeiter = []
        for s in Database().students {
            if s.klasse == selectedClass {
                students.append(s)
            }
        }
    }
    
    func getStudent() -> Student {
        if !students.isEmpty {
            let randomStudent = students.randomElement()!
            if let index = students.firstIndex(where: { $0.id == randomStudent.id }) {
                students.remove(at: index)
            }
            return randomStudent
        } else {
            if !students.isEmpty {
                let randomStudent = studentsWeiter.randomElement()!
                if let index = studentsWeiter.firstIndex(where: { $0.id == randomStudent.id }) {
                    studentsWeiter.remove(at: index)
                }
                return randomStudent
            } else {
                return Student(name: "", richtig: "", falsch: "", abwesend: "", klasse: "", datum: "")
            }
        }
    }
    
    func showStudent() {
        showedStudent1 = getStudent()
        showedStudent2 = getStudent()
        if students.count == 3 {
            showedStudent3 = getStudent()
        }
    }
    
    func updateStudent(student: Student, richtig: Bool, falsch: Bool, abwesend: Bool) {
        let sR = (Int(student.richtig) ?? 0)
        let sF = (Int(student.falsch) ?? 0)
        let sA = (Int(student.abwesend) ?? 0)
        if richtig {
            Database().updateStatus(for: student, richtig: "\(sR + 1)", falsch: "\(sF)", abwesend: "\(sA)")
            for s in Database().students {
                if s.name == student.name {
                    if !students.isEmpty {
                        studentsWeiter.append(s)
                    } else {
                        
                    }
                    break
                }
            }
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
