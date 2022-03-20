//
//  BannerView.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/18/22.
//

import SwiftUI

struct BannerView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .frame(height: 100)
                .foregroundColor(Color(red: 0.7176470588235294, green: 0.0784313725490196, blue: 0.1803921568627451))
            
            Label("HRV Monitor", systemImage: "heart.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
                .padding()
        }
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
