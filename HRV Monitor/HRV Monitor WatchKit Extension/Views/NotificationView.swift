//
//  NotificationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
//    @ObservedObject var modalState: ModalState
    @ObservedObject var hapticController: HapticController = HapticController.instance
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    
    var body: some View {
//        Button("schedule notification"){
//         NotificationManager.instance.scheduleHighNotification()
//        }
        
        VStack {
            HStack{
                Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
                VStack(alignment: .leading){
                    Text("High Stress")
                    Text("Detected")
                }.font(.title3)
            }
        
            Button {
                notificationManager.activeSurvey = true
            } label: {
                Text("False Alarm")
                    .font(.title3)
            }.padding(.top, 10).tint(.red)
                
        
        Button("Dismiss") {
            NotificationManager.instance.activeAlert = false
        }.font(.title3)
                .tint(.gray)
                .foregroundColor(.white)
                .onAppear(perform: hapticController.triggerHaptic)
    }
 }
}
//// modal 1
//struct ModalView: View {
//    @ObservedObject var modalState: ModalState
//    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
//    var body: some View {
//        VStack {
//            ScrollView{
//                Text("What's your stress level?").font(.title3).padding(.top, 5)
//
//                Button {
//                    self.modalState.isModal1Presented = false
//                    NotificationManager.instance.activeAlert = false
//                    //self.modalState.isModal2Presented = true
//                } label: {
//                    Text("Low")
//                        .font(.title3)
//                        .foregroundColor(.green);
//                }.padding(.top, 10)
//                    /*.sheet(isPresented: $modalState.isModal2Presented) {
//                        Modal2(modalState: self.modalState)
//                    }*/
//
//                Button {
//                    self.modalState.isModal1Presented = false
//                    NotificationManager.instance.activeAlert = false
//                    //self.modalState.isModal2Presented = true
//                } label: {
//                    Text("Moderate")
//                        .font(.title3)
//                        .foregroundColor(.yellow);
//                }.padding(.top, 10)
//                    /*.sheet(isPresented: $modalState.isModal2Presented) {
//                        Modal2(modalState: self.modalState)
//                    }*/
//
//                Button {
//                    self.modalState.isModal1Presented = false
//                    NotificationManager.instance.activeAlert = false
//                    //self.modalState.isModal2Presented = true
//                } label: {
//                    Text("High")
//                        .font(.title3)
//                        .foregroundColor(.red);
//                }.padding(.top, 10)
//                    /*.sheet(isPresented: $modalState.isModal2Presented) {
//                        Modal2(modalState: self.modalState)
//                    }*/
//
//                Button {
//                    self.modalState.isModal1Presented = false
//                    NotificationManager.instance.activeAlert = false
//                    //self.modalState.isModal2Presented = true
//                } label: {
//                    Text("Very High")
//                        .font(.title3)
//                        .foregroundColor(.purple);
//                }.padding(.top, 10)
//                    /*.sheet(isPresented: $modalState.isModal2Presented) {
//                        Modal2(modalState: self.modalState)
//                    }*/
//
//           /* Button("Dismiss") {
//                self.modalState.isModal1Presented = false
//                NotificationManager.instance.activeAlert = false
//            }*/
//          }
//        }
//    }
//}
//// modal 2
///*struct Modal2: View {
//    @ObservedObject var modalState: ModalState
//    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
//    var body: some View {
//        VStack {
//            Text("Are you sure?").font(.title3).padding(.top, 10)
//
//            Button {
//                self.modalState.isModal1Presented = false
//                self.modalState.isModal2Presented = false
//                NotificationManager.instance.activeAlert = false
//            } label: {
//                Text("Go Back")
//                    .font(.subheadline)
//            }.foregroundColor(.white)
//            .padding()
//
//        }
//    }
//}*/
    

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationView()
            NotificationView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
    }
}

