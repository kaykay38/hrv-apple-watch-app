//
//  SettingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/26/22.
//

import SwiftUI

struct SettingView: View {
    @State private var showSurvey = false

        var body: some View {
            VStack(alignment: .leading) {
                Label("Settings", systemImage: "hand.tap")
                    .font(.title3)
                Divider()
                Toggle("Survey Notifications", isOn: $showSurvey)
                    .toggleStyle(SwitchToggleStyle(tint: .green))

                if showSurvey {
                    //Text("Hello World!")
                }
            }.padding()
      }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
