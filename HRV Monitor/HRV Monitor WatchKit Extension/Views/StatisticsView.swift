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
                Image(systemName: "bolt.heart").font(.title2).padding(2)
                VStack(alignment: .leading){
                    Text("Stats")
                }
                .font(.title)
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 9.0) {
                HStack {
                    Label("Max:", systemImage: "arrow.up.circle")
                    Text("128");
                }.font(.title3)
                HStack {
                    Label("Avg:", systemImage: "minus.circle")
                    Text("100");
                }.font(.title3)
                HStack {
                    Label("Min:", systemImage: "arrow.down.circle")
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
