//
//  Shortcuts.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 19.01.24.
//


import Foundation
import AppIntents
import SwiftUI

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct Klasse8Öffnen: AppIntent {
    @AppStorage("Klasse 8") var klasse8 = true
    @AppStorage("Klasse 9") var klasse9 = true
    static var title: LocalizedStringResource = "8. Klasse öffnen"
    
    
    static let intentClassName = "Klasse8Öffnen"
    
    static var description = IntentDescription("Öffnen Sie direkt die 8. Klasse")
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some  IntentResult {
        klasse8 = true
        klasse9 = false
        return .result()
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct Klasse91Öffnen: AppIntent {
    @AppStorage("Klasse 9") var klasse9 = true
    @AppStorage("Klasse 8") var klasse8 = true
    static var title: LocalizedStringResource = "9. Klasse öffnen"
    
    static let intentClassName = "Klasse91Öffnen"
    
    static var description = IntentDescription("Öffnen Sie direkt die 9. Klasse")
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some  IntentResult {
        klasse9 = true
        klasse8 = false
        return .result()
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct MathQuizProShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .grayBlue
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: Klasse8Öffnen(), phrases: ["8. Klasse öffnen \(.applicationName)", "Öffne die 8. Klasse \(.applicationName)"], shortTitle: "8. Klasse öffnen", systemImageName: "graduationcap.fill")
        AppShortcut(intent: Klasse91Öffnen(), phrases: ["9. Klasse öffnen \(.applicationName)", "Öffne die 9. Klasse \(.applicationName)"], shortTitle: "9. Klasse öffnen", systemImageName: "graduationcap.fill")
    }
}
