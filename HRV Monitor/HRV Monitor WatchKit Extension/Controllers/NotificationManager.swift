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
    @Published var activeSurvey: Bool = false
    @Published var thankYou: Bool = false
    @Published var settingsUpdated: Bool = false
    
    
    static let instance = NotificationManager()
    
    private let categoryIdentifier = "FalseAlarmOrDismiss"
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            //Error Handling
            /*if let error = error{
                print("Notification: ERROR")
            }
            else{
                print("Notification: Approved Access")
            }*/
        }
    }
    
    var prevSurvey: Date? = nil
    
    // trigger the survey on a calendar
    func scheduleSurvey(){
        if(UserDefaults.standard.bool(forKey: "survey")){
            if(prevSurvey == nil || prevSurvey!.timeIntervalSinceNow < UserDefaults.standard.double(forKey: "surveryInterval")) {
                prevSurvey = Date();
                self.activeSurvey = true
                let content = UNMutableNotificationContent()
                content.title = "How are you feeling?"
                content.subtitle = "Log your stess level in app."
                content.sound = .default
                
                // Notification Buttons/Action
                let reply = UNNotificationAction(identifier: "reply", title: "Reply", options: UNNotificationActionOptions.foreground)
                
                //UNNotificationActionOptions.foreground
                let dismiss =  UNNotificationCategory(identifier: categoryIdentifier, actions: [reply], intentIdentifiers: [],
                    options: .customDismissAction)
            
                UNUserNotificationCenter.current().setNotificationCategories([dismiss])
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)

                
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
                    
                    
                    self.activeSurvey = true
                
                _ = Timer(timeInterval: 60, repeats: true) { _ in self.activeAlert = false }
            }
        }
        else{
            self.activeSurvey = false
        }
    }
    
    var prevAlert: Date? = nil
    
    func scheduleHighNotification() {
        if(prevAlert == nil || prevAlert!.timeIntervalSinceNow < -300)
        {
            prevAlert = Date()
            self.activeAlert = true
            let content = UNMutableNotificationContent()
            content.title = "Warning"
            content.subtitle = "High stress detected"
            content.sound = .default
            content.categoryIdentifier = categoryIdentifier
            
            // Notification Buttons/Action
            let falseAlarm = UNNotificationAction(identifier: "falseAlarm", title: "False Alarm", options: UNNotificationActionOptions.foreground)
            
            //UNNotificationActionOptions.foreground
            let dismiss =  UNNotificationCategory(identifier: categoryIdentifier, actions: [falseAlarm], intentIdentifiers: [],
                options: .customDismissAction)
        
            UNUserNotificationCenter.current().setNotificationCategories([dismiss])
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)

            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
            _ = Timer(timeInterval: 60, repeats: true) { _ in self.activeAlert = false }
        }
    }
        
        func anotherWorkoutStarted() {
            let content = UNMutableNotificationContent()
            content.title = "Session Ended"
            content.body = "Your HRV Monitoring session has ended because it appears that you have started another workout. To begin monitoring please press start again once you are done completing your workout."
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
           // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
    }
}
