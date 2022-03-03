//
//  ChartView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI
import Charts

var demoData: [Double] = [0.1,0.3,0.5]
var demoData2: [Double] = [0.0,0.1,0.6]

struct ChartView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading) {
                Text("Live HRV")
                    .font(.title2)
                
                HStack {
                    if(workoutManager.heartRate > 100) {
                        Label("High", systemImage: "hand.thumbsdown.circle")
                            .font(.title3)
                            .foregroundColor(.red);
                    }else if(workoutManager.heartRate < 60) {
                        Label("Low", systemImage: "hand.thumbsdown.circle")
                            .font(.title3)
                            .foregroundColor(.red);
                    }else{
                        Label("Good", systemImage: "hand.thumbsup.circle")
                            .font(.title3)
                            .foregroundColor(.green);
                    }
                    
                    Text(
                        workoutManager.heartRate
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                    )
                    .font(.title3);
                }
                ZStack {
                    Chart(data: demoData)
                        .chartStyle(
                            LineChartStyle(.quadCurve, lineColor: .blue, lineWidth: 5)
                        )
                    Chart(data: demoData2)
                        .chartStyle(
                            LineChartStyle(.quadCurve, lineColor: .gray, lineWidth: 5)
                        )
                }
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
