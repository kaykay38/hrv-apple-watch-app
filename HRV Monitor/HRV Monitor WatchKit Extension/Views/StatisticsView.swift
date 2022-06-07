//
//  StatisticsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                Text(STATS_PAGE_TITLE)
            }
            .font(.title)
            Spacer()
            
            VStack(alignment: .leading, spacing: 9.0) {
                HStack {
                    Label(STATS_MAX_LABEL, systemImage: ICON_STATS_MAX)
                    Text(
                        workoutManager.hrvCalculator.maximumHRV
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                    )
                }.font(.title3)
                HStack {
                    Label(STATS_AVG_LABEL, systemImage: ICON_STATS_AVG)
                    Text(
                        workoutManager.hrvCalculator.averageHRV
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                    )                }.font(.title3)
                HStack {
                    Label(STATS_MIN_LABEL, systemImage: ICON_STATS_MIN)
                    Text(
                        workoutManager.hrvCalculator.minimumHRV
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                    )
                }.font(.title3)
                
            }
            Spacer()
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
