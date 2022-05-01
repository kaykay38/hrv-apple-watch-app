//
//  NotificationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI
import WatchKit

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject var navigationManager = NavigationManager()
    @ObservedObject var hapticController: HapticController = HapticController.instance
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSurvey = false
    
    /*(workoutManager.navigate == true){
        presentationMode.wrappedValue.dismiss()
    }*/
    
    // each if button equals true, go on that route
    var body: some View {
            NavigationView{
                // if false alarm, go to graph
                // if dismiss, go to survey
                /*Button("request permission"){
                    NotificationManager.instance.requestAuthorization()
                }*/
                
                /*Button("schedule notification"){
                 NotificationManager.instance.scheduleHighNotification()
                }*/
                
                VStack {
                    HStack{
                        Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
                     
                        Text("Episode Detected").font(.title3).padding(.bottom, 10)
                    }
                    
                    Button {
                        showingSurvey = true
                    } label: {
                        Text("False Alarm")
                            .font(.title3)
                            .foregroundColor(.green);
                    }.sheet(isPresented: $showingSurvey) {SurveyView(navigationManager: NavigationManager())}
                    
                   /* NavigationLink(destination: SurveyView()){
                        Text("False Alarm")
                            .font(.title3)
                            .foregroundColor(.green);
                    }.navigationBarHidden(true)*/
                
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                .onAppear(perform: hapticController.triggerHaptic)
            }
        }
 
 }

    

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
}
