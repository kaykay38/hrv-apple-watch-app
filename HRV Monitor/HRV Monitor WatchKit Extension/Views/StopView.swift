//
//  ControlsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI

struct StopView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            Text("Stop").font(.title).padding(.bottom, 10)
            Button {
                workoutManager.endWorkout()
            } label: {
                Image(systemName: "stop.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
            }.foregroundColor(.red)
        }
        .padding()
    }
}

struct StopView_Previews: PreviewProvider {
    static var previews: some View {
        StopView()
    }
}
