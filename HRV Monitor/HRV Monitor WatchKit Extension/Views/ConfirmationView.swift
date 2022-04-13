//
//  ConfirmationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/11/22.
//

import SwiftUI

struct ConfirmationView: View {
    var body: some View {
        NavigationView{
            VStack {
                    Text("Are you sure?").font(.title3).padding(.top, 10)
                    
                    /*Button {
                        // workoutManager.endWorkout() // method for survey
                    } label: {
                        Text("Go Back")
                            .font(.subheadline)
                    }.foregroundColor(.yellow)
                    .padding()*/
                    
                NavigationLink(destination: PagingView()){
                    Text("Confirm")
                        .font(.title3)
                        .foregroundColor(.white);
                }
                
            }
        }
    }
}


struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView()
    }
}
