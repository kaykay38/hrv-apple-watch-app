//
//  StatisticsView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/18/22.
//

import SwiftUI
import UIKit

struct StatisticsView: View {
    @ObservedObject var healthKitController = HealthKitController()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Past 30 Days HRV Statistics")
                .font(.largeTitle)
                .padding(.bottom, 20)
                .frame(width: UIScreen.main.bounds.size.width)
            Text("Maximum: \(healthKitController.maxHRV)")
                .font(.title)
                .padding(.leading)
            Divider()
            Text("Average: \(healthKitController.avgHRV)")
                .font(.title)
                .padding(.leading)
            Divider()
            Text("Minimum: \(healthKitController.minHRV)")
                .font(.title)
                .padding(.leading)
            Spacer()
        }.padding()
            .onAppear(perform: healthKitController.getStats)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
