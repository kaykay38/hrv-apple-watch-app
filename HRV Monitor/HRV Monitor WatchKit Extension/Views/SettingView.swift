//
//  SettingView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 4/26/22.
//

import SwiftUI

struct SettingView: View {
    @State private var firstToggle = false
    @State private var secondToggle = false
    @State private var isToggle : Bool = false

       var body: some View {
          /* VStack {
                    Toggle(isOn: $isToggle){
                           Text("Survey Notifications ")
                               .font(.title)
                               .foregroundColor(Color.white)
                          
                       }
                   }.padding()
                       .background(isToggle ? Color.orange : Color.purple)
               }*/
           
           let firstBinding = Binding(
               get: { self.firstToggle },
               set: {
                   self.firstToggle = $0

                   if $0 == true {
                       self.secondToggle = false
                   }
               }
           )

           return VStack {
               Toggle(isOn: firstBinding) {
                   Text("Survey Notifications")
               }.padding()

            }
       }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
