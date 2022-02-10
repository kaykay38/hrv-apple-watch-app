//
//  ChartView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/10/22.
//

import SwiftUI

struct ChartView: View {
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Live HRV")
                .font(.title);
            HStack {
                Text("Good")
                    .font(.title3)
                    .foregroundColor(.green);
                Text("158")
                    .font(.title3);
            }
            Text("Graph Placeholder");
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
