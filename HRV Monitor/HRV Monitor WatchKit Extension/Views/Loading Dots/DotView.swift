//
//  DotView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/8/22.
//

import SwiftUI

struct DotView: View {
    @State var delay: Double = 0 // 1.
    @State var scale: CGFloat = 0.5
    var body: some View {
        Circle()
            .frame(width: 10, height: 10)
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay)) // 2.
            .onAppear {
                withAnimation {
                    self.scale = 1
                }
            }
    }
}

struct DotView_Previews: PreviewProvider {
    static var previews: some View {
        DotView()
    }
}
