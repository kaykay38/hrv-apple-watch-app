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
    var timeDiffMilliSec: Double = 0 // Difference between this and previous sample time.
    var currentHR: Double = 0
    var currentHRPerMillSec: Double = 0
    var averageIBI: Double = 0 // Interbeat Interval (IBI/nn).
    var IBIdiff: Double = 0 // Difference between this and previous IBI.
    var accuracy: Double = 0
}

extension Collection where Iterator.Element == HRSample {
    // Standard deviation of IBI/NN samples in 24 hrs. Must have 24hr of data.
    var SDNN: Double {
        let length = Double(self.count)
        let avg = self.reduce(0, {$0 + $1.averageIBI}) / length
        let sumOfSquaredAvgDiff = self.map { pow($0.averageIBI - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    // Standard deviation of successive IBI/NN differences in 5 min.
    var SDSD: Double {
        let length = Double(self.count)
        let avg = self.reduce(0, {$0 + $1.IBIdiff}) / length
        let sumOfSquaredAvgDiffs = self.map { pow($0.IBIdiff - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiffs / length)
    }
    
    // Root mean square of successive IBI/NN differences in 5 mins.
    var RMSSD: Double {
        let length = Double(self.count)
        let avgOfSumOfSquaredDiffs = self.map {pow($0.IBIdiff, 2.0)}.reduce(0, {$0 + $1}) / length
        return sqrt(avgOfSumOfSquaredDiffs)
    }
}

class HRVCalculator: NSObject, ObservableObject {
    
    @Published var hrSampleTable: [HRSample] = []
    
    @Published var HRV: Double = 0
    
    @Published var maximumHRV: Double = 0
    @Published var minimumHRV: Double = 0
    @Published var averageHRV: Double = 0
    
    @Published var predictedHRV: Double = 0
    
    @Published var notificationThreshold: Double = 0
    
    @Published var isPast24Hrs: Bool = false
    private var averageIBITable: [Double] = []
    
    func addSample(_ curSampleTime: Date, _ prevSampleTime: Date,_ heartrate: Double) {
        if hrSampleTable.count > 20 {
            hrSampleTable.removeFirst();
        }
        
        let timeDiffMillisec = curSampleTime.timeIntervalSince(prevSampleTime)*1000
        let beats = (heartrate/6000) * timeDiffMillisec
        let averageIBI = timeDiffMillisec/beats
        
        self.hrSampleTable.append(
            HRSample(date: curSampleTime, timeDiffMilliSec: timeDiffMillisec, currentHR: heartrate, currentHRPerMillSec: heartrate/6000, averageIBI: averageIBI, IBIdiff: (hrSampleTable.last? .averageIBI ?? averageIBI) - averageIBI, accuracy: 0)
        )
    }
    
    func isLow() -> Bool {
        if HRV < 0.2 {
            return true
        }
        return false
    }
    
    func isHigh() -> Bool {
        if HRV > 10 {
            return true
        }
        return false
    }
    
    func updateHRV() -> Double {
        HRV = hrSampleTable.RMSSD
        return HRV
    }
    
    func reset() {
        self.hrSampleTable.removeAll()
    }
    
}
