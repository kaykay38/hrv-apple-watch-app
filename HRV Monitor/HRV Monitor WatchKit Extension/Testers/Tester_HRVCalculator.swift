//
//  Tester_HRVCalculator.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 5/8/22.
//

import Foundation
class Tester_HRVCalculator: NSObject, ObservableObject {
    var hrvCalculator: HRVCalculator = HRVCalculator()
    
    @Published var passed = false;
    
    private var prevSampleTime: Date? = nil
    private var curSampleTime: Date? = nil
    
    func runHRVCalculatorTests() {
        let testGoodHR: [Double] = [62, 64, 80, 60, 98, 93, 104, 86, 116, 115, 96, 87, 89, 69, 95, 67, 111, 96, 113, 109, 68, 114, 100, 92, 70, 84, 101, 86, 82, 89, 111, 114, 82, 87]
        
        let expectedHRV: [Double] = [0]
        
        self.prevSampleTime = self.curSampleTime
        self.curSampleTime = Date()
        
        var currentHR = testGoodHR[1];
        self.hrvCalculator.addSample(self.curSampleTime ?? Date(), self.prevSampleTime ?? Date(), currentHR)
        
        if(hrvCalculator.updateHRV() == expectedHRV[0]) {
            passed = true
        }
        else
        {
            passed = false
        }
        
    }
}
