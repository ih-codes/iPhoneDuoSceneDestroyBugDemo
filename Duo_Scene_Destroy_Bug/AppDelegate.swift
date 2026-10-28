//
// AppDelegate.swift
// Duo_Scene_Destroy_Bug
// Created on 2026-10-28, 2026. 
//  

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

    // MARK: Quick Actions

    static let mergeWindowsShortcutType = Bundle.main.bundleIdentifier! + ".mergeWindows"

    /// Closes all connected scenes except one (either the foreground-active scene or the first connected scene).
    func mergeWindowData(keeping sceneToKeep: UIScene? = nil) {
        // Some logic would go here to merge the data from all scenes as needed, prior to closing them...
        // ...
        // ...

        // Then we close all but one scene (e.g. iPhone Duo Split View and iPad Multitask).
        // For non-Duo iPhones, you can't have more than one scene, so this logic is skipped.
        let scenes = UIApplication.shared.connectedScenes
        guard let keep = scenes.first(where: { $0.activationState == .foregroundActive })
                         ?? scenes.first else { return }

        for scene in scenes where scene !== keep {
            print("Destroying scene session: \(scene.session.persistentIdentifier)")
            UIApplication.shared.requestSceneSessionDestruction(scene.session, options: nil) { error in
                /// BUG: iPhone Duo outputs error: "This functionality is not supported for this device idiom."
                ///
                /// `requestSceneSessionDestruction failed: Error Domain=SBApplicationSupportService Code=1 "This functionality is not supported for this device idiom." UserInfo={NSLocalizedFailureReason=This functionality is not supported for this device idiom.}`
                ///
                /// If this is "unsupported", then how can we programmatically close the extra instances of our app in
                /// the App Switcher?
                print("requestSceneSessionDestruction failed: \(error)")
            }
        }
    }
}
