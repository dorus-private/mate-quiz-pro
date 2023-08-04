//
//  ZufälligePerson.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 30.07.23.
//

import SwiftUI

struct Zufa_lligePerson: View {
    @AppStorage("device") var device = ""
    @State var zufälligePerson = 0
    var body: some View {
        VStack {
            if device == "IPad" {
                // IPad
                ipad
            } else {
                // IPhone
                
            }
            Button(action: {
                withAnimation {
                    zufälligePerson = Int.random(in: 1...32)
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                    Text("Zufällige Person auswählen")
                        .foregroundColor(.white)
                }
            })
            .padding(10)
        }
    }
    
    var ausgewähltIpad: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.yellow)
                .frame(width: 75, height: 75)
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
        .shadow(radius: 5)
    }
    
    var standartIpad: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.cyan)
            .frame(width: 75, height: 75)
            .shadow(radius: 5)
    }
    var ipad: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 1 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 2 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 3 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 4 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 5 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 6 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 7 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 8 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 9 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 10 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 11 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 12 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 13 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 14 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 15 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 16 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 17 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 18 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 19 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 20 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 21 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 22 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 23 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 24 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 25 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 26 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 27 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 28 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        if zufälligePerson == 29 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 30 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 31 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                        if zufälligePerson == 32 {
                            ausgewähltIpad
                        } else {
                            standartIpad
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
        }
    }
}

struct Zufa_lligePerson_Previews: PreviewProvider {
    static var previews: some View {
        Zufa_lligePerson()
    }
}
