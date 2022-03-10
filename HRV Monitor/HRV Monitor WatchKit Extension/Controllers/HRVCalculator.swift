//
//  HRVCalulatorController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 3/8/22.
//

import Foundation
import SwiftUI

struct HRSample: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var timeMillSecDiff: Double = 0
    var currentHR: Double = 0
    var currentHRPerMillSec: Double = 0
    var averageIBI: Double = 0
    var accuracy: Double = 0
}

extension Collection where Iterator.Element == HRSample {
    var SDNN: Double {
        let length = Double(self.count)
        let avg = self.reduce(0, {$0 + $1.averageIBI}) / length
        let sumOfSquaredAvgDiff = self.map { pow($0.averageIBI - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
}

class HRVCalculator: NSObject, ObservableObject {
    
    @Published var hrSampleTable: [HRSample] = []
    
    private var currentHRV: Double = 0
    
    @Published var maximumHRV: Double = 0
    @Published var minimumHRV: Double = 0
    @Published var averageHRV: Double = 0
    
    @Published var predictedHRV: Double = 0
    
    @Published var notificationThreshold: Double = 0
    
    @Published var isPast24Hrs: Bool = false
    private var averageIBITable: [Double] = []
    
    func HRV() -> Double {
        currentHRV = hrSampleTable.SDNN
        return currentHRV
    }
    
    func addSample(_ curSampleTime: Date, _ prevSampleTime: Date,_ heartrate: Double) {
        if hrSampleTable.count > 20 {
            hrSampleTable.removeFirst();
        }
        
        let timeDiffMillisec = curSampleTime.timeIntervalSince(prevSampleTime)*1000
        let beats = (heartrate/6000) * timeDiffMillisec
        let averageIBI = timeDiffMillisec/beats
        
        self.hrSampleTable.append(
            HRSample(date: curSampleTime, timeMillSecDiff: timeDiffMillisec, currentHR: heartrate, currentHRPerMillSec: heartrate/6000, averageIBI: averageIBI, accuracy: 0)
        )
    }
    
    func isLow() -> Bool {
        if currentHRV < 0.2 {
            return true
        }
        return false
    }
    
    func isHigh() -> Bool {
        if currentHRV > 10 {
            return true
        }
        return false
    }
    
    func reset() {
        self.hrSampleTable.removeAll()
    }
    
}
