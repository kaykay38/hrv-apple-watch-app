//
//  ControlsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI

struct ControlsView: View {
    var body: some View {
        VStack {
            Button {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }label: {
                VStack {
                    Text("Start Monitoring");
                    Image(systemName: "play");
                }
            }.foregroundColor(.green);
        }
        .padding()
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
            .previewDevice("Apple Watch Series 5 - 40mm")
        ControlsView()
            .previewDevice("Apple Watch Series 7 - 45mm")
    }
}
