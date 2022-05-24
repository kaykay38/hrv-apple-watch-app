//
//  SettingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/26/22.
//

import SwiftUI

struct SettingView: View {
    @State private var showSurvey = false
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    
    @AppStorage("survey") var surveyActivated = false
    
    @AppStorage("surveryInterval") var surveyInterval = -3600
    @AppStorage("surveryIntervalIndex") var surveyIntervalIndex = 1
    
    var frameworks = ["30 Min.", "1 Hr.", "2 Hr.", "3 Hr."]
    @State private var selectedFrameworkIndex = UserDefaults.standard.integer(forKey: "surveryIntervalIndex")
    
        var body: some View {
            
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.title3)
                Divider()
                Form {
                    Section(footer: Text("Improves accuracy for stress dectection.")){
                        Toggle(isOn: $surveyActivated) {
                            Text("Stress Survey")
                        }
                    }
                    Section(footer: Text("Time interval for reminder to log your current stress level.")){
                                    Picker(selection: $selectedFrameworkIndex, label: Text("Survey Interval")) {
                                        ForEach(0 ..< frameworks.count) {
                                            Text(self.frameworks[$0])
                                        }
                                    }.onChange(of: selectedFrameworkIndex) { newValue in
                                        if(selectedFrameworkIndex == 0) {
                                            surveyInterval = -30
                                            surveyIntervalIndex = 0
                                        }
                                        if(selectedFrameworkIndex == 1)
                                        {
                                            surveyInterval = -3600
                                            surveyIntervalIndex = 1
                                        }
                                        if(selectedFrameworkIndex == 2)
                                        {
                                            surveyInterval = -7200
                                            surveyIntervalIndex = 2
                                        }
                                        if(selectedFrameworkIndex == 3)
                                        {
                                            surveyInterval = -108000
                                            surveyIntervalIndex = 3
                                        }
                                    }
                                }
                }
            }
      }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
