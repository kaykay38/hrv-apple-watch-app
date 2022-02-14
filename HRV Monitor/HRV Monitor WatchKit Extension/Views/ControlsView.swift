//
//  ControlsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            Button {
                workoutManager.endWorkout()
            }label: {
                VStack {
                    Text("Stop Monitoring HRV");
                    Image(systemName: "Square");
                }
            }.foregroundColor(.green);
        }
        .padding()
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
