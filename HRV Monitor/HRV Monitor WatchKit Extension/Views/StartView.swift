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
            Text("Start").font(.title).padding(.bottom, 10)
            Button {
                workoutManager.startWorkout()
            } label: {
                Image(systemName: "play.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
            }.foregroundColor(.green)
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
