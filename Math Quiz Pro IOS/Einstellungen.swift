//
//  Einstellungen.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 17.11.23.
//

import SwiftUI
import LocalAuthentication

class StudentStatus: Identifiable, Codable {
    var id = UUID()
    var status: String
    var datum: String
    var fach: String
    
    init(status: String, datum: String, fach: String) {
        self.status = status
        self.datum = datum
        self.fach = fach
    }
}

class Student2: Identifiable, Codable {
    var id = UUID()
    var name: String
    var klasse: String
    var status: [StudentStatus]
    var richtig = 0
    var falsch = 0
    var abwesend = 0
    
    init(name: String, klasse: String, status: [StudentStatus]) {
        self.name = name
        self.klasse = klasse
        self.status = status
        /*
        for stat in status {
            switch stat.status {
                case "r":
                    richtig += 1
                case "f":
                    falsch += 1
                case "a":
                    abwesend += 1
                default:
                    break
            }
        }
         */
    }
}

// Datenbankklasse
class Database2: ObservableObject {
    @Published var students: [Student2]
    
    init() {
        // Laden der gespeicherten Daten aus UserDefaults
        if let data = UserDefaults.standard.data(forKey: "students2"),
           let decodedStudents = try?JSONDecoder().decode([Student2].self, from: data) {
            self.students = decodedStudents
        } else {
            self.students = []
        }
    }
    
    func addStudent(student: Student) {
        students.append(Student2(name: student.name, klasse: student.klasse, status: [StudentStatus(status: "?", datum: datum(), fach: "Mathe")]))
        saveData()
    }
    
    func updateStatus(name: String, status: String) {
        var student2 = Student2(name: "", klasse: "", status: [StudentStatus(status: "", datum: "", fach: "")])
        for student in students {
            if student.name == name {
                student2 = student
                break
            }
        }
        if let index = students.firstIndex(where: { $0.id == student2.id }) {
            students[index].status.append(StudentStatus(status: status, datum: datum(), fach: "Mathe"))
            saveData()
        } else {
            print("cannot be updated")
        }
    }
    
    func getRandomStudentFromClass(className: String) -> Student2? {
        let filteredStudents = students.filter {$0.name.lowercased().contains(className.lowercased()) }
        return filteredStudents.randomElement()
    }
    
    func saveData() {
        // Speichern der Daten in UserDefaults
        if let encodedData = try? JSONEncoder().encode(students) {
            UserDefaults.standard.set(encodedData, forKey: "students2")
        }
    }
    
    func doesStudentExist(withName name: String) -> Bool {
        return students.contains { $0.name.lowercased() == name.lowercased() }
    }
    
    func moveStudents() {
        for student in Database().students {
            students.append(Student2(name: student.name, klasse: student.klasse, status: [StudentStatus(status: "richtig: \(student.richtig) \nfalsch: \(student.falsch) \nabwesend: \(student.abwesend)", datum: student.datum, fach: "Mathe")]))
        }
        saveData()
    }
    
    func datum() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: Date())
    }
}

// Schülerklasse
class Student: Identifiable, Codable {
    var id = UUID()
    var name: String
    var richtig: String
    var falsch: String
    var abwesend: String
    var klasse: String
    var datum: String
    
    init(name: String, richtig: String, falsch: String, abwesend: String, klasse: String, datum: String) {
        self.name = name
        self.richtig = richtig
        self.falsch = falsch
        self.abwesend = abwesend
        self.klasse = klasse
        self.datum = datum
    }
}

// Datenbankklasse
class Database: ObservableObject {
    @Published var students: [Student]
    @AppStorage("Exit") var Exit = true
    
    init() {
        // Laden der gespeicherten Daten aus UserDefaults
        if let data = UserDefaults.standard.data(forKey: "students"),
           let decodedStudents = try? JSONDecoder().decode([Student].self, from: data) {
            self.students = decodedStudents.sorted {$0.name < $1.name}
            saveData()
        } else {
            self.students = []
        }
    }

    func addStudent(student: Student) {
        students.append(student)
        saveData()
    }

    func updateStatus(for student: Student, richtig: String, falsch: String, abwesend: String) {
        Exit = true
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            for forStudent in students {
                if forStudent.name == student.name {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    students[index].datum = dateFormatter.string(from: Date())
                    students[index].falsch = falsch
                    students[index].richtig = richtig
                    students[index].abwesend = abwesend
                    print("update")
                    saveData()
                }
            }
        } else {
            print("cannot be updated")
        }
    }
    
    func getRandomStudentFromClass(className: String) -> Student? {
        let filteredStudents = students.filter {$0.name.lowercased().contains(className.lowercased()) }
        return filteredStudents.randomElement()
    }

    func saveData() {
        // Speichern der Daten in UserDefaults
        self.students = students.sorted {$0.name < $1.name}
        if let encodedData = try? JSONEncoder().encode(students) {
            UserDefaults.standard.set(encodedData, forKey: "students")
        }
    }
    
    func doesStudentExist(withName name: String) -> Bool {
        return students.contains { $0.name.lowercased() == name.lowercased() }
    }
}

struct Einstellungen: View {
    @AppStorage("rolle") var rolle = 1
    @AppStorage("motivExternerBildschirm") var motivExternerBildschirm = 1
    @StateObject var notificationManager = NotificationManager()
    @AppStorage("task") private var task = ""
    @AppStorage("Schülersperre") var schülersperre = true
    @AppStorage("falscheantwort!Überspringen") var falscheantwortÜberspringen = true
    @AppStorage("PunkteSammeln") var punkteSammeln = true
    @AppStorage("händer") var händer = 1
    @AppStorage("statusFarbe") var statusFarbe = true
    @AppStorage("schriftGrößeExternerBildschirm") var schriftgröße = 250.0
    @State var showSchriftgröße = false
    
    var body: some View {
        Form {
            Section("Mitteilungen") {
                if notificationManager.hasPermission {
                    HStack {
                        Text("Sie erhalte immer eine Pushbenachrichtigung, wenn der Entwickler ein neues Update veröffentlicht")
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.green)
                            .frame(width: 25, height: 25)
                    }
                } else {
                    VStack {
                        Text("Öffnen Sie die Einstellungen, um Pushbenachrichtigungen zu erhalten, um schneller auf dem neustem Stand zu sein")
                        Button("Einstellungen öffnen") {
                            Task{
                                await notificationManager.request()
                            }
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
            
            Section("Rolle") {
                Text("Die Rolle entscheidet nur für das Design der App")
                    .font(.caption)
                Picker(selection: $rolle, label: Text("Rolle")) {
                    Text("Lehrer").tag(1)
                    Text("Schüler").tag(2)
                }
            }
            
            Section("Design") {
                Picker(selection: $händer, label: Text("Wählen Sie aus, ob Sie ein Rechtshänder oder ein Linkshänder sind")) {
                    Text("Rechts").tag(1)
                    Text("Links").tag(2)
                }
                // Toggle("Hintergrundfarbe beim Antworten der Schüler ändern", isOn: $statusFarbe)
            }
            
            if rolle == 1 {
                Section("Schülereinstellungen") {
                    Toggle("Status der Schüler mit FaceID oder TouchID sperren", isOn: $schülersperre)
                    Toggle("Bei der Besprechungsrunde wird ein neuer Schüler ausgewählt, wenn der vorherige Schüler eine falsche Antwort gibt", isOn: $falscheantwortÜberspringen)
                }
                Section("Externer Bildschirm") {
                    Picker("Motiv auf dem Externen Bildschirm:", selection: $motivExternerBildschirm) {
                        Text("Smiley").tag(1)
                        Text("Uhr").tag(2)
                    }
                    Button("Schriftgröße für den Externen Bildschirm einstellen") {
                        task = "Dies ist ein langer Text, der zum einstellen der Textgröße auf dem Externen Bildschirm hilft"
                        showSchriftgröße.toggle()
                    }
                }
            } else {
                Section("Punkte") {
                    Toggle("Sammle Punkte für jede gelöste Aufgabe", isOn: $punkteSammeln)
                }
            }
        }
        .onAppear {
            task = ""
        }
        .sheet(isPresented: $showSchriftgröße) {
            VStack {
                Text("Textgröße für den Externen Bildschirm")
                    .font(.title)
                    .padding(20)
                Text("Versichern Sie sich, dass Sie die Bildschirm Synchronisierung aktiviert haben und Sie jetzt auf dem Externen Bildschirm schauen können")
                    .padding(20)
                Spacer()
                Slider(value: $schriftgröße, in: 25...500)
                    .padding(20)
                Text("Ihre Schriftgröße:")
                    .padding(10)
                Text("Aa")
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    task = ""
                    showSchriftgröße.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                        Text("Fertig")
                            .foregroundStyle(.white)
                    }
                    .frame(height: 50)
                })
                .padding(20)
            }
        }
    }
}

// ContentView
struct Schülereinstellungen: View {
    @ObservedObject var database = Database()
    @State private var studentName = ""
    @State private var studentLastName = ""
    @State private var studentStatus = ""
    @State private var studentKlasse = ""
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @State var klasseHinzufügen = false
    @State var klasseHinzufügenText = ""
    @State var schülerHinzufügen = false
    @State var statusInfo = false
    @State private var isUnlocked = false
    @Environment(\.scenePhase) var scenePhase
    let defaults = UserDefaults.standard
    @AppStorage("Exit") var Exit = true
    @State var resetAlert = false
    @AppStorage("rolle") var rolle = 1
    @StateObject var notificationManager = NotificationManager()
    @AppStorage("task") private var task = ""
    @AppStorage("Schülersperre") var schülersperre = true
    @FocusState var textFieldFocused: Bool
    
    var body: some View {
        Form {
            NavigationLink("Schülerstatus") {
                VStack {
                    if isUnlocked == true || checkAuthenticateAvability() == false {
                        p1
                    } else {
                        Text("Authentifizieren")
                            .font(.title)
                        Spacer()
                        Text("Entsperren Sie den Abschnitt \"Schüler\", umd die Daten Ihrer Schüler einzusehen")
                            .multilineTextAlignment(.center)
                            .padding(20)
                        Image(systemName: "lock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        Button(action: {
                            authenticate()
                        }, label: {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 50)
                                    Text("Entsperren")
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                    .frame(width: 20)
                            }
                        })
                        .onAppear {
                            authenticate()
                        }
                        .padding(20)
                        Spacer()
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .inactive {
                        isUnlocked = false
                    }
                }
            }
            Section("") {
                NavigationLink(destination: {
                    Sitzordnung()
                }, label: {
                    if UIDevice.current.userInterfaceIdiom == .pad  {
                        Text("Sitzordnung")
                    } else {
                        Text("Die Sitzordnung ist nur für das iPad verfügbar")
                    }
                })
                .disabled(UIDevice.current.userInterfaceIdiom == .phone)
            }
        }
        .navigationTitle("Schüler")
        .onAppear {
            // Load items from UserDefaults when the view appears
            klassenListe = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
        }
        .onAppear {
            task = ""
        }
    }
    
    var p1: some View {
        ZStack {
            List {
                ForEach(klassenListe, id: \.self) { klasse in
                    NavigationLink("\(klasse)") {
                        p2
                            .onAppear {
                                studentKlasse = klasse
                            }
                    }
                }
                .onDelete(perform: deleteKlasse)
            }
            .fullScreenCover(isPresented: $klasseHinzufügen) {
                NavigationView {
                    ZStack {
                        List {
                            TextField("Klasse", text: $klasseHinzufügenText)
                                .focused($textFieldFocused)
                                .onSubmit {
                                    klassenListe.append(klasseHinzufügenText)
                                    saveKlassenListToUserDefaults()
                                    klasseHinzufügen = false
                                }
                        }
                        .navigationBarItems(trailing:
                        Button("Abbrechen") {
                            klasseHinzufügen = false
                        }
                        )
                        .navigationTitle("Klasse Hinzufügen")
                        if klasseHinzufügenText != "" {
                            VStack {
                                Spacer()
                                Button(action: {
                                    klassenListe.append(klasseHinzufügenText)
                                    saveKlassenListToUserDefaults()
                                    klasseHinzufügen = false
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(height: 50)
                                        Text("Hinzufügen")
                                            .foregroundColor(.white)
                                    }
                                })
                                .padding(20)
                            }
                        }
                    }
                }
                .navigationViewStyle(.stack)
            }
            .navigationTitle("Klassen")
            .navigationBarItems(trailing:
            Button(action: {
                klasseHinzufügen = true
            }, label: {
                Image(systemName: "plus")
            })
            )
            if klassenListe == [] {
                Text("Tippen Sie auf das +, um eine Klasse hinzuzufügen")
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    @State var studentSort = 1
    
    var p2: some View {
        ZStack {
            VStack {
                /*
                if Exit {
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.yellow)
                        VStack {
                            Text("Es wird empfohlen die App einmal neuzustarten, um sicher zu gehen, dass die Daten Ihrer Schüler auf dem neusten Stand sind")
                                .multilineTextAlignment(.center)
                            Button("Jetzt neustarten") {
                                Exit = false
                                exit(0)
                            }
                            .foregroundColor(.red)
                        }
                        Spacer()
                            .frame(width: 20, height: 30)
                    }
                    Spacer()
                        .frame(height: 10)
                }
                 */
                List {
                    ForEach(database.students) { student in
                        if student.klasse == studentKlasse {
                            NavigationLink(destination: {
                                Form {
                                    Section("Letzte Änderung") {
                                        Text("Der Status wurde zuletzt am \(student.datum) geändert")
                                            .multilineTextAlignment(.center)
                                    }
                                    Section("Status") {
                                        if student.richtig == "0" && student.falsch == "0" && student.abwesend == "0" {
                                            HStack {
                                                Text("Kein Status")
                                                Spacer()
                                                Image(systemName: "questionmark")
                                                    .foregroundColor(.yellow)
                                            }
                                        } else {
                                            if student.richtig != "0" {
                                                HStack {
                                                    Text("Richtige Antworten")
                                                    Spacer()
                                                    Text("\(student.richtig)")
                                                    Image(systemName: "checkmark.circle")
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            if student.falsch != "0" {
                                                HStack {
                                                    Text("Falsche Antworten")
                                                    Spacer()
                                                    Text("\(student.falsch)")
                                                    Image(systemName: "xmark.circle")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                            if student.abwesend != "0" {
                                                HStack {
                                                    Text("Abwesende Stunden")
                                                    Spacer()
                                                    Text("\(student.abwesend)")
                                                    Image(systemName: "person.fill.xmark")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                        }
                                    }
                                }
                                .navigationBarItems(trailing:
                                                        Button(action: {
                                    statusInfo = true
                                }, label: {
                                    Image(systemName: "info.circle")
                                })
                                )
                                .navigationTitle(student.name)
                            }, label: {
                                HStack {
                                    Text(student.name)
                                    Spacer()
                                    if student.richtig == "0" && student.falsch == "0" && student.abwesend == "0" {
                                        Image(systemName: "questionmark")
                                            .foregroundColor(.yellow)
                                    } else {
                                        if student.richtig != "0" {
                                            Text("\(student.richtig)")
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.green)
                                        }
                                        if student.falsch != "0" {
                                            Text("\(student.falsch)")
                                            Image(systemName: "xmark.circle")
                                                .foregroundColor(.red)
                                        }
                                        if student.abwesend != "0" {
                                            Text("\(student.abwesend)")
                                            Image(systemName: "person.fill.xmark")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            })
                        }
                    }
                    .onDelete(perform: deleteStudent)
                }
                HStack {
                    Spacer()
                    Button("Status reseten") {
                        resetAlert = true
                    }
                    .foregroundStyle(.red)
                    Spacer()
                        .frame(width: 20)
                }
                .alert("Sind Sie sich sicher, dass Sie den Status aller Schüler der Klasse \(studentKlasse) zurücksetzen wollen?", isPresented: $resetAlert) {
                    Button("Abbrechen", role: .cancel) {
                        resetAlert = false
                    }
                    Button("Zurücksetzen", role: .destructive) {
                        for student in database.students {
                            if student.klasse == studentKlasse {
                                database.updateStatus(for: student, richtig: "0", falsch: "0", abwesend: "0")
                            }
                        }
                        resetAlert = false
                    }
                }
                .fullScreenCover(isPresented: $schülerHinzufügen) {
                    NavigationView {
                        ZStack {
                            List {
                                VStack {
                                    TextField("Name", text: $studentName)
                                        .onSubmit {
                                            addStudentButton()
                                        }
                                    if database.doesStudentExist(withName: "\(studentName) \(studentLastName)") {
                                        HStack {
                                            Text("Dieser Schüler existiert bereits schon")
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.red)
                                            Spacer()
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                Section("") {
                                    TextField("Nachname (optional)", text: $studentLastName)
                                        .onSubmit {
                                            addStudentButton()
                                        }
                                }
                                
                            }
                            .navigationBarItems(trailing:
                                                    Button("Abbrechen") {
                                schülerHinzufügen = false
                            }
                            )
                            .navigationTitle("Schüler hinzufügen")
                            VStack {
                                Spacer()
                                if !database.doesStudentExist(withName: "\(studentName) \(studentLastName)") && studentName != "" {
                                    Button(action: {
                                        addStudentButton()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(height: 50)
                                            Text("Hinzufügen")
                                                .foregroundColor(.white)
                                        }
                                    })
                                    .padding(20)
                                }
                            }
                        }
                    }
                    .navigationViewStyle(.stack)
                }
            }
            if database.students.isEmpty {
                Text("Tippen Sie auf das +, um einen Schüler hinzuzufügen")
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Schüler von \(studentKlasse)")
        .navigationBarItems(trailing:
        HStack {
            EditButton()
            Button(action: {
                schülerHinzufügen = true
            }, label: {
                Image(systemName: "plus")
            })
        }
        )
        .fullScreenCover(isPresented: $statusInfo) {
            NavigationView {
                ZStack {
                    Form {
                        Section("") {
                            HStack {
                                Text("Der Schüler wurde noch nicht vom Programm drangenommen")
                                Spacer()
                                Image(systemName: "questionmark")
                                    .foregroundColor(.yellow)
                            }
                        }
                        Section("") {
                            HStack {
                                Text("Der Schüler war bei der letzten Anwesenheit abwesend")
                                Spacer()
                                Image(systemName: "person.fill.xmark")
                                    .foregroundColor(.gray)
                            }
                        }
                        Section("") {
                            HStack {
                                Text("Der Schüler hatte x Aufgaben richtig beantwortet")
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                            }
                        }
                        Section("") {
                            HStack {
                                Text("Der Schüler hatte x Aufgaben falsch beantwortet")
                                Spacer()
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .navigationTitle("Status Info")
                    VStack {
                        Spacer()
                        Button(action: {
                            statusInfo = false
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                Text("Fertig")
                                    .foregroundColor(.white)
                            }
                        })
                        .padding(20)
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
    
    private func deleteKlasse(at offsets: IndexSet) {
            klassenListe.remove(atOffsets: offsets)
            saveKlassenListToUserDefaults()
    }
    
    private func saveKlassenListToUserDefaults() {
        UserDefaults.standard.set(klassenListe, forKey: "Klassen")
    }
    
    func deleteStudent(at offsets: IndexSet) {
        database.students.remove(atOffsets: offsets)
        database.saveData()
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && schülersperre == true {
            // it's possible, so go ahead and use it
            let reason = "Authentifizieren Sie sich, um die Daten Ihrer Schüler zu bearbeiten"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                } else {
                    isUnlocked = false
                    authenticate()
                }
            }
        } else {
            isUnlocked = true
        }
    }
    
    func checkAuthenticateAvability() -> Bool {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }
    
    func addStudentButton() {
        if !database.doesStudentExist(withName: "\(studentName) \(studentLastName)") {
            studentStatus = "?"
            studentName = "\(studentName) \(studentLastName)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let newStudent = Student(name: studentName, richtig: "0", falsch: "0", abwesend: "0", klasse: studentKlasse, datum: dateFormatter.string(from: Date()))
            database.addStudent(student: newStudent)
            studentName = ""
            studentLastName = ""
            schülerHinzufügen = false
        }
    }
}
