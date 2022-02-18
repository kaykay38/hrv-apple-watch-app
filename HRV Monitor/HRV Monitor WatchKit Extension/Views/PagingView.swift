//
//  TabView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI
import WatchKit

struct PagingView: View {
    
    @State private var selection: Tab = .chart
    
    enum Tab {
        case controls, chart, stats
    }
    
    var body: some View {
        TabView(selection: $selection) {
            // StartStopNavigationView().tag(Tab.controls)
            StartStopView().tag(Tab.controls)
            ChartView().tag(Tab.chart)
            StatisticsView().tag(Tab.stats)
        }
        .padding()
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        PagingView()
    }
}
