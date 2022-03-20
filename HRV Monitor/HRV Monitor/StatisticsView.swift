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
            Divider()
            Text("Average: \(healthKitController.avgHRV)")
                .font(.title)
            Divider()
            Text("Minimum: \(healthKitController.minHRV)")
                .font(.title)
            Spacer()
        }.padding()
            .onAppear(perform: healthKitController.getAVG)
            .onAppear(perform: healthKitController.getMax)
            .onAppear(perform: healthKitController.getMin)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
