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
    @State private var runningSelection: Tab = .liveHRV
    @State private var notRunningSelection: Tab = .liveHRV
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    @EnvironmentObject var workoutManager: WorkoutManager

    
    enum Tab {
        case survey, controls, liveHRV, stats, table, settings
    }
    
    var body: some View {
        if(workoutManager.running) {
            TabView(selection: $runningSelection) {
                //NotificationView(modalState: ModalState())
                SurveyView().tag(Tab.survey)
                ControlsView().tag(Tab.controls)
                ChartView().tag(Tab.liveHRV)
    //            AreaChartView().tag(Tab.liveHRV)
                // HRVSimpleView().tag(Tab.liveHRV)
                StatisticsView().tag(Tab.stats)
    //            TableView().tag(Tab.table)
                SettingsView().tag(Tab.settings)
            }
            .sheet(isPresented: $notificationManager.isConfirmed) { ConfirmationView()}
            .sheet(isPresented: $notificationManager.isSurveyActive, content: {SurveyView()})
            .sheet(isPresented: $notificationManager.isAlertActive, content: {
                NotificationView()
                    })
    }
    else {
        TabView(selection: $notRunningSelection) {
            ChartView().tag(Tab.liveHRV)
            SettingsView().tag(Tab.settings)
        }
        .onAppear(perform: workoutManager.requestAuthorization)
        .onAppear(perform: NotificationManager.instance.requestAuthorization)
    }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        PagingView()
    }
}

