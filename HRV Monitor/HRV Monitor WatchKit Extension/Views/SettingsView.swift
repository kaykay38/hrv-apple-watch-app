//
//  SettingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/26/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.instance
    @ObservedObject var settingsManager: SettingsManager = NotificationManager.instance.settingsManager
    
    var intervalOptions = [
        SURVEY_INTERVAL_OPTION_30MIN,
        SURVEY_INTERVAL_OPTION_1HR,
        SURVEY_INTERVAL_OPTION_2HR,
        SURVEY_INTERVAL_OPTION_3HR
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(SETTINGS_PAGE_TITLE)
                .font(.title3)
            Divider()
            Form {
                Section(footer: Text(SETTINGS_SURVEY_TOGGLE_DESCRIPTION_FOOTER)){
                    Toggle(isOn: $settingsManager.isSurveyEnabled) {
                        Text(STRESS_SURVEY_LABEL)
                    }
                }.onChange(of: settingsManager.isSurveyEnabled) { newValue in
                    settingsManager.setSurveyEnabled(newValue)
                }
                if (settingsManager.isSurveyEnabled) {
                    Section(footer: Text(SETTINGS_SURVEY_INTERVAL_DESCRIPTION_FOOTER)){
                        Picker(selection: $settingsManager.surveyIntervalIndex, label: Text(SURVEY_INTERVAL_LABEL)) {
                            ForEach(0 ..< intervalOptions.count) {
                                Text(self.intervalOptions[$0])
                            }
                        }.onChange(of: settingsManager.surveyIntervalIndex) { newValue in
                            settingsManager.setSurveyInterval(newValue)
                        }
                    }
                    
                }
                
                Section(header: Text(SETTINGS_HIGH_STRESS_ALERT_MESSAGE_LABEL), footer: Text(SETTINGS_HIGH_STRESS_ALERT_MESSAGE_DESCRIPTION_FOOTER)) {
                    TextField(text: $settingsManager.alertMessage) {
                    }.onChange(of: settingsManager.alertMessage) { newValue in
                        settingsManager.setAlertMessage(newValue)
                    }
                }
            }
        }
    }
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
}
