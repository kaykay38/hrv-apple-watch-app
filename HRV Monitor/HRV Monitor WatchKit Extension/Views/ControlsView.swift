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
                Text("Stop").font(.title).padding(.bottom, 10)
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "stop.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
                }.foregroundColor(.red)
            }
            else {
                Text("Start").font(.title).padding(.bottom, 10)
                Button {
                    workoutManager.startWorkout()
                } label: {
                    Image(systemName: "play.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
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
