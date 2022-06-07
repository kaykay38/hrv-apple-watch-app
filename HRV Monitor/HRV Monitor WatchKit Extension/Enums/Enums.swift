//
//  Enums.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia Hunt on 6/4/22.
//

import Foundation

enum KeyValue: String {
    case isSurveyEnabled, surveyIntervalIndex, surveyInterval, isSettingsInitialized, alertMessage, alertTitle
}

enum NotitficationIdentifier: String {
    case reply, falseAlarm, falseAlarmOrDismiss
}
