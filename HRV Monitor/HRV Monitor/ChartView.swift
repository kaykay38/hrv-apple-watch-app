//
//  ChartView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/18/22.
//

import SwiftUI
import SwiftUICharts
import UIKit

struct ChartView: View {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
    @ObservedObject var healthKitController = HealthKitController()
    var body: some View {
        ScrollView{
            VStack{
                TodayChartView()
                    .frame(width: ChartView.screenWidth, height: 400)
                Spacer()
                SevenDayChartView()
                    .frame(width: ChartView.screenWidth, height: 400)
                Spacer()
                ThirtyDayChartView()
                    .frame(width: ChartView.screenWidth, height: 400)
                Spacer()
            }
        }.padding()
            .onAppear(perform: healthKitController.getCharts)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .preferredColorScheme(.dark)
    }
}
