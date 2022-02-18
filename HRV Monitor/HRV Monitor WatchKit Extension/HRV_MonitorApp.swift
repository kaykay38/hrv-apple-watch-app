//
//  HRV_MonitorApp.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI

@main
struct HRV_MonitorApp: App {
    @StateObject var workoutManager = WorkoutManager()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartStopView()
            }
            .environmentObject(workoutManager)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
