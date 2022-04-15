//
//  NotificationManager.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/15/22.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    @Published var activeAlert: Bool = false
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            //Error Handling
        }
    }
    
    func scheduleHighNotification() {
        self.activeAlert = true
        let content = UNMutableNotificationContent()
        content.title = "High"
        content.subtitle = "This is a High Alert"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        _ = Timer(timeInterval: 60, repeats: true) { _ in self.activeAlert = false }
    }
    
    func anotherWorkoutStarted() {
        let content = UNMutableNotificationContent()
        content.title = "Session Ended"
        content.body = "Your HRV Monitoring session has ended because it appears that you have started another workout. To begin monitoring please press start again once you are done compleating your workout."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
