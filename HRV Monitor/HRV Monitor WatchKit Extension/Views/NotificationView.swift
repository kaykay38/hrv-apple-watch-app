//
//  NotificationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

/*import SwiftUI
import WatchKit

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject var surveyManager = SurveyManager()
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
                
                Button("schedule notification"){
                 NotificationManager.instance.scheduleHighNotification()
                }
                
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
                    }.sheet(isPresented: $showingSurvey) {SurveyView(surveyManager: SurveyManager())}
                    
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
 
 }*/

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var modalState: ModalState
    @ObservedObject var hapticController: HapticController = HapticController.instance
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    
    var body: some View {
        Button("schedule notification"){
         NotificationManager.instance.scheduleHighNotification()
        }
        
        VStack {
            HStack{
                Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
             
                Text("Episode Detected").font(.title3).padding(.bottom, 10)
            }
        
            Button {
                self.modalState.isModal1Presented = true
            } label: {
                Text("False Alarm")
                    .font(.title3)
                    .foregroundColor(.green);
            }.padding(.top, 10)
                .sheet(isPresented: $modalState.isModal1Presented) {
                    ModalView(modalState: self.modalState)
                }
        
        Button("Dismiss") {
            NotificationManager.instance.activeAlert = false
        }.onAppear(perform: hapticController.triggerHaptic)
    }
 }
}
// modal 1
struct ModalView: View {
    @ObservedObject var modalState: ModalState
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    var body: some View {
        VStack {
            ScrollView{
                Text("What's your stress level?").font(.title3).padding(.top, 5)
                
                Button {
                    self.modalState.isModal1Presented = false
                    NotificationManager.instance.activeAlert = false
                    //self.modalState.isModal2Presented = true
                } label: {
                    Text("Low")
                        .font(.title3)
                        .foregroundColor(.green);
                }.padding(.top, 10)
                    /*.sheet(isPresented: $modalState.isModal2Presented) {
                        Modal2(modalState: self.modalState)
                    }*/
                
                Button {
                    self.modalState.isModal1Presented = false
                    NotificationManager.instance.activeAlert = false
                    //self.modalState.isModal2Presented = true
                } label: {
                    Text("Moderate")
                        .font(.title3)
                        .foregroundColor(.yellow);
                }.padding(.top, 10)
                    /*.sheet(isPresented: $modalState.isModal2Presented) {
                        Modal2(modalState: self.modalState)
                    }*/
                
                Button {
                    self.modalState.isModal1Presented = false
                    NotificationManager.instance.activeAlert = false
                    //self.modalState.isModal2Presented = true
                } label: {
                    Text("High")
                        .font(.title3)
                        .foregroundColor(.red);
                }.padding(.top, 10)
                    /*.sheet(isPresented: $modalState.isModal2Presented) {
                        Modal2(modalState: self.modalState)
                    }*/
                
                Button {
                    self.modalState.isModal1Presented = false
                    NotificationManager.instance.activeAlert = false
                    //self.modalState.isModal2Presented = true
                } label: {
                    Text("Very High")
                        .font(.title3)
                        .foregroundColor(.purple);
                }.padding(.top, 10)
                    /*.sheet(isPresented: $modalState.isModal2Presented) {
                        Modal2(modalState: self.modalState)
                    }*/
                
           /* Button("Dismiss") {
                self.modalState.isModal1Presented = false
                NotificationManager.instance.activeAlert = false
            }*/
          }
        }
    }
}
// modal 2
/*struct Modal2: View {
    @ObservedObject var modalState: ModalState
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    var body: some View {
        VStack {
            Text("Are you sure?").font(.title3).padding(.top, 10)
            
            Button {
                self.modalState.isModal1Presented = false
                self.modalState.isModal2Presented = false
                NotificationManager.instance.activeAlert = false
            } label: {
                Text("Go Back")
                    .font(.subheadline)
            }.foregroundColor(.white)
            .padding()
            
        }
    }
}*/
    

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(modalState: ModalState())
    }
}

