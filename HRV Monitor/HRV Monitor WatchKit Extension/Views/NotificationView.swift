//
//  NotificationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
    VStack {
        Text("Notification").font(.title2).padding(.bottom, 10)
               Button {
                    workoutManager.resume()
                } label: {
                    Image(systemName: "return.right").font(.title).padding(.top, 3).padding(.bottom, 3);
                }.foregroundColor(.white)
            }
            .padding()
          }
    }

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
