//
//  Sitzordnung.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 16.12.23.
//

import SwiftUI
import TipKit

struct ShareSheet: UIViewControllerRepresentable {
    var itemsToShare: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}

// Define your tip's content.
struct TischTip: Tip {
    var id: String
    
    var title: Text {
        Text("Sitzordnung")
    }
    
    var message: Text? {
        Text("Tippen Sie auf ein Kästchen, um ein Schüler hinzuzufügen \nTippen Sie auf den Pult, um den Pult zu verschieben")
    }
    
    var image: Image? {
        Image(systemName: "chair")
    }
}

struct Sitzordnung: View {
    @State private var klassenListe: [String] = UserDefaults.standard.stringArray(forKey: "Klassen") ?? []
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0
    var tischTip =  TischTip(id: "tisch")
    @State var shareImage = false
    @State var image = UIImage(systemName: "")
    let defaults = UserDefaults.standard
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var pultPos = ""
    
    var body: some View {
        List {
            ForEach(klassenListe, id: \.self) { klasse in
                NavigationLink(destination: {
                    GeometryReader { geo in
                        VStack {
                            if #available(iOS 17.0, *) {
                                TipView(tischTip, arrowEdge: .none)
                                    .padding(.horizontal, 20)
                            }
                            if geo.size.width < geo.size.height {
                                RotateDevice(verticalDrehen: false)
                            } else {
                                HStack {
                                    Spacer()
                                        .frame(width: 10)
                                    Tisch(width: width, height: height, h: 1, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 2, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 3, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 4, p: 1, klasse: klasse)
                                    Spacer()
                                    Tisch(width: width, height: height, h: 5, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 6, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 7, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 8, p: 1, klasse: klasse)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                .onAppear {
                                    if geo.size.width < geo.size.height {
                                        width = geo.size.height / 7
                                        height = geo.size.width / 9
                                    } else {
                                        width = geo.size.width / 9
                                        height = geo.size.height / 7
                                    }
                                }
                                Spacer()
                                    .frame(height: 5)
                                HStack {
                                    Spacer()
                                        .frame(width: 10)
                                    Tisch(width: width, height: height, h: 1, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 2, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 3, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 4, p: 2, klasse: klasse)
                                    Spacer()
                                    Tisch(width: width, height: height, h: 5, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 6, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 7, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 8, p: 2, klasse: klasse)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                Spacer()
                                    .frame(height: 5)
                                HStack {
                                    Spacer()
                                        .frame(width: 10)
                                    Tisch(width: width, height: height, h: 1, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 2, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 3, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 4, p: 3, klasse: klasse)
                                    Spacer()
                                    Tisch(width: width, height: height, h: 5, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 6, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 7, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 8, p: 3, klasse: klasse)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                Spacer()
                                    .frame(height: 5)
                                HStack {
                                    Spacer()
                                        .frame(width: 10)
                                    Tisch(width: width, height: height, h: 1, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 2, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 3, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 4, p: 4, klasse: klasse)
                                    Spacer()
                                    Tisch(width: width, height: height, h: 5, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 6, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 7, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 5)
                                    Tisch(width: width, height: height, h: 8, p: 4, klasse: klasse)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                Spacer()
                                Menu(content: {
                                    Button("links positionieren") {
                                        defaults.set("l", forKey: "position \(klasse)")
                                    }
                                    Button("rechts positionieren") {
                                        defaults.set("r", forKey: "position \(klasse)")
                                    }
                                }, label: {
                                    HStack {
                                        if pultPos == "r" {
                                            Spacer()
                                        }
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: geo.size.width / 4 - 20, height: height - 10)
                                                .foregroundStyle(.blue)
                                            Text("Pult")
                                                .foregroundStyle(.white)
                                                .font(.title2)
                                        }
                                        .padding(10)
                                        if pultPos == "l" {
                                            Spacer()
                                        }
                                    }
                                })
                                .onReceive(timer) { _ in
                                    pultPos = defaults.string(forKey: "position \(klasse)") ?? "l"
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: width * 9 - 20, height: height / 2)
                                        .padding(10)
                                        .foregroundStyle(.blue)
                                    Text("Tafel")
                                        .foregroundStyle(.white)
                                        .font(.title)
                                        .padding(10)
                                }
                            }
                        }
                        .task {
                            if #available(iOS 17.0, *) {
                                // Configure and load your tips at app launch.
                                try? Tips.configure([
                                    .displayFrequency(.immediate),
                                    .datastoreLocation(.applicationDefault)
                                ])
                            }
                        }
                        .navigationTitle("Sitzordnung")
                        .background(Color.white)
                        /*
                        .navigationBarItems(trailing:
                            Button(action: {
                                image = body.snapshot()
                                shareImage = true
                            }, label: {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .resizable()
                                    .scaledToFit()
                            })
                        )
                         */
                    }
                }, label: {
                    Text("\(klasse)")
                })
            }
        }
        .navigationTitle("Klassen")
        .fullScreenCover(isPresented: $shareImage, content: {
            ShareSheet(itemsToShare: [image!])
        })
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct Tisch: View {
    var width: CGFloat
    var height: CGFloat
    var h: Int
    var p: Int
    var klasse: String
    
    @State var studentName = ""
    @ObservedObject var database = Database()
    @State var selectStudent = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let defaults = UserDefaults.standard
    
    var body: some View {
        Button(action: {
            selectStudent = true
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width, height: height)
                    .foregroundColor(.blue)
                RoundedRectangle(cornerRadius: 7.5)
                    .frame(width: width - 7.5, height: height - 7.5)
                    .foregroundColor(.white)
                Text(studentName)
                    .foregroundStyle(.blue)
            }
        })
        .onReceive(timer) { _ in
            getStudent()
        }
        .fullScreenCover(isPresented: $selectStudent, content: {
            NavigationView {
                VStack {
                    List {
                        ForEach(database.students) { student in
                            if student.klasse == klasse {
                                Button(student.name) {
                                    studentName = student.name
                                    doppeltPrüfenUndErsetzen()
                                    selectStudent = false
                                }
                            }
                        }
                    }
                    .navigationTitle("Schüler auswählen")
                    .navigationBarItems(trailing:
                        Button("Abbrechen") {
                            selectStudent = false
                        }
                    )
                    Button("Niemanden wählen") {
                        defaults.set("", forKey: "\(h) | \(p), \(klasse)")
                        selectStudent = false
                    }
                }
            }
            .navigationViewStyle(.stack)
        })
    }
    
    func getStudent() {
        studentName = defaults.string(forKey: "\(h) | \(p), \(klasse)") ?? ""
    }
    
    func doppeltPrüfenUndErsetzen() {
        for hauptgruppe in 1...9 {
            for periode in 1...4 {
                let prüfenDefault = defaults.string(forKey: "\(hauptgruppe) | \(periode), \(klasse)") ?? ""
                if prüfenDefault == studentName {
                    defaults.set("", forKey: "\(hauptgruppe) | \(periode), \(klasse)")
                    break
                }
            }
        }
        defaults.set(studentName, forKey: "\(h) | \(p), \(klasse)")
    }
}

#Preview {
    Sitzordnung()
}
