//
//  TodayChartView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/19/22.
//

import SwiftUI
import SwiftUICharts

struct TodayChartView: View {
    @ObservedObject var healthKitController = HealthKitController()
    
    var body: some View {
        LineView(data: healthKitController.today, title: "Past 24 Hours", legend: "Hourly Average")
            .padding()
    }
}

struct TodayChartView_Previews: PreviewProvider {
    static var previews: some View {
        TodayChartView()
    }
}
