//
//  TestView.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 5/8/22.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var Tester_HRVCalculator: Tester_HRVCalculator
    
    var body: some View {
        VStack {
            Button {
                Tester_HRVCalculator.runHRVCalculatorTests()
            } label: {
                Text("HRV Calc Tests")
            }
//            if(Tester_HRVCalculator.passed) {
//                Text("PASSED")
//            }
//            else {
//                Text("FAILED")
//            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
    TestView()
    }
}

