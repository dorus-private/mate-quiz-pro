//
//  Werkzeuge.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 10.12.23.
//

import SwiftUI

struct Werkzeuge: View {
    @AppStorage("micPermission") var micPermission = false
    
    var body: some View {
        Lautstärke()
            .onAppear {
                micPermission = true
            }
            .navigationBarHidden(false)
            .navigationTitle("Lautstärke Messung")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    Werkzeuge()
}
