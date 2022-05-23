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
    
        var body: some View {
            VStack(alignment: .leading) {
                Label("Settings", systemImage: "hand.tap")
                    .font(.title3)
                Divider()
                Toggle("Survey Notifications", isOn: $showSurvey)
                    .onChange(of: showSurvey, perform: { newValue in
                        NotificationManager.instance.settingsUpdated = true
                    })
                    .onChange(of: showSurvey) { value in
                        NotificationManager.instance.settingSurveyOn.toggle()
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    /*.onChange(of: showSurvey) { value in
                        NotificationManager.instance.SettingSurveyOn.toggle()
                    }*/
            }.padding()
      }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
