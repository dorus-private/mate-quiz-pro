//
//  MQuiz_Widgets.swift
//  MQuiz Widgets
//
//  Created by Leon Șular on 18.04.24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), punkte: 1)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), punkte: 1)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        let userDefaults = UserDefaults(suiteName: "group.PunkteMatheQuizPro")
        let currentNumber = userDefaults?.integer(forKey: "punkte") ?? 0
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) ?? currentDate
            let entry = SimpleEntry(date: entryDate, punkte: currentNumber)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let punkte: Int
}

struct MQuiz_WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.cyan, .teal, .mint, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea(.all)
            VStack {
                if #available(iOSApplicationExtension 17.0, *) {
                    VStack {
                        HStack {
                            Image(systemName: "figure.strengthtraining.functional")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(.green)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(entry.punkte >= 10 ? .mint : .gray)
                            Image(systemName: "figure.walk")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(entry.punkte >= 10 ? .mint : .gray)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(entry.punkte >= 50 ? .indigo : .gray)
                            Image(systemName: "figure.walk.motion")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(entry.punkte >= 50 ? .indigo : .gray)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(entry.punkte >= 100 ? .blue : .gray)
                            Image(systemName: "figure.highintensity.intervaltraining")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(entry.punkte >= 100 ? .blue : .gray)
                            Spacer()
                        }
                        .padding(5)
                        VStack {
                            if entry.punkte >= 100 {
                                Text("Senior Mathematiker")
                                    .multilineTextAlignment(.center)
                            } else if entry.punkte >= 50 {
                                Text("Schneller Mathematiker")
                                    .multilineTextAlignment(.center)
                            } else if entry.punkte >= 10 {
                                Text("Fortgeschrittener Mathematiker")
                            } else {
                                Text("Junior Mathematiker")
                            }
                        }
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            Button(intent: Klasse8Öffnen()) {
                                Text("8. Klasse")
                            }
                            .tint(Color.purple)
                      
                            Spacer()
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                Text("Klasse \nöffnen, \num Punkte \nzu sammeln")
                                    .font(.system(size: 7.5))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                            } else {
                                Text("Klasse öffnen, um \nPunkte zu sammeln")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Button(intent: Klasse91Öffnen(), label: {
                                Text("9. Klasse")
                            })
                            .tint(Color.purple)
                            
                            Spacer()
                                .frame(width: 5)
                        }
                        .foregroundColor(.white)
                        .padding(5)
                    }
                    .ignoresSafeArea()
                    .containerBackground(for: .widget) {
                        Color.white
                    }
                } else {
                    VStack {
                        HStack {
                            Image(systemName: "figure.strengthtraining.functional")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(.green)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(entry.punkte >= 10 ? .cyan : .gray)
                            Image(systemName: "figure.walk")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(entry.punkte >= 10 ? .cyan : .gray)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(entry.punkte >= 50 ? .indigo : .gray)
                            Image(systemName: "figure.walk.motion")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(entry.punkte >= 50 ? .indigo : .gray)
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(entry.punkte >= 100 ? .blue : .gray)
                            Image(systemName: "figure.highintensity.intervaltraining")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                                .foregroundColor(entry.punkte >= 100 ? .blue : .gray)
                            Spacer()
                        }
                        .padding(5)
                        if entry.punkte >= 100 {
                            Text("Herzlichen Glückwunsch, du hast alle Rangs erreicht")
                                .multilineTextAlignment(.center)
                        } else {
                            Text("Noch \(100 - entry.punkte) Punkte bis zum Senior Mathematiker")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                            .frame(height: 5)
                    }
                }
            }
        }
    }
}

struct MQuiz_Widgets: Widget {
    let kind: String = "MQuizWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MQuiz_WidgetsEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Status Tracker")
        .description("Behalte dein Status immer im Blick")
        .contentMarginsDisabled()
    }
}
