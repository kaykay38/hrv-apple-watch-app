//
//  UpdatedSettingsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 5/22/22.
//

import SwiftUI

struct UpdatedSettingsView: View {
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Settings Updated!").font(.title3).padding(.top, 30)
            }
        
        Button("Dismiss") {
            NotificationManager.instance.isSettingsUpdated = false
        }.font(.title3).tint(.green)
    }
    
  }
 }

struct UpdatedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatedSettingsView()
    }
}
