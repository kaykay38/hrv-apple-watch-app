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
        HStack{
            Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
         
                Text("Episode Detected").font(.title3).padding(.bottom, 10)
        }
               Button {
                    workoutManager.resume()
                } label: {Text("Dismiss")
                    .font(.subheadline).padding(.top, 3).padding(.bottom, 3);
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
