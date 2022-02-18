//
//  StartStopNavigationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/17/22.
//  Currently not the starting point for the application

import SwiftUI

struct StartStopNavigationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var isMonitoring = false
    var body: some View {
        VStack {
            NavigationLink(destination: PagingView(), isActive: $isMonitoring, label : {
                
                //                NavigationLink(destination: StopMonitorView(workoutManager: _workoutManager, isMonitoring: $isMonitoring), isActive: $isMonitoring, label : {
                Button {
                    if isMonitoring {
                        isMonitoring = false
                        workoutManager.endWorkout()
                    }
                    else {
                        isMonitoring = true
                        workoutManager.startWorkout()
                    }
                } label: {
                    startStopTextToggle(isMonitoring)
                }
            }).padding(0)
        }
        .onAppear(perform: workoutManager.requestAuthroization)
    }
}

// NavigationLink(destination: StartMonitorView(workoutManager: $workoutManager, isMonitoring: $isMonitoring), isActive: $isMonitoring)


struct StartMonitorView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var isMonitoring: Bool
    var body: some View {
        VStack {
            Text("Start").font(.title).padding(.bottom, 10)
            Button {
                workoutManager.startWorkout()
                isMonitoring = true
            } label: {
                Image(systemName: "play.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
            }.foregroundColor(.green)
        }
        .padding()
        .onAppear(perform: workoutManager.requestAuthroization)
    }
}

struct StopMonitorView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var isMonitoring: Bool
    var body: some View {
        VStack {
            Text("Stop").font(.title).padding(.bottom, 10)
            Button {
                workoutManager.endWorkout()
                isMonitoring = false
            } label: {
                Image(systemName: "stop.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
            }.foregroundColor(.red)
        }.padding()
        
    }
}

struct StartStopNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        StartStopNavigationView()
    }
}
