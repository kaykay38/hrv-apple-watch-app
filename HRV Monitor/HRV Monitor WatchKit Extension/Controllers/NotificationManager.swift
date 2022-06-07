//
//  NotificationManager.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/15/22.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    @Published var isAlertActive: Bool = false
    @Published var isSurveyActive: Bool = false
    @Published var isConfirmed: Bool = false
    @Published var isSettingsUpdated: Bool = false
    
    var settingsManager: SettingsManager = SettingsManager.instance
    
    static let instance = NotificationManager()
    
    private let categoryIdentifier = NotitficationIdentifier.falseAlarmOrDismiss.rawValue
    
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
        if(settingsManager.isSurveyEnabled){
            if(prevSurvey == nil || prevSurvey!.timeIntervalSinceNow < settingsManager.surveyInterval)
            {
                prevSurvey = Date();
                
                print(prevSurvey!.timeIntervalSinceNow)
                
                self.isSurveyActive = true
                let content = UNMutableNotificationContent()
                content.title = SURVEY_TITLE
                content.subtitle = SURVEY_SUBTITLE
                content.sound = .default
                
                // Notification Buttons/Action
                let reply = UNNotificationAction(identifier: NotitficationIdentifier.reply.rawValue, title: REPLY_TITLE, options: UNNotificationActionOptions.foreground)
                
                //UNNotificationActionOptions.foreground
                let dismiss =  UNNotificationCategory(identifier: categoryIdentifier, actions: [reply], intentIdentifiers: [],
                                                      options: .customDismissAction)
                
                UNUserNotificationCenter.current().setNotificationCategories([dismiss])
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
                
                
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
                
                
                self.isSurveyActive = true
                
                _ = Timer(timeInterval: 60, repeats: true) { _ in self.isAlertActive = false }
            }
        }
        else {
            self.isSurveyActive = false
        }
    }
    
    var prevAlert: Date? = nil
    
    func scheduleHighNotification() {
        if(prevAlert == nil || prevAlert!.timeIntervalSinceNow < -300)
        {
            prevAlert = Date()
            self.isAlertActive = true
            let content = UNMutableNotificationContent()
            content.title = APP_NAME
            content.body = settingsManager.alertMessage
            content.sound = .default
            content.categoryIdentifier = categoryIdentifier
            
            // Notification Buttons/Action
            let falseAlarm = UNNotificationAction(identifier: NotitficationIdentifier.falseAlarm.rawValue, title: FALSE_ALARM_LABEL, options: UNNotificationActionOptions.foreground)
            
            //UNNotificationActionOptions.foreground
            let dismiss =  UNNotificationCategory(identifier: categoryIdentifier, actions: [falseAlarm], intentIdentifiers: [],
                                                  options: .customDismissAction)
            
            UNUserNotificationCenter.current().setNotificationCategories([dismiss])
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
            
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
            _ = Timer(timeInterval: 60, repeats: true) { _ in self.isAlertActive = false }
        }
    }
    
    func anotherWorkoutStarted() {
        let content = UNMutableNotificationContent()
        content.title = ALERT_TITLE_SESSION_ENDED
        content.body = ALERT_MESSAGE_SESSION_ENDED
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
