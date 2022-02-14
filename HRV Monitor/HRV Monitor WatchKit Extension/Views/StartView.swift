//
//  ContentView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//  Currently not the starting point for the application

import SwiftUI

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        VStack {
            Button {
                workoutManager.startWorkout()
            }label: {
                VStack {
                    Text("Start Monitoring HRV");
                    Image(systemName: "play");
                }
            }.foregroundColor(.green);
        }
        .padding()
        .onAppear(perform: workoutManager.requestAuthroization)
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
