//
//  TabView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI
import WatchKit
import UserNotifications

struct PagingView: View {
    @State private var selection: Tab = .liveHRV
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    @EnvironmentObject var workoutManager: WorkoutManager
    
    enum Tab {
        case controls, liveHRV, stats, table
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NotificationView()
            SurveyView()
            ConfirmationView()
            ControlsView().tag(Tab.controls)
            // ChartView().tag(Tab.liveHRV)
            AreaChartView().tag(Tab.liveHRV)
            // HRVSimpleView().tag(Tab.liveHRV)
            StatisticsView().tag(Tab.stats)
            TableView().tag(Tab.table)
        }
        .onAppear(perform: workoutManager.requestAuthorization)
        .onAppear(perform: NotificationManager.instance.requestAuthorization)
        .sheet(isPresented: $notificationManager.activeAlert, content: {
                    NotificationView()
                })
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        PagingView()
    }
}

