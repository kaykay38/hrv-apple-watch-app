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
    
        var body: some View {
            
            VStack(alignment: .leading) {
                Label("Settings", systemImage: "hand.tap")
                    .font(.title3)
                Divider()
                Form {
                    Toggle(isOn: $surveyActivated) {
                        Text("Setting Activated")
                    }
                }
            }.padding()
      }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
