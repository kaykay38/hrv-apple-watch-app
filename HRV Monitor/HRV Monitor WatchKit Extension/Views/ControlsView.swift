//
//  ControlsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/17/22.
//  Currently not the starting point for the application

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            // TODO: temporarily disable button for x seconds after function call.
            if workoutManager.running {
                Spacer(minLength: 5)
                Text(RUNNING_LABEL)
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer(minLength: 10)
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Text(STOP_LABEL)
                        .font(.title)
                }.foregroundColor(.red)
                    .tint(.red)
            }
            else {
                Spacer(minLength: 5)
                Text(STOPPED_LABEL)
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer(minLength: 10)
                Button {
                    workoutManager.startWorkout()
                } label: {
                    Text(START_LABEL)
                        .font(.title)
                }.foregroundColor(.green)
                    .tint(.green)
            }
        }
        .padding()
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
    ControlsView()
    }
}
