//
//  K9.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.11.23.
//

import SwiftUI
import AVKit

struct K9: View {
    @State var audioPlayer: AVAudioPlayer!
    
    @State var potenzenMitGanzenHochzahlen = false
    @State var potenzenMitGleichenGrundzahlen = false
    @State var potenzenMitGleichenHochzahlen = false
    @State var potenzierenVonPotenzen = false
    @State var rationaleHochzahlen = false
    @ObservedObject var database = Database()
    
    @AppStorage("Klasse 9") var klasse9 = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var step = 0
    @State var eingabe = "5"
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
    
    var body: some View {
        ZStack {
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
                        /*Toggle("Potenzieren von Potenzen", isOn: $potenzierenVonPotenzen)
                            .disabled(true)
                            .foregroundColor(.gray)
                         */
                        // Toggle("Rationale Hochzahlen", isOn: $rationaleHochzahlen)
                    }
                    .tint(.blue)
                    Section("II. Kongruenz und Ähnlichkeit") {
                        Text("Für dieses Thema gibt es momentan keine Aufgaben")
                    }
                    Section("III. Potenzfunktionen und Exponentialfunktionen") {
                        Text("Für dieses Thema gibt es momentan keine Aufgaben")
                    }
                }
                .navigationTitle(klasse9 ? "" : "Klasse 9")
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
                    Spacer()
                    CounterView()
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
                        Text("Die Schüler können die Lösungen der Aufgaben auf dem externen Bildschirm nicht sehen")
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(width: 20)
                    }
                } else if step == 6 {
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
                            .foregroundColor(.white)
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
                            if step == 0 {
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
                                        .foregroundColor(.gray)
                                        .cornerRadius(15)
                                })
                            }
                            Button(action: {
                                gesammtAufgaben = (Int(eingabe) ?? 5) + 2
                                if step == 4 {
                                    if tasksGenerated != gesammtAufgaben - 3 {
                                        tasksGenerated += 1
                                        task = aufgaben[tasksGenerated]
                                    } else {
                                        step += 1
                                        task = "Besprechen"
                                        tasksGenerated = 0
                                    }
                                } else if step == 1 {
                                    if klassenListe == [] {
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
                                    gesammtAufgaben = 0
                                } else if step == 6 {
                                    letzterSchritt()
                                } else {
                                    step += 1
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 50)
                                        .foregroundColor(eingabe == "4" || eingabe == "3" || eingabe == "2" || eingabe == "1" || eingabe == "0" || step == 2 && selectedClass == "" ? .gray : .accentColor)
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
                            .disabled(eingabe == "4" || eingabe == "3" || eingabe == "2" || eingabe == "1" || eingabe == "0")
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
        }
        if falsch {
            Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF + 1)", abwesend: "\(sA)")
        }
        if abwesend {
            Database().updateStatus(for: student, richtig: "\(sR)", falsch: "\(sF)", abwesend: "\(sA + 1)")
        }
        letzterSchritt()
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
        task = "?"
        lösung = "?"
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
