//
//  HRVSimpleView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia Hunt on 3/14/22.
//

import SwiftUI
import Charts

struct HRVSimpleView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            if(workoutManager.running) {
                VStack(alignment: .center) {
                    if(workoutManager.HRV != 0) {
                        Text("HRV")
                            .font(.title2)
                        
                        Spacer()
                        
                        Text(workoutManager.HRV
                                .formatted(
                                    .number.precision(.fractionLength(0))
                                )
                        ).font(.custom("Header", fixedSize: 82));
                        
                        Spacer()
                        
                        if(workoutManager.warning) {
                            Label("Warning", systemImage: "hand.thumbsdown.circle")
                                .font(.title3)
                                .foregroundColor(.red);
                        }else if(workoutManager.alert) {
                            Label("Down", systemImage: "hand.thumbsdown.circle")
                                .font(.title3)
                                .foregroundColor(.yellow);
                        }else{
                            Label("Good", systemImage: "hand.thumbsup.circle")
                                .font(.title3)
                                .foregroundColor(.green);
                        }
                    }else {
                        Spacer()
                        Text("Initalizing Data")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        LoadingView()
                            .foregroundColor(.gray)
                        
                    }
                }.padding()
            } else {
                VStack(alignment: .leading){
                    Spacer()
                    Text("No Data")
                        .font(.title3)
                    Text("Start Session To Begin Displaying HRV")
                        .foregroundColor(.gray)
                    Spacer()
                }.padding()
                
            }
        }
        
    }
}

struct HRVSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
    }
}
