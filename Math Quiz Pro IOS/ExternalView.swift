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

    @EnvironmentObject var externalDisplayContent: ExternalDisplayContent
    @AppStorage("task") private var task = ""
    
    var body: some View {
        if task == "" {
            EyeView()
        } else {
            Text(task)
                .font(.system(size: 500))
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
                    
                    VStack {
                        Spacer()
                            .frame(height: 200)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black)
                            .frame(width: 200, height: 20)
                            .padding(.top, 180)
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

