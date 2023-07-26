//
//  Math_Quiz_Pro_IOSApp.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 25.07.23.
//

import Combine
import SwiftUI

@main
struct ScreensApp: App {

    @ObservedObject var externalDisplayContent = ExternalDisplayContent()
    @State var additionalWindows: [UIWindow] = []

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
                ContentView()
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
    }

    private func screenDidDisconnect(_ screen: UIScreen) {
        additionalWindows.removeAll { $0.screen == screen }
        externalDisplayContent.isShowingOnExternalDisplay = false
    }

}

