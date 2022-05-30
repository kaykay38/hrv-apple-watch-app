//
//  SettingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/26/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    
    @AppStorage("survey") var surveyActivated = false
    
    @State @AppStorage("surveyInterval") var surveyInterval = 0
    @State @AppStorage("surveyIntervalIndex") var surveyIntervalIndex = 0
    @State @AppStorage("isFirstTime") var isFirstTime = true;
    
    var frameworks = ["Please Select Interval", "30 Min.", "1 Hr.", "2 Hr.", "3 Hr."]
    @State private var selectedFrameworkIndex = UserDefaults.standard.integer(forKey: "surveyIntervalIndex")
    @State private var surveyActive = UserDefaults.standard.bool(forKey: "survey")
    
        var body: some View {
            
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.title3)
                Divider()
                Form {
                    Section(footer: Text("Popup survey to improve accuracy of stress prediction.")){
                        Toggle(isOn: $surveyActivated) {
                            Text("Stress Survey")
                        }
                    }
                    if (surveyActivated) {
                        Section(footer: Text("Time interval between survey occurence.")){
                            Picker(selection: $selectedFrameworkIndex, label: Text("Survey Interval")) {
                                ForEach(0 ..< frameworks.count) {
                                    Text(self.frameworks[$0])
                                }
                            }.onChange(of: selectedFrameworkIndex) { newValue in
                                if(selectedFrameworkIndex == 1) {
                                    surveyInterval = -1800
                                    surveyIntervalIndex = 1
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
//            }.onAppear{
//                print("on Appear \(isFirstTime)")
//                if(isFirstTime) {
//                    print("made it in!!")
//                    surveyInterval = -1800
//                    surveyIntervalIndex = 0
//                    isFirstTime = false
//                    print("surveyIntervalIndex:", surveyIntervalIndex)
//                    print("isFirstTime:", isFirstTime)
//                    print("surveyInterval:", surveyInterval)
//                }
            }
      }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
