//
//  ContentView.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var externalDisplayContent = ExternalDisplayContent()
    @AppStorage("task") private var task = ""
    @AppStorage("device") var device = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Form {
                    NavigationLink("Klasse 8", destination: {
                        K8()
                            .environmentObject(externalDisplayContent)
                    })
                }
                .onAppear {
                    task = ""
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        device = "IPad"
                    } else {
                        device = "IPhone"
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
