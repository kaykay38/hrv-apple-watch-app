//
//  ThankYouView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 5/9/22.
//

import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Are you sure?").font(.title3).padding(.top, 30)
            }

        
        Button("Confirm") {
            NotificationManager.instance.activeAlert = false
            NotificationManager.instance.activeSurvey = false
            NotificationManager.instance.thankYou = false
        }.font(.title3).tint(.green)
        
        Button("Go Back") {
            NotificationManager.instance.thankYou = false
        }.font(.title3).tint(.gray).foregroundColor(.white)
    }
    
  }
 }

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConfirmationView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
    }
}
