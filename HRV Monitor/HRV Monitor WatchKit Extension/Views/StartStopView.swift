//
//  StartStopView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/17/22.
//  Currently not the starting point for the application

import SwiftUI

struct StartStopView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var isMonitoring = false
    var body: some View {
        VStack {
//            Button {
//                if isMonitoring {
//                    workoutManager.endWorkout()
//                    isMonitoring = false
//                }
//                else {
//                    workoutManager.startWorkout()
//                    isMonitoring = true
//                }
//            } label: {
//                startStopTextToggle(isMonitoring)
//            }
            if isMonitoring {
                Text("Stop").font(.title).padding(.bottom, 10)
                Button {
                    workoutManager.endWorkout()
                    isMonitoring = false
                } label: {
                    Image(systemName: "stop.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
                }.foregroundColor(.red)
            }
            else {
                Text("Start").font(.title).padding(.bottom, 10)
                Button {
                    workoutManager.startWorkout()
                    isMonitoring = true
                } label: {
                    Image(systemName: "play.fill").font(.title).padding(.top, 3).padding(.bottom, 3);
                }.foregroundColor(.green)
            }
        }
        .padding()
        .onAppear(perform: workoutManager.requestAuthroization)
    }
}

func startStopTextToggle(_ isMonitoring: Bool) -> AnyView {
    if isMonitoring {
        return AnyView(VStack {
            Text("Stop").fontWeight(.bold);
            Image(systemName: "stop").font(.title).padding(.top, 3).padding(.bottom, 3);
        }.foregroundColor(.red))

    }
    return AnyView(VStack{
        Text("Start").fontWeight(.bold);
        Image(systemName: "play").font(.title).padding(.top, 3).padding(.bottom, 3);
    }.foregroundColor(.green))

}

struct StartStopView_Previews: PreviewProvider {
    static var previews: some View {
    StartStopView()
    }
}
