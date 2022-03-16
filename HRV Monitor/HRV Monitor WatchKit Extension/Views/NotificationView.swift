//
//  NotificationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI
import WatchKit

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var hapticController:HapticController = HapticController.instance
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
             
                    Text("Episode Detected").font(.title3).padding(.bottom, 10)
            }
            .padding()
        }
        .onAppear(perform: hapticController.triggerHaptic)
    }
}
    

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
