//
//  AppIntent.swift
//  MQuiz Widgets
//
//  Created by Leon Șular on 18.04.24.
//

/*
 import WidgetKit
 import AppIntents
 import SwiftUI
 
 @available(iOSApplicationExtension 17.0, *)
 struct AufgabeTimeline: AppIntentTimelineProvider {
 func timeline(for configuration: WidgetKlasseIntent, in context: Context) async -> Timeline<AufgabeEntry> {
 Timeline(entries: [AufgabeEntry(date: .now, aufgabe: configuration.aufgabe, lösung: configuration.lösung, klasse: configuration.klassenStufe.klasse)], policy: .never)
 }
 
 func snapshot(for configuration: WidgetKlasseIntent, in context: Context) async -> some TimelineEntry {
 AufgabeEntry(date: .now, aufgabe: configuration.aufgabe, lösung: configuration.lösung, klasse: configuration.klassenStufe.klasse)
 }
 
 func placeholder(in context: Context) -> AufgabeEntry {
 AufgabeEntry(date: .now, aufgabe: "", lösung: "", klasse: 0)
 }
 }
 
 @available(iOSApplicationExtension 17.0, *)
 struct AufgabeEntry: TimelineEntry {
 let date: Date
 let aufgabe: String
 let lösung: String
 let klasse: Int
 }
 
 @available(iOSApplicationExtension 17.0, *)
 struct AufgabeWidgetView: View {
 let entry: AufgabeEntry
 
 var body: some View {
 VStack {
 
 }
 }
 }
 
 @available(iOSApplicationExtension 17.0, *)
 struct AufgabeWidget: Widget {
 var body: some WidgetConfiguration {
 AppIntentConfiguration(kind: "AufgabeWidget", intent: WidgetKlasseIntent.self, provider: AufgabeTimeline()) { entry in
 AufgabeWidgetView(entry: entry)
 }
 .configurationDisplayName("Aufgaben auf dem Homebildschirm")
 .description("Löse jeden Tag mehrere Aufgaben, ohne die App zu öffnen")
 .supportedFamilies([.systemMedium])
 }
 }
 
 @available(iOSApplicationExtension 17.0, *)
 struct WidgetKlasse: AppEntity {
 var displayRepresentation: DisplayRepresentation {
 DisplayRepresentation(title: "\(id)")
 }
 
 var id: String
 var klasse: Int
 
 static var typeDisplayRepresentation: TypeDisplayRepresentation = "Klassenstufe"
 static var defaultQuery = WidgetAufgabeQuery()
 
 static let alleKlassen: [WidgetKlasse] = [
 WidgetKlasse(id: "Klasse 8", klasse: 8),
 WidgetKlasse(id: "Klase 9", klasse: 9),
 WidgetKlasse(id: "Alle Klassen", klasse: 0)
 ]
 }
 
 @available(iOSApplicationExtension 17.0, *)
 struct WidgetAufgabeQuery: EntityQuery {
 func entities(for identifiers: [WidgetKlasse.ID]) async throws -> [WidgetKlasse] {
 WidgetKlasse.alleKlassen.filter {
 identifiers.contains($0.id)
 }
 }
 
 func suggestedEntities() async throws -> [WidgetKlasse] {
 WidgetKlasse.alleKlassen
 }
 func defaultResult() async -> WidgetKlasse? {
 WidgetKlasse.alleKlassen.first
 }
 }
 
 @available(iOSApplicationExtension 17.0, *)
 struct WidgetKlasseIntent: WidgetConfigurationIntent {
 static var title: LocalizedStringResource = "Aufgaben Widget"
 static var description: IntentDescription = IntentDescription("Wähle deine Klassenstufe aus, aus der dir Aufgaben angezeigt werden")
 
 var aufgabe = ""
 var lösung = ""
 
 @Parameter(title: "Klassenstufe")
 var klassenStufe: WidgetKlasse
 }
 */
