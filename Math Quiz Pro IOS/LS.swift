//
//  LS.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 15.11.23.
//

import SwiftUI
import StoreKit
import EffectsLibrary

struct LS: View {
    @State var showRecommended = false
    @AppStorage ("cV") var cV = 0
    @Environment(\.colorScheme) var colorScheme
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    @State var showSnowFlakes = false
    
    var body: some View {
        VStack {
            if showRecommended {
                Text("HAPPY NEW YEAR")
                    .foregroundStyle(.white)
                    .font(.title)
                    .padding(20)
            }
            Spacer()
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
            /*
                .appStoreOverlay(isPresented: $showRecommended) {
                    SKOverlay.AppConfiguration(appIdentifier: "6446118285", position: .bottom)
                }
             */
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

