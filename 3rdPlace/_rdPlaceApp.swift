//
//  _rdPlaceApp.swift
//  3rdPlace
//
//  Created by Marwa Bouabid on 9/7/24.
//
import SwiftUI

@main
struct YourApp: App {
    // Register the AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView() // Your main content view
        }
    }
}
