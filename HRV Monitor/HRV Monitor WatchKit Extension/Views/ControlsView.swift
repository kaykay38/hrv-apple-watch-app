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
                Text("Monitoring Started")
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer(minLength: 10)
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Text("Stop")
                        .font(.title)
                }.foregroundColor(.red)
            }
            else {
                Spacer(minLength: 5)
                Text("Monitoring Stopped")
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer(minLength: 10)
                Button {
                    workoutManager.startWorkout()
                } label: {
                    Text("Start")
                        .font(.title)
                }.foregroundColor(.green)
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
