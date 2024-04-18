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
import os.log
import UIKit
import FirebaseCore
import FirebaseMessaging

func log(_ message: String) {
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MPLogging")
    os_log("%@", log: log, type: .debug, message)
}

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
            
        return true
    }
        
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        UserDefaults.standard.set(true, forKey: "presentAppStoreView")
    }
        
        
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("fcm", fcm)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

@main
struct ScreensApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var selectedAction: String?
    @State var showK8 = false
    @ObservedObject var externalDisplayContent = ExternalDisplayContent()
    @State var additionalWindows: [UIWindow] = []
    @AppStorage("isAirPlayActive") var isAirplayActive = false
    @AppStorage("Klasse 9") var klasse9 = false
    @AppStorage("Klasse 8") var klasse8 = false
    @AppStorage("presentAppStoreView") var presentAppStoreView = false
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    @AppStorage("rolle") var rolle = 1
    
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
                .onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0 
                }
                .sheet(isPresented: $presentAppStoreView) {
                    VStack {
                        Text("Die App wurde vor kurzem im AppStore aktualisiert")
                            .font(.title)
                            .padding(20)
                            .multilineTextAlignment(.center)
                        Text("Prüfen Sie im AppStore, ob diese Version die neuste ist")
                            .multilineTextAlignment(.center)
                        Text("Wenn im AppStore öffnen steht, dann sind Sie auf dem neustem Stand")
                            .multilineTextAlignment(.center)
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.gray)
                                .shadow(radius: 15)
                                .frame(width: 210, height: 210)
                            Image("MelekIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(15)
                        }
                        Text("Aktuelle Version: \(appVersion ?? "")")
                        Spacer()
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Button(action: {
                                if let url = URL(string: "https://apps.apple.com/us/app/mathe-quiz-pro/id6452084507") {
                                    UIApplication.shared.open(url)
                                }
                                presentAppStoreView = false
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                    Text("Jetzt prüfen")
                                        .foregroundStyle(.white)
                                }
                                .frame(height: 50)
                            })
                            Spacer()
                                .frame(width: 20)
                        }
                        Spacer()
                            .frame(height: 10)
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Button("Vielleicht später") {
                                presentAppStoreView = false
                            }
                            Spacer()
                                .frame(width: 20)
                        }
                        Spacer()
                            .frame(height: 20)
                    }
                }
                .preferredColorScheme(rolle == 1 ? .dark : .light)
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

@MainActor
class NotificationManager: ObservableObject{
    @Published private(set) var hasPermission = false
    
    init() {
        Task{
            await getAuthStatus()
        }
    }
    
    func request() async{
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
             await getAuthStatus()
        } catch{
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}

