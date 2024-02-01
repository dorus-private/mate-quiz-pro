//
//  Math_Quiz_Pro_IOSApp.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import Combine
import SwiftUI
import CoreSpotlight
import MobileCoreServices

@main
struct ScreensApp: App {
    @State private var selectedAction: String?
    @State var showK8 = false
    @ObservedObject var externalDisplayContent = ExternalDisplayContent()
    @State var additionalWindows: [UIWindow] = []
    @AppStorage("isAirPlayActive") var isAirplayActive = false
    @AppStorage("Klasse 9") var klasse9 = false
    @AppStorage("Klasse 8") var klasse8 = false
    
    private var screenDidConnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didConnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private var screenDidDisconnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didDisconnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    if klasse8 {
                        K8()
                    } else if klasse9 {
                        K9()
                    } else {
                        ContentView()
                    }
                }
                .preferredColorScheme(.dark)
                .environmentObject(externalDisplayContent)
                .onReceive(
                    screenDidConnectPublisher,
                    perform: screenDidConnect
                )
                .onReceive(
                    screenDidDisconnectPublisher,
                    perform: screenDidDisconnect
                )
            }
            .navigationViewStyle(.stack)
            /*
             .sheet(isPresented: $showK8) {
                 K8()
             }
             .onContinueUserActivity("com.leon.mathquizpro.action1") { userActivity in
                 showK8 = true
                 if let action = userActivity.userInfo?["action"] as? String {
                     selectedAction = action
                     showK8 = true
                 }
                 if selectedAction == "action1" {
                     showK8 = true
                 }
             }
             .onAppear {
                 // Donating a user activity for a quick action
                 let activity = NSUserActivity(activityType: "com.leon.mathquizpro.action1")
                 activity.title = "Quick Action 1"
                 activity.userInfo = ["action": "action1"]
                 activity.requiredUserInfoKeys = Set(["action"])
                 activity.isEligibleForSearch = true
                 activity.isEligibleForPrediction = true
                 activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.leon.mathquizpro.action1")
                 let shortcutIcon = UIApplicationShortcutIcon(systemImageName: "star")
                 let shortcutItem = UIApplicationShortcutItem(type: "com.leon.mathquizpro.action1", localizedTitle: "Quick Action 1", localizedSubtitle: nil, icon: shortcutIcon, userInfo: nil)
                 UIApplication.shared.shortcutItems = [shortcutItem]
                         activity.becomeCurrent()
             }
             */
        }
    }

    private func screenDidConnect(_ screen: UIScreen) {
        let window = UIWindow(frame: screen.bounds)

        window.windowScene = UIApplication.shared.connectedScenes
            .first { ($0 as? UIWindowScene)?.screen == screen }
            as? UIWindowScene

        let view = ExternalView()
            .environmentObject(externalDisplayContent)
        let controller = UIHostingController(rootView: view)
        window.rootViewController = controller
        window.isHidden = false
        additionalWindows.append(window)
        externalDisplayContent.isShowingOnExternalDisplay = true
        isAirplayActive = true
    }

    private func screenDidDisconnect(_ screen: UIScreen) {
        additionalWindows.removeAll { $0.screen == screen }
        externalDisplayContent.isShowingOnExternalDisplay = false
        isAirplayActive = false
    }
}

