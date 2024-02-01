//
//  Mitternachtsformel.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 11.12.23.
//

import SwiftUI

struct Mitternachtsformel: View {
    var body: some View {
        VStack {
            
        }
    }
    /*
    @State private var a = 1
    @State private var b = 0
    @State private var c = 0
    @State var berechnen = false
    @State var ergebnis = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    
    var body: some View {
        ScrollView {
            VStack {
                Text("Parameter")
                    .font(.title)
                HStack {
                    Text("a = ")
                        .padding(10)
                    TextField("a", value: $a, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("b = ")
                        .padding(10)
                    TextField("b", value: $b, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("c = ")
                        .padding(10)
                    TextField("c", value: $c, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                }
                Text("Formel")
                    .font(.title)
                HStack {
                    VStack {
                        HStack {
                            Text("Allgemeine Formel:")
                            Spacer()
                        }
                        HStack {
                            Text("0 = axs + bx + c".superscripted)
                            Spacer()
                        }
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Text("Mit Ihren Parametern eingesetzt:")
                            Spacer()
                        }
                        HStack {
                            Text("0 = \(a)xs + \(b)x + \(c)".superscripted)
                            Spacer()
                        }
                    }
                }
                if berechnen {
                    Text("Lösung")
                        .font(.title)
                    lösung
                }
            }
        }
    }
    
    var lösung: some View {
        HStack {
            VStack {
                HStack {
                    Text("Allgemeine Lösung:")
                    Spacer()
                }
                HStack {
                    VStack {
                        Text("x1,2 = -b ± √(bs - 4ac)".superscripted)
                        Rectangle()
                            .frame(height: 2.5)
                        Text("2a")
                    }
                    .frame(width: 200)
                    Spacer()
                }
            }
            Spacer()
            VStack {
                HStack {
                    Text("Ihre Lösung:")
                    Spacer()
                }
                v1
                /*
                v2
                v3
                v4
                */
                v5
                v6
            }
        }
    }
    
    var v1: some View {
        HStack {
            Spacer()
            VStack {
                Text("x1,2 = -\(b) ± √(\(b)s - 4 * \(a) * \(c))".superscripted)
                Rectangle()
                    .frame(height: 2.5)
                Text("2 * \(a)")
            }
        }
    }
    
    /*
    var v2: some View {
        HStack {
            Spacer()
            VStack {
                Text("x1,2 = -\(b) ± √(\(b * b) - \(4 * a * c))")
                Rectangle()
                    .frame(height: 2.5)
                Text("\(2 * a)")
            }
        }
    }
    
    var v3: some View {
        HStack {
            Spacer()
            VStack {
                Text("x1,2 = -\(b) ± √(\(b * b - 4 * a * c))")
                Rectangle()
                    .frame(height: 2.5)
                Text("\(2 * a)")
            }
        }
    }
    
    var v4: some View {
        HStack {
            Spacer()
            VStack {
                Text("x1,2 = -\(b) ± \(sqrt(b * b - 4 * a * c))")
                Rectangle()
                    .frame(height: 2.5)
                Text("\(2 * a)")
            }
        }
    }
     */
      
    var v5: some View {
        HStack {
            Spacer()
            VStack {
                Text("x1 = -\(b) + \(sqrt(b * b - 4 * a * c))")
                Rectangle()
                    .frame(height: 2.5)
                Text("\(2 * a)")
            }
            Text("= \((-b - sqrt(b * b - 4 * a * c)/2))")
        }
    }
    
    var v6: some View {
        HStack {
            Spacer()
            VStack {
                Text("x1 = -\(b) - \(sqrt(b * b - 4 * a * c))")
                Rectangle()
                    .frame(height: 2.5)
                Text("\(2 * a)")
            }
            Text("= \((-b - sqrt(b * b - 4 * a * c)/2))")
        }
    }
     */
}

#Preview {
    Mitternachtsformel()
}
