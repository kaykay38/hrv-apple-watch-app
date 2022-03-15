//
//  LoadingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/8/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            DotView()
            DotView(delay: 0.2)
            DotView(delay: 0.4)
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
