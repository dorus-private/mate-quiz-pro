//
//  Werkzeuge.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.12.23.
//

import SwiftUI

struct Werkzeuge: View {
    @AppStorage("micPermission") var micPermission = false
    @State var docu = false
    var body: some View {
        Form {
            NavigationLink("Lautstärke Messung") {
                Lautstärke()
                    .onAppear {
                        micPermission = true
                    }
                    .navigationBarHidden(false)
                    .navigationTitle("Lautstärke Messung")
                    .navigationBarTitleDisplayMode(.inline)
            }
            /*
            Button("Dokumentenkamera") {
                docu = true
            }
            .foregroundColor(.white)
             */
        }
        .navigationTitle("Werkzeuge")
        .sheet(isPresented: $docu) {
            CameraFinalView()
                .navigationTitle("Dokumentenkamera")
        }
        
    }
}

#Preview {
    Werkzeuge()
}
