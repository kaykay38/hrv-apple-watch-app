//
//  ContentView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI


struct StartView: View {
    var body: some View {
        let HealthKitController = HealthKitController.init();
        
        Button(action: HealthKitController.fetchHealthData) {
                        Text("Fetch data")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                }
                .frame(width: 350, height: 150)
                .background(Color.black)
                .cornerRadius(40)
                .border(Color.black)
                .cornerRadius(40)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
    
}
