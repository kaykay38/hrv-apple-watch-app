//
//  ConfirmationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/11/22.
//

import SwiftUI

struct ConfirmationView: View {
    var body: some View {
        VStack {
                Text("Are you sure?").font(.title3).padding(.top, 10)
                
                Button {
                    // workoutManager.endWorkout() // method for survey
                } label: {
                    Text("Go Back")
                        .font(.subheadline)
                }.foregroundColor(.yellow)
                .padding()
                
                Button {
                    // workoutManager.endWorkout() // method for survey
                } label: {
                    Text("Confirm")
                        .font(.subheadline)
                }.foregroundColor(.white)
                .padding()
            
        }
    }
}


struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView()
    }
}
