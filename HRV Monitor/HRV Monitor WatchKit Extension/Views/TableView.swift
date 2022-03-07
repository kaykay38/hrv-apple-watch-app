//
//  TableView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/7/22.
//

import SwiftUI

struct TableView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading) {
                Text("Alert Log")
                    .font(.title)
                ForEach(workoutManager.alertTableArray) { Alert in
                    HStack{
                        Text(Alert.direction)
                            .font(.title3)
                        Text(Alert.time)
                            .font(.title3)
                    }
                }
            }
        }
        .padding()
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
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
