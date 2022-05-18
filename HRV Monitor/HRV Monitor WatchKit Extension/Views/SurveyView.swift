//
//  SurveyView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 5/2/22.
//

import SwiftUI

/// !!!!!!!!!!!!!!!!
// try to connect notification view modals with this modal and a possible Confirmation View

struct SurveyView: View {
    @ObservedObject var notificationManager:NotificationManager = NotificationManager.instance
    var body: some View {
            VStack {
                ScrollView{
                    Text("What's your stress level?").font(.title3)
                    
                    Button {
                        //self.modalState.isModal2Presented = true
                        NotificationManager.instance.thankYou = true
                    } label: {
                        Text("Low")
                            .font(.title3)
                            .foregroundColor(.green);
                    }.padding(.top, 2)
                        /*.sheet(isPresented: $modalState.isModal2Presented) {
                            Modal2(modalState: self.modalState)
                        }*/
                    
                    Button {
                    ///
                        //self.modalState.isModal2Presented = true

                        NotificationManager.instance.thankYou = true
                    } label: {
                        Text("Moderate")
                            .font(.title3)
                            .foregroundColor(.yellow);
                    }.padding(.top, 2)
                        /*.sheet(isPresented: $modalState.isModal2Presented) {
                            Modal2(modalState: self.modalState)
                        }*/
                    
                    Button {
                        //self.modalState.isModal2Presented = true
   
                        NotificationManager.instance.thankYou = true
                    } label: {
                        Text("High")
                            .font(.title3)
                            .foregroundColor(.red);
                    }.padding(.top, 2)
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

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SurveyView()
            SurveyView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
    }
}
}
