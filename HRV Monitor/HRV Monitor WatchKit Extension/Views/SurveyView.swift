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
        NavigationView{
            VStack {
                ScrollView{
                    Text("What's your stress level?").font(.title3).padding(.top, 5)
                    
                    NavigationLink(destination: ConfirmationView()){
                        Text("Low")
                            .font(.title3)
                            .foregroundColor(.green);
                    }.padding(.top, 10)
                
                    NavigationLink(destination: ConfirmationView()){
                        Text("Moderate")
                            .font(.title3)
                            .foregroundColor(.orange);
                    }.padding(.top, 10)
                    
                    NavigationLink(destination: ConfirmationView()){
                        Text("High")
                            .font(.title3)
                            .foregroundColor(.red);
                    }.padding(.top, 10)
                    
                    NavigationLink(destination: ConfirmationView()){
                        Text("Very High")
                            .font(.title3)
                            .foregroundColor(.purple);
                    }.padding(.top, 10)
                    
                }
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
