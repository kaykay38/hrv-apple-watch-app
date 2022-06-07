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
            VStack {
                if(workoutManager.running) {
                    if (!workoutManager.hrvCalculator.canWriteToHealthKit) {
                        VStack{
                            Spacer()
                            Text("Initalizing HRV")
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            LoadingView()
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("HRV")
                                .font(.title2)
                            HStack {
                                Text(
                                    workoutManager.HRV
                                        .formatted(
                                            .number.precision(.fractionLength(0))
                                        )
                                ).font(.largeTitle);
                                Spacer()
                                if(workoutManager.hrvClassificationController.alert) {
                                    Label("Warning", systemImage: "exclamationmark.circle")
                                        .font(.title3)
                                        .foregroundColor(.red);
                                }else if(workoutManager.hrvClassificationController.warning) {
                                    Label("Moderate", systemImage: "minus.circle")
                                        .font(.title3)
                                        .foregroundColor(.yellow);
                                }else{
                                    Label("Good", systemImage: "hand.thumbsup.circle")
                                        .font(.title3)
                                        .foregroundColor(.green);
                                }
                            }
                            
                        }
                    }
                    if(workoutManager.HRV != 0 && workoutManager.hrvChartArray.count < 12) {
                        VStack (alignment: .center){
                            Spacer()
                            Text("Loading Graph")
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                            LoadingView()
                                .foregroundColor(.gray)
                        }
                        
                    }else{
                        if(workoutManager.hrvClassificationController.alert) {
                            Chart(data: workoutManager.hrvChartArray)
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: .red, lineWidth: 4)
                                )
                        }else if(workoutManager.hrvClassificationController.warning) {
                            Chart(data: workoutManager.hrvChartArray)
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: .yellow, lineWidth: 4)
                                )
                        }else{
                            Chart(data: workoutManager.hrvChartArray)
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: .green, lineWidth: 4)
                                )
                        }
                    }
                    
                }else{
                    VStack(alignment: .leading){
                        Text("HRV")
                            .font(.title2)
                        Text("No Data")
                            .font(.title3)
                        Text("Start Session To Display HRV")
                            .foregroundColor(.gray)
                        Spacer()
                        Button {
                            workoutManager.startWorkout()
                        } label: {
                            Text("Start")
                                .font(.title3)
                        }.foregroundColor(.green).frame(height: 20)
                            .tint(.green)
                    }
                }
            }
        }.padding()
        
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
