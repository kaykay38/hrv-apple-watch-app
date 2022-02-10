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
                .font(.title2)
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 9.0) {
                HStack {
                    Label("Maximum:", systemImage: "arrow.up.circle")
                    Text("128");
                }.font(.title3)
                HStack {
                    Label("Average:", systemImage: "minus.circle")
                    Text("100");
                }.font(.title3)
                HStack {
                    Label("Minimum:", systemImage: "arrow.down.circle")
                    Text("23");
                }.font(.title3)

            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
