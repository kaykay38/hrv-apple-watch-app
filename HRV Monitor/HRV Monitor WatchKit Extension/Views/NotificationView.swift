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
    
    // make a boolean for each button
    var falseAlarm = false
    var dismiss = false
    
    // each if button equals true, go on that route
        var body: some View {
            // if false alarm, go to graph
            // if dismiss, go to survey
            VStack {
                HStack{
                    Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
                 
                        Text("Episode Detected").font(.title3).padding(.bottom, 10)
                }
                Button {
                    // workoutManager.endWorkout() // method for survey
                } label: {
                    Text("False Alarm")
                        .font(.subheadline)
                }.foregroundColor(.green)
                .padding()
                
                Button { // touch dismiss Go back to chart view
                    workoutManager.resume()
                } label: {
                    Text("Dismiss")
                        .font(.subheadline)
                }
                .frame(height: 11.0)
                .foregroundColor(.white)
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
