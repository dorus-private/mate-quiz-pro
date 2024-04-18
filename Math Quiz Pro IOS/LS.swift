//
//  LS.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 15.11.23.
//

import SwiftUI
import StoreKit
import EffectsLibrary
import SplineRuntime
import Network

struct LS: View {
    @State var showRecommended = false
    @AppStorage ("cV") var cV = 0
    @Environment(\.colorScheme) var colorScheme
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    @State var showSnowFlakes = false
    @State var downloadAmount = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some View {
        ZStack {
            VStack {
                if #available(iOS 16.0, *), networkMonitor.isConnected {
                    let url = URL(string: "https://build.spline.design/3K3U2qb3f7od7CWz38gc/scene.splineswift")!

                    try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
                } else {
                    ZStack {
                        if showSnowFlakes {
                            
                        }
                        VStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.mint)
                            Spacer()
                                .frame(height: 10)
                            Circle()
                                .frame(width: 275, height: 250)
                                .foregroundColor(.mint)
                                .padding(0)
                        }
                        VStack {
                            Spacer()
                                .frame(height: 140)
                            Rectangle()
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .frame(width: 285, height: 125)
                        }
                        if showRecommended {
                            FireworksView()
                        }
                        VStack {
                            Spacer()
                                .frame(height: 112.5)
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 25, height: 200)
                                    .foregroundColor(.mint)
                                    .padding(7)
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 25, height: 200)
                                    .foregroundColor(.mint)
                                    .padding(7)
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 25, height: 200)
                                    .foregroundColor(.mint)
                                    .padding(7)
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 25, height: 200)
                                    .foregroundColor(.mint)
                                    .padding(7)
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 25, height: 200)
                                    .foregroundColor(.mint)
                                    .padding(7)
                            }
                        }
                        VStack {
                            Spacer()
                                .frame(height: 312.5)
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.mint)
                                    .frame(width: 250, height: 50)
                                if #available(iOS 16.0, *) {
                                    Text("MGL")
                                        .font(.system(.title, weight: .bold))
                                        .foregroundColor(colorScheme == .dark ? .black : .white)
                                } else {
                                    Text("MGL")
                                        .font(.title)
                                        .foregroundColor(colorScheme == .dark ? .black : .white)
                                }
                            }
                        }
                    }
                    Spacer()
                    Text("Von Leon Şular und Melek Dogan\n 9. Klasse")
                        .multilineTextAlignment(.center)
                    Link("Mörike Gymnasium Ludwigsburg", destination: URL(string: "https://maps.apple.com/?address=Karlstra%C3%9Fe%2019,%20Mitte,%2071638%20Ludwigsburg,%20Deutschland&auid=14641334786343416002&ll=48.892091,9.189131&lsp=9902&q=M%C3%B6rike-Gymnasium")!)
                    Spacer()
                        .frame(height: 130)
                }
                /*
                 .appStoreOverlay(isPresented: $showRecommended) {
                 SKOverlay.AppConfiguration(appIdentifier: "6446118285", position: .bottom)
                 }
                 */
            }
            VStack {
                ProgressView("", value: downloadAmount, total: 100)
                    .padding(20)
                if showRecommended {
                    Text("HAPPY NEW YEAR")
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding(20)
                }
                Spacer()
                Text("Einen Moment bitte")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(20)
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                downloadAmount += 20
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if Int(currentMonth())! == 1 {
                    if Int(dayOfMonth())! <= 10 {
                        showRecommended = true
                    }
                    showSnowFlakes = true
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                showRecommended = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.easeOut(duration: 1)) {
                    cV = 1
                }
            }
        }
    }
    
    func dayOfMonth() -> String {
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: currentDate)
    }

    func currentMonth() -> String {
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: currentDate)
    }
}

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
