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
        case survey, controls, liveHRV, stats, table, setting
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
                SettingView().tag(Tab.setting)
            }
            .sheet(isPresented: $notificationManager.thankYou) { ThankYouView()}
            .sheet(isPresented: $notificationManager.activeSurvey, content: {SurveyView()})
            .sheet(isPresented: $notificationManager.activeAlert, content: {
                NotificationView()
                    })
    }
    else {
        TabView(selection: $notRunningSelection) {
            ChartView().tag(Tab.liveHRV)
            SettingView()
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

