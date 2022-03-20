//
//  ContentView.swift
//  HRV Monitor
//
//  Created by Mia on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var healthKitController = HealthKitController()
    
    var body: some View {
        VStack(alignment: .leading) {
            BannerView()
                .padding(.bottom, 13.0)
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                ChartView().tabItem { Image(systemName: "chart.xyaxis.line"); Text("Graphs") }.tag(1)
                StatisticsView().tabItem { Image(systemName: "heart.text.square"); Text("Past 30 Stats") }.tag(2)
                //AlertView().tabItem { Text("Alerts") }.tag(3)
//                AboutView().tabItem { Image(systemName: "info.circle"); Text("About") }.tag(3)
            }
            Spacer()
        }
        .ignoresSafeArea()
            .onAppear(perform: HealthKitController.instance.loadHKData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
