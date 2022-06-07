//
//  SettingsController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia Hunt on 6/4/22.
//

import Foundation

class SettingsManager: NSObject, ObservableObject {
    
    static let instance = SettingsManager()
    let userDefaults = UserDefaults.standard
    
    private(set) var isSettingsInitialized: Bool = UserDefaults.standard.bool(forKey: KeyValue.isSettingsInitialized.rawValue)
    @Published var isSurveyEnabled: Bool = UserDefaults.standard.bool(forKey: KeyValue.isSurveyEnabled.rawValue)
    @Published private(set) var surveyInterval: Double = UserDefaults.standard.double(forKey: KeyValue.surveyInterval.rawValue)
    @Published var surveyIntervalIndex: Int = UserDefaults.standard.integer(forKey: KeyValue.surveyIntervalIndex.rawValue)
    @Published var alertMessage: String = UserDefaults.standard.string(forKey: KeyValue.alertMessage.rawValue) ?? HIGH_STRESS_DETECTED_LABEL
    
    override init() {
        if !isSettingsInitialized {
            print("Initializing Settings...")
            isSurveyEnabled = false
            surveyInterval = SURVEY_INTERVAL_3HR
            surveyIntervalIndex = SURVEY_INTERVAL_INDEX_3HR
            isSettingsInitialized = true
            alertMessage = HIGH_STRESS_DETECTED_LABEL
            userDefaults.set(false,forKey: KeyValue.isSurveyEnabled.rawValue)
            userDefaults.set(SURVEY_INTERVAL_3HR,forKey: KeyValue.surveyInterval.rawValue)
            userDefaults.set(SURVEY_INTERVAL_INDEX_3HR,forKey: KeyValue.surveyIntervalIndex.rawValue)
            userDefaults.set(true,forKey: KeyValue.isSettingsInitialized.rawValue)
            userDefaults.set(HIGH_STRESS_DETECTED_LABEL,forKey: KeyValue.alertMessage.rawValue)
            userDefaults.synchronize()
        }
        print("UserDefault \(KeyValue.isSettingsInitialized.rawValue):", UserDefaults.standard.bool(forKey: KeyValue.isSettingsInitialized.rawValue))
        print("UserDefault \(KeyValue.isSurveyEnabled.rawValue):", UserDefaults.standard.bool(forKey: KeyValue.isSurveyEnabled.rawValue))
        print("UserDefault \(KeyValue.surveyInterval.rawValue):", UserDefaults.standard.double(forKey: KeyValue.surveyInterval.rawValue))
        print("UserDefault \(KeyValue.surveyIntervalIndex.rawValue):", UserDefaults.standard.integer(forKey: KeyValue.surveyIntervalIndex.rawValue))
        print("UserDefault \(KeyValue.alertMessage.rawValue):", UserDefaults.standard.integer(forKey: KeyValue.alertMessage.rawValue))
    }
    
    func setAlertMessage(_ newAlertMessage: String) {
        self.alertMessage = newAlertMessage
        userDefaults.set(newAlertMessage, forKey: KeyValue.alertMessage.rawValue)
        logVariables()
    }
    
    func setSurveyInterval(_ newSurveyIntervalIndex: Int) {
        switch newSurveyIntervalIndex {
            case SURVEY_INTERVAL_INDEX_30MIN:
                self.surveyInterval = SURVEY_INTERVAL_30MIN
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_30MIN
            case SURVEY_INTERVAL_INDEX_1HR:
                self.surveyInterval = SURVEY_INTERVAL_1HR
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_1HR
            case SURVEY_INTERVAL_INDEX_2HR:
                self.surveyInterval = SURVEY_INTERVAL_2HR
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_2HR
            default:
                self.surveyInterval = SURVEY_INTERVAL_3HR
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_3HR
        }
        userDefaults.set(surveyInterval, forKey: KeyValue.surveyInterval.rawValue)
        userDefaults.set(surveyIntervalIndex, forKey: KeyValue.surveyIntervalIndex.rawValue)
        logVariables()
    }
    
    func setSurveyEnabled(_ isSurveyEnabled: Bool) {
        self.isSurveyEnabled = isSurveyEnabled
        userDefaults.set(isSurveyEnabled, forKey: KeyValue.isSurveyEnabled.rawValue)
        logVariables()
    }
    
    func logVariables() {
        print("UserDefault \(KeyValue.isSettingsInitialized.rawValue):", UserDefaults.standard.bool(forKey: KeyValue.isSettingsInitialized.rawValue))
        print("UserDefault \(KeyValue.isSurveyEnabled.rawValue):", UserDefaults.standard.bool(forKey: KeyValue.isSurveyEnabled.rawValue))
        print("UserDefault \(KeyValue.surveyInterval.rawValue):", UserDefaults.standard.double(forKey: KeyValue.surveyInterval.rawValue))
        print("UserDefault \(KeyValue.surveyIntervalIndex.rawValue):", UserDefaults.standard.integer(forKey: KeyValue.surveyIntervalIndex.rawValue))
        print("UserDefault \(KeyValue.alertMessage.rawValue):", UserDefaults.standard.integer(forKey: KeyValue.alertMessage.rawValue))
        print("settingsManager.\(KeyValue.isSettingsInitialized.rawValue): \(self.isSettingsInitialized)")
        print("settingsManager.\(KeyValue.isSurveyEnabled.rawValue): \(self.isSurveyEnabled)")
        print("settingsManager.\(KeyValue.surveyInterval.rawValue): \(self.surveyInterval)")
        print("settingsManager.\(KeyValue.surveyIntervalIndex.rawValue): \(self.surveyIntervalIndex)")
        print("settingsManager.\(KeyValue.alertMessage.rawValue): \(self.alertMessage)")
    }
}
