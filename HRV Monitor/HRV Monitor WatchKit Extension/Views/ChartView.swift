//
//  ChartView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading) {
                Text("Live HR")
                    .font(.title2)
                if(workoutManager.HRV != 0) {
                    HStack {
                        if(workoutManager.hrvCalculator.isHigh()) {
                            Label("High", systemImage: "hand.thumbsdown.circle")
                                .font(.title3)
                                .foregroundColor(.red);
                        }else if(workoutManager.hrvCalculator.isLow()) {
                            Label("Low", systemImage: "hand.thumbsdown.circle")
                                .font(.title3)
                                .foregroundColor(.red);
                        }else{
                            Label("Good", systemImage: "hand.thumbsup.circle")
                                .font(.title3)
                                .foregroundColor(.green);
                        }
                        
                        Text(
                            workoutManager.HRV
                                .formatted(
                                    .number.precision(.fractionLength(0))
                                )
                        )
                        .font(.title3);
                    }
                }
                ZStack {
                    if(workoutManager.hrvArray.count < 10) {
                        if(workoutManager.running == true) {
                            VStack{
                                Spacer()
                                Text("Initalizing Data")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    
                                Spacer()
                                LoadingView()
                                    .foregroundColor(.gray)
                            }
                        }else{
                            VStack(alignment: .leading){
                                Spacer()
                                Text("No Data")
                                    .font(.title3)
                                Text("Start Session To Begin Collecting Data")
                                    .foregroundColor(.gray)
                            }
                        }
                    }else{
//                        Chart(data: workoutManager.arraydiffHR)
//                            .chartStyle(
//                                LineChartStyle(.line, lineColor: .gray, lineWidth: 3)
//                            )
                        Chart(data: workoutManager.hrvArray)
                            .chartStyle(
                                LineChartStyle(.line, lineColor: .blue, lineWidth: 4)
                            )
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
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
