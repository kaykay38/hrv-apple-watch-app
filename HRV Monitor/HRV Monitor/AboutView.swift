//
//  AboutView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/18/22.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Made in Partnership with the EWU School of Computer Science and St. Lukes Rehabilitation Center of Spokane")
            Spacer()
        }.padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutView()
            AboutView()
                .preferredColorScheme(.dark)
        }
    }
}
