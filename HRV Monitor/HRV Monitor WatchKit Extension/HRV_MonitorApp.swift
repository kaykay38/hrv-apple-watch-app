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
    @StateObject var tester_HRVCalculator = Tester_HRVCalculator()
        
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                PagingView()
            //  TestView()
            }
            .environmentObject(workoutManager)
        }

        //WKNotificationScene(controller: NotificationManager.self, category: "myCategory")
    }
    
}
