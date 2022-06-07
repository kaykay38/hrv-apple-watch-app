//
//  SettingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/26/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    @ObservedObject var settingsManager:SettingsManager = NotificationManager.instance.settingsManager
    
    var intervalOptions = ["30 Min.", "1 Hr.", "2 Hr.", "3 Hr."]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.title3)
            Divider()
            Form {
                Section(footer: Text("Popup survey to improve accuracy of stress prediction.")){
                    Toggle(isOn: $settingsManager.isSurveyEnabled) {
                        Text("Stress Survey")
                    }
                }.onChange(of: settingsManager.isSurveyEnabled) { newValue in
                    settingsManager.setSurveyEnabled(newValue)
                }
                if (settingsManager.isSurveyEnabled) {
                    Section(footer: Text("Time interval between survey occurence.")){
                        Picker(selection: $settingsManager.surveyIntervalIndex, label: Text("Survey Interval")) {
                            ForEach(0 ..< intervalOptions.count) {
                                Text(self.intervalOptions[$0])
                            }
                        }.onChange(of: settingsManager.surveyIntervalIndex) { newValue in
                            settingsManager.setSurveyInterval(newValue)
                        }
                    }
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
