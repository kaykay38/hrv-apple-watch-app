//
//  SevenDayChartView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/19/22.
//

import SwiftUI
import SwiftUICharts

struct SevenDayChartView: View {
    @ObservedObject var healthKitController = HealthKitController()
    var body: some View {
        LineView(data: healthKitController.last7Days, title: "Past 7 Days", legend: "Daily Average")
            .padding()
            .onAppear(perform: healthKitController.getLast7Days)
        
    }
}

struct SevenDayChartView_Previews: PreviewProvider {
    static var previews: some View {
        SevenDayChartView()
    }
}
