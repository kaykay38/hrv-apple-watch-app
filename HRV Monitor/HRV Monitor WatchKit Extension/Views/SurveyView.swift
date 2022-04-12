//
//  SurveyView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/11/22.
//

// It is possible we may want the survey on a different folder
import SwiftUI

struct SurveyView: View {
    var body: some View {
        VStack {
            ScrollView{
                Text("What's your stress level?").font(.title3).padding(.top, 10)
                
                Button {
                    // workoutManager.endWorkout() // method for survey
                } label: {
                    Text("Very High")
                        .font(.subheadline)
                }.foregroundColor(.purple)
                .padding()
                
                Button {
                    // workoutManager.endWorkout() // method for survey
                } label: {
                    Text("High")
                        .font(.subheadline)
                }.foregroundColor(.red)
                .padding()
            
                Button {
                    // workoutManager.endWorkout() // method for survey
                } label: {
                    Text("Moderate")
                        .font(.subheadline)
                }.foregroundColor(.orange)
                .padding()
                
            Button {
                // workoutManager.endWorkout() // method for survey
            } label: {
                Text("Low")
                    .font(.subheadline)
            }.foregroundColor(.green)
            .padding()
                
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
