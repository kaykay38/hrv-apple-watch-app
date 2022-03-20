//
//  ThirtyDayChartView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/19/22.
//

import SwiftUI
import SwiftUICharts

struct ThirtyDayChartView: View {
    @ObservedObject var healthKitController = HealthKitController()
    var body: some View {
        LineView(data: healthKitController.last30Days, title: "Past 30 Days", legend: "Weekly Average")
            .padding()
    }
}

struct ThirtyDayChartView_Previews: PreviewProvider {
    static var previews: some View {
        ThirtyDayChartView()
    }
}
