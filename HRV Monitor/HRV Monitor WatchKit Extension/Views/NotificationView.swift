//
//  NotificationView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var hapticController: HapticController = HapticController.instance
    @Environment(\.presentationMode) var presentationMode
    @State var isActive : Bool = false

    var body: some View {
        NavigationView {
            NavigationLink(
                destination: ContentView2(rootIsActive: self.$isActive),
                isActive: self.$isActive
            ) {
                Text("False Alarm")
                .font(.title3)
                .foregroundColor(.green);
        }.navigationBarHidden(true)
        
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
        }.onAppear(perform: hapticController.triggerHaptic)
    }
}

struct ContentView2: View {
    @Binding var rootIsActive : Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Go Back") {
            presentationMode.wrappedValue.dismiss()
        }
        
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("Low")
                .font(.title3)
                .foregroundColor(.green);
        }.padding(.top, 10)
        .navigationBarHidden(true)
        
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("Moderate")
                .font(.title3)
                .foregroundColor(.orange);
        }.padding(.top, 10)
        .navigationBarHidden(true)
        
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("High")
                .font(.title3)
                .foregroundColor(.red);
        }.padding(.top, 10)
        .navigationBarHidden(true)
        
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("Very High")
                .font(.title3)
                .foregroundColor(.purple);
        }.padding(.top, 10)
        .navigationBarHidden(true)
    }
}

struct ContentView3: View {
    @Binding var shouldPopToRootView : Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Are you sure?").padding(.bottom, 10)
            Button (action: { self.shouldPopToRootView = false } ){
                Text("Confirm")
                    .font(.subheadline)
            }.foregroundColor(.green)
            .padding()
            .navigationBarHidden(true)
            
            Button("Go Back") {
                presentationMode.wrappedValue.dismiss()
            }
    }
}


/*import SwiftUI
import WatchKit

struct NotificationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var hapticController: HapticController = HapticController.instance
    @Environment(\.presentationMode) var presentationMode
    @State private var isToggle : Bool = false
    
    /*(workoutManager.navigate == true){
        presentationMode.wrappedValue.dismiss()
    }*/
    
    // each if button equals true, go on that route
    var body: some View {
            NavigationView{
                // if false alarm, go to graph
                // if dismiss, go to survey
                /*Button("request permission"){
                    NotificationManager.instance.requestAuthorization()
                }*/
                
                Button("schedule notification"){
                 NotificationManager.instance.scheduleHighNotification()
                }
                
                VStack {
                    HStack{
                        Image(systemName: "exclamationmark.square").font(.title).padding(.bottom, 3).foregroundColor(.yellow).padding(.bottom, 5);
                     
                        Text("Episode Detected").font(.title3).padding(.bottom, 10)
                    }
                    NavigationLink(destination: SurveyView()){
                        Text("False Alarm")
                            .font(.title3)
                            .foregroundColor(.green);
                    }.navigationBarHidden(true)
                
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                .onAppear(perform: hapticController.triggerHaptic)
            }
        }
 
 }*/

    

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
