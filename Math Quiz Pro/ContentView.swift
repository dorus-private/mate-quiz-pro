//
//  ContentView.swift
//  Math Quiz Pro
//
//  Created by Leon Șular on 14.07.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Form {
            NavigationLink("Klasse 8", destination: {
                Klasse_8()
            })
        }
        .navigationTitle("Klassenstufe")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
