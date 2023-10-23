//
//  DuduBubuApp.swift
//  DuduBubu
//
//  Created by John McCants on 10/18/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main
struct DuduBubuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some Scene {
        WindowGroup {
           
                ContentView().environmentObject(AuthViewModel.shared)
                 
        }
    }
}
