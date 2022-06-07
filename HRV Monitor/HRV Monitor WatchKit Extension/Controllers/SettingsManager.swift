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
    
    @Published var isSurveyEnabled: Bool = UserDefaults.standard.bool(forKey: KeyValue.isSurveyEnabled.rawValue)
    @Published private(set) var surveyInterval: Double = UserDefaults.standard.double(forKey: KeyValue.surveyInterval.rawValue)
    @Published var surveyIntervalIndex: Int = UserDefaults.standard.integer(forKey: KeyValue.surveyIntervalIndex.rawValue)
    private(set) var isSettingsInitialized: Bool = UserDefaults.standard.bool(forKey: KeyValue.isSettingsInitialized.rawValue)
    
    override init() {
        if !isSettingsInitialized {
            isSurveyEnabled = false
            surveyInterval = SURVEY_INTERVAL_3_HR
            surveyIntervalIndex = SURVEY_INTERVAL_INDEX_3_HR
            isSettingsInitialized = true
            userDefaults.set(false,forKey: KeyValue.isSurveyEnabled.rawValue)
            userDefaults.set(SURVEY_INTERVAL_3_HR,forKey: KeyValue.surveyInterval.rawValue)
            userDefaults.set(SURVEY_INTERVAL_INDEX_3_HR,forKey: KeyValue.surveyIntervalIndex.rawValue)
            userDefaults.set(true,forKey: KeyValue.isSettingsInitialized.rawValue)
        }
        else {
            isSurveyEnabled = UserDefaults.standard.bool(forKey: KeyValue.isSurveyEnabled.rawValue)
            surveyInterval = UserDefaults.standard.double(forKey: KeyValue.surveyInterval.rawValue)
            surveyIntervalIndex = UserDefaults.standard.integer(forKey: KeyValue.surveyIntervalIndex.rawValue)
            isSettingsInitialized = UserDefaults.standard.bool(forKey: KeyValue.isSettingsInitialized.rawValue)
        }
        print("Initializing Settings...")
        print("UserDefault \(KeyValue.isSettingsInitialized.rawValue):", UserDefaults.standard.bool(forKey: KeyValue.isSettingsInitialized.rawValue))
        print("UserDefault \(KeyValue.isSurveyEnabled.rawValue):", UserDefaults.standard.bool(forKey: KeyValue.isSurveyEnabled.rawValue))
        print("UserDefault \(KeyValue.surveyInterval.rawValue):", UserDefaults.standard.double(forKey: KeyValue.surveyInterval.rawValue))
        print("UserDefault \(KeyValue.surveyIntervalIndex.rawValue):", UserDefaults.standard.integer(forKey: KeyValue.surveyIntervalIndex.rawValue))
    }
    
    func setSurveyInterval(_ newSurveyIntervalIndex: Int) {
        switch newSurveyIntervalIndex {
            case SURVEY_INTERVAL_INDEX_30_MIN:
                self.surveyInterval = SURVEY_INTERVAL_30_MIN
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_30_MIN
            case SURVEY_INTERVAL_INDEX_1_HR:
                self.surveyInterval = SURVEY_INTERVAL_1_HR
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_1_HR
            case SURVEY_INTERVAL_INDEX_2_HR:
                self.surveyInterval = SURVEY_INTERVAL_2_HR
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_2_HR
            default:
                self.surveyInterval = SURVEY_INTERVAL_3_HR
                self.surveyIntervalIndex = SURVEY_INTERVAL_INDEX_3_HR
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
        print("settingsManager.\(KeyValue.isSettingsInitialized.rawValue): \(self.isSettingsInitialized)")
        print("settingsManager.\(KeyValue.isSurveyEnabled.rawValue): \(self.isSurveyEnabled)")
        print("settingsManager.\(KeyValue.surveyInterval.rawValue): \(self.surveyInterval)")
        print("settingsManager.\(KeyValue.surveyIntervalIndex.rawValue): \(self.surveyIntervalIndex)")
    }
}
