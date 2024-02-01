//
//  ExternalView.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import SwiftUI
import Foundation

class ExternalDisplayContent: ObservableObject {

    @Published var string = ""
    @Published var isShowingOnExternalDisplay = false

}

struct ExternalView: View {
    @AppStorage("isAirPlayActive") var isAirplayActive = false
    @EnvironmentObject var externalDisplayContent: ExternalDisplayContent
    @AppStorage("task") private var task = ""
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            if task == "" {
                EyeView()
            } else if task == "Counter" {
               CounterView()
            } else if task == "Besprechen" {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .padding(20)
                Text("Besprechung")
                    .font(.system(size: 250))
            } else if task == "lautstärke" {
                LautstärkeAmpel()
            } else {
                if task.contains("^") {
                    AttributedTextView(attributedString: TextBindingManager(string: "\(task)", hoch: 120).attributedString, fontSize: 250)
                                    .frame(height: 500)
                } else {
                    Text(task)
                        .font(.system(size: 250))
                        .multilineTextAlignment(.center)
                }
            }
        }
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
struct EyeView: View {
    @State private var xPosition: CGFloat = 0
    @State private var yPosition: CGFloat = 24
    @State private var changePosition = 0
    @State private var wartenText = "Einen Moment bitte..."
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.cyan.opacity(0.5).ignoresSafeArea(.all)
            
            Circle()
                .foregroundColor(.yellow)
                .foregroundColor(.white)
                .frame(width: 1000, height: 1000)
                .overlay {
                    VStack {
                        Spacer()
                            .frame(height: 35)
                        ZStack {
                            Circle()
                                .frame(width: 750, height: 750)
                                .foregroundColor(.red)
                            VStack {
                                Rectangle()
                                    .foregroundColor(.yellow)
                                    .frame(width: 505, height: 100)
                                Spacer()
                                    .frame(height: 0)
                                Rectangle()
                                    .foregroundColor(.yellow)
                                    .frame(width: 750, height: 550)
                                Spacer()
                                    .frame(height: 100)
                            }
                        }
                    }
                    HStack(spacing: 50) {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 300)
                            .background(
                                Circle()
                                    .foregroundColor(.white.opacity(0.4))
                                    .frame(width: 250, height: 250)
                                    .offset(x: 16)
                            )
                            .overlay {
                                Circle()
                                    .foregroundColor(.black)
                                    .frame(width: 150, height: 150)
                                    .offset(x: xPosition, y: yPosition)
                            }
                        Spacer()
                            .frame(width: 50)
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 300)
                            .background(
                                Circle()
                                    .foregroundColor(.white.opacity(0.4))
                                    .frame(width: 250, height: 250)
                                    .offset(x: 16)
                            )
                            .overlay {
                                Circle()
                                    .foregroundColor(.black)
                                    .frame(width: 150, height: 150)
                                    .offset(x: xPosition, y: yPosition)
                            }
                    }
                }
            VStack {
                Spacer()
                Text(wartenText)
                    .font(.system(size: 100))
                Spacer()
                    .frame(height: 100)
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeOut(duration: 0.75)) {
                if changePosition == 0 {
                    xPosition = -18
                    yPosition = 10
                    changePosition = 1
                } else if changePosition == 1 {
                    xPosition = 0
                    yPosition = 1-0
                    changePosition = 2
                } else if changePosition == 2 {
                    xPosition = 20
                    yPosition = 4
                    changePosition = 3
                } else if changePosition == 3 {
                    xPosition = 0
                    yPosition = 24
                    changePosition = 0
                }
            }
        }
        .onReceive(timer2) { _ in
            withAnimation(.easeOut(duration: 0.5)) {
                if wartenText == "Einen Moment bitte..." {
                    wartenText = "Gleich geht es weiter..."
                } else {
                    wartenText = "Einen Moment bitte..."
                }
            }
        }
    }
}

struct ExternalView_Previews: PreviewProvider {

    static var previews: some View {
        ExternalView()
    }

}

