//
//  ChartView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Live HRV")
                .font(.title2)
            
            HStack {
                Label("Good", systemImage: "hand.thumbsup.circle")
                    .font(.title3)
                    .foregroundColor(.green);
                Text("158")
                    .font(.title3);
            }
            Chart(data: [0.1, 0.3, 0.2, 0.5, 0.4, 0.9, 0.1])
                .chartStyle(
                    LineChartStyle(.quadCurve, lineColor: .blue, lineWidth: 5)
                )
        }
        .padding()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .previewDevice("Apple Watch Series 5 - 40mm")
        ChartView()
            .previewDevice("Apple Watch Series 7 - 45mm")
    }
}
