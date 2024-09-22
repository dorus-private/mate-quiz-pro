import SwiftUI
import GameKit

struct ShowRankings: View {
    let leaderBoard = GKLeaderboard()
    @State var scores: [GKScore] = []
    @Environment(\.colorScheme) var colorScheme
    @State var zpunkte = 0
    @State var optacity = 9.99999999999998
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    List (scores, id: \.self) { score in
                        HStack {
                            if score.rank == 1 {
                                Text("\(score.rank)")
                                    .foregroundColor(Color(hex: 14399514))
                            } else if score.rank == 2 {
                                Text("\(score.rank)")
                                    .foregroundColor(Color(hex: 12635855))
                            } else if score.rank == 3 {
                                Text("\(score.rank)")
                                    .foregroundColor(Color(hex: 13604978))
                            } else {
                                Text("\(score.rank)")
                            }
                            Text ("\(score.player.alias)")
                            Spacer()
                            Text("\(score.value)")
                            if score.rank == 1 {
                                Text("🥇")
                                    .font(.title)
                            } else if score.rank == 2 {
                                Text("🥈")
                                    .font(.title)
                            } else if score.rank == 3 {
                                Text("🥉")
                                    .font(.title)
                            } else {
                                CoinView(rotation: true)
                            }
                        }
                        .foregroundColor(score.player.playerID == GKLocalPlayer.local.playerID  ? .blue : colorScheme == .dark ? .white : .black)
                    }
                    .refreshable {
                        updateLeader()
                    }
                    .navigationTitle("Am meisten gelöste Aufgaben")
                    .onAppear {
                        updateLeader()
                    }
                }
            }
        }
    }
    
    func updateLeader() {
        leaderBoard.identifier = "amMeistenGelosteAufgaben.mqp"
        leaderBoard.timeScope = .allTime
        leaderBoard.loadScores { (scores, error) in
            if let error = error {
                
            } else {
                guard let scores = scores else {
                    return
                }
                self.scores = scores
            }
        }
    }
}


struct CoinView: View {
    @State private var degrees = 0.0
    var rotation: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.orange)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
            Text("$")
                .foregroundColor(.white)
        }
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 5, z: 5))
        .onAppear {
            if rotation {
                withAnimation(.linear(duration: 1)
                    .speed(0.1).repeatForever(autoreverses: false)) {
                        degrees = 360.0
                    }
            }
        }
    }
}

struct ShowRankings_Previews: PreviewProvider {
    static var previews: some View {
        ShowRankings()
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
