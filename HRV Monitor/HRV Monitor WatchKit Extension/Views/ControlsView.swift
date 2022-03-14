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
            if workoutManager.running {
                Spacer()
                Text("Collecting Data")
                    .font(.title3)
                    .foregroundColor(.gray)
                    
                Spacer()
                LoadingView()
                    .foregroundColor(.gray)
                Spacer()
                
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Text("Stop")
                        .font(.title)
                }.foregroundColor(.red)
            }
            else {
                Button {
                    workoutManager.startWorkout()
                } label: {
                    Text("Start")
                        .font(.title)
                }.foregroundColor(.green)
            }
        }
        .padding()
        //.onAppear(perform: workoutManager.requestAuthroization)
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
    ControlsView()
    }
}
