//
//  ConfirmationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/11/22.
//

import SwiftUI

struct ConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                    Text("Are you sure?").font(.title3).padding(.top, 10)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Go Back")
                            .font(.subheadline)
                    }.foregroundColor(.white)
                    .padding()
                    
                /*NavigationLink(destination: PagingView()){
                    Text("Confirm")
                        .font(.title3)
                        .foregroundColor(.green);
                }*/
                
            }
        }
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView()
    }
}
