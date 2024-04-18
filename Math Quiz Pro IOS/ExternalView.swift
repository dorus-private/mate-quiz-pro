//
//  ExternalView.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import SwiftUI
import Foundation
import EffectsLibrary

class ExternalDisplayContent: ObservableObject {

    @Published var string = ""
    @Published var isShowingOnExternalDisplay = false

}

struct ExternalView: View {
    @AppStorage("isAirPlayActive") var isAirplayActive = false
    @EnvironmentObject var externalDisplayContent: ExternalDisplayContent
    @AppStorage("task") private var task = ""
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("motivExternerBildschirm") var motivExternerBildschirm = 1
    @State var color: Color = .blue
    @AppStorage("klassenKamerad") private var klassenKamerad = ""
    @AppStorage("StatusHausnummern") var statusHausnummern = ""
    
    var body: some View {
        ZStack {
            VStack {
                if task == "" {
                    if motivExternerBildschirm == 1 {
                        EyeView()
                    } else {
                        HStack {
                            AnalogClockView(foregroundColor: $color)
                        }
                    }
                } else if task == "Counter" {
                    CounterView(bigText: true)
                        .padding(100)
                } else if task == "Hausnummer" {
                    ZStack {
                        Text(klassenKamerad)
                            .font(.system(size: 250))
                    }
                } else if task == "Ende" {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black)
                            .ignoresSafeArea(.all)
                        FireworksView()
                        FireworksView()
                        VStack {
                            Text("Herzlichen Glückwunsch \(klassenKamerad)")
                                .font(.system(size: 250))
                                .foregroundStyle(.white)
                            Text("Du hast gewonnen!!!")
                                .font(.system(size: 175))
                                .foregroundStyle(.white)
                        }
                    }
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
                } else if task == "sss" || task == "Ssw" || task == "sws" || task == "wsw" || task == "x2" || task == "x3" || task == "x4" || task == "2^x" || task == "5*2^x" || task == "4^x" || task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" {
                    if task == "x2" || task == "x3" || task == "x4" {
                        Text("Ordne das passende Kärtchen zur Abbildung zu")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 200))
                            .padding(20)
                    } else if task == "2^x" || task == "5*2^x" || task == "4^x" {
                        Text("Bestimme die Funktionsgleichung der Exponentialfunktion")
                            .font(.system(size: 200))
                            .multilineTextAlignment(.center)
                            .padding(20)
                    } else if task == "DEF" || task == "GHI" || task == "JKL" || task == "MNO" || task == "PQR" {
                        Text("Nenne den Satz des Pythagoras aus diesem Dreieck")
                            .font(.system(size: 200))
                            .multilineTextAlignment(.center)
                            .padding(20)
                    } else {
                        Text("Bestimme den Kongruenzsatz")
                            .font(.system(size: 200))
                            .multilineTextAlignment(.center)
                            .padding(20)
                    }
                    Spacer()
                    HStack {
                        VStack {
                            Image(task)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 120, minHeight: 120)
                                .cornerRadius(15)
                                .padding(50)
                            if task == "x2" || task == "x3" || task == "x4" {
                                Spacer()
                            }
                        }
                        VStack {
                            if task == "x2" || task == "x3" || task == "x4" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 35)
                                        .frame(maxHeight: 225)
                                        .foregroundColor(.blue)
                                    Text("f(x) = x²")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 200))
                                }
                                .padding(20)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 35)
                                        .foregroundColor(.green)
                                        .frame(maxHeight: 225)
                                    Text("f(x) = x³")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 200))
                                }
                                .padding(20)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 35)
                                        .foregroundColor(.purple)
                                        .frame(maxHeight: 225)
                                    Text("f(x) = x⁴")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 200))
                                }
                                .padding(20)
                                Spacer()
                            }
                        }
                    }
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
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        Text("Made with Mathe Quiz Pro")
                            .font(.system(size: 50))
                            .foregroundStyle(task == "Ende" ? .white : .black)
                        Spacer()
                            .frame(width: 25)
                        Image("MelekIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                        Spacer()
                            .frame(width: 50)
                    }
                }
                .padding(50)
            }
        }
    }

}

struct CounterView: View {
    var bigText: Bool
    @State var startProgress = 0.0
    @State var startProgressText = 0
    @AppStorage("task") private var task = ""
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [.cyan, .teal, .mint, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5),
                    lineWidth: bigText ? 75 : 30
                )
            Circle()
                .trim(from: 0, to: startProgress)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [.cyan, .teal, .mint, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                    // 1
                    style: StrokeStyle(
                        lineWidth: bigText ? 75 : 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            if #available(iOS 16.0, *) {
                if bigText {
                    Text("\(startProgressText)")
                        .font(.system(size: 250))
                        .contentTransition(.numericText())
                } else {
                    Text("\(startProgressText)")
                        .font(.largeTitle)
                        .contentTransition(.numericText())
                }
            } else {
                if bigText {
                    Text("\(startProgressText)")
                        .font(.system(size: 250))
                } else {
                    Text("\(startProgressText)")
                        .font(.largeTitle)
                }
            }
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
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.cyan, .teal, .mint, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea(.all)
            
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
                    .padding(50)
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

struct AnalogClockView: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @State private var currentTime: Date = Date.now
    
    var onUpdateTime: AnalogClockCallback? = nil
    
    let borderWidth: CGFloat = 20
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    @State var clockTime = ""
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        let dateString = formatter.string(from: Date())
        return dateString
    }
    
    func removeLastThreeCharacters(from string: String) -> String {
            guard string.count > 2 else { return string }
            let endIndex = string.index(string.endIndex, offsetBy: -4)
            return String(string[..<endIndex])
        }
    
    var timeView: some View {
        HStack {
            Spacer()
            if #available(iOS 16.0, *) {
                Text("\(clockTime)")
                    .contentTransition(.numericText())
                    .font(.system(size: 200))
                    .padding(50)
            } else {
                Text("\(clockTime)")
                    .font(.system(size: 200))
                    .padding(50)
            }
        }
    }
    
    var clockView: some View {
        GeometryReader { geometry in
            let radius = geometry.size.width / 2
            let innerRadius = radius - borderWidth
            
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            
            let center = CGPoint(x: centerX, y: centerY)
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime)
            
            let hour = Double(components.hour ?? 0)
            let minute = Double(components.minute ?? 0)
            let second = Double(components.second ?? 0)
            
            // Using this circle for creating the border
            Circle()
                .foregroundColor(foregroundColor)
            
            // For clock dial
            Circle()
                .foregroundColor(.white)
                .padding(borderWidth)
            
            // Creating the ticks
            Path { path in
                for index in 0..<60 {
                    let radian = Angle(degrees: Double(index) * 6 - 90).radians
                    
                    let lineHeight: Double = index % 5 == 0 ? 25 : 10
                    
                    let x1 = centerX + innerRadius * cos(radian)
                    let y1 = centerY + innerRadius * sin(radian)
                    
                    let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
                    let y2 = centerY + (innerRadius - lineHeight) * sin(radian)
                    
                    path.move(to: .init(x: x1, y: y1))
                    path.addLine(to: .init(x: x2, y: y2))
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing Seconds hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius - 20
                
                let radian = Angle(degrees: second * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.7
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing hour hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.45
                
                let radian = Angle(degrees: hour * 30 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 9, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(foregroundColor)
                .position(center)
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { time in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            self.clockTime = formatter.string(from: Date())
            currentTime = Date.now
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.cyan, .teal, .mint, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea(.all)
            HStack {
                Spacer()
                clockView
                    .padding(50)
                Spacer()
                timeView
                Spacer()
            }
        }
    }
}

struct ExternalView_Previews: PreviewProvider {

    static var previews: some View {
        ExternalView()
    }

}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
