//
//  StatisticsView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "bolt.heart")
                    .font(.largeTitle)
                VStack(alignment: .leading){
                    Text("HRV")
                    Text("Statistics")
                }
                .font(.title3)
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 9.0) {
                HStack {
                    Label("Maximum:", systemImage: "arrow.up.circle")
                    Text("128");
                }.font(.headline)
                HStack {
                    Label("Average:", systemImage: "minus.circle")
                    Text("100");
                }.font(.headline)
                HStack {
                    Label("Minimum:", systemImage: "arrow.down.circle")
                    Text("23");
                }.font(.headline)

            }
        }
        .padding()
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .previewDevice("Apple Watch Series 5 - 40mm")
        StatisticsView()
            .previewDevice("Apple Watch Series 7 - 45mm")
            
    }
}
