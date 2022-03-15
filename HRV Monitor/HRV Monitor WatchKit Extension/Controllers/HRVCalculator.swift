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
    var currentHRPerMilliSec: Double = 0
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
    
    private var HRSampleTable: [HRSample] = []
    
    private(set) var HRV: Double = 0
    private var HRVTable: [Double] = []

    @Published private(set) var maximumHRV: Double = 0
    @Published private(set) var minimumHRV: Double = 0
    @Published private(set) var averageHRV: Double = 0

    private var predictedHRV: Double = 0

    private(set) var notificationThreshold: Double = 0

    private var isPast24Hrs: Bool = false
    
    // heartrate comes in beats per second
    func addSample(_ curSampleTime: Date, _ prevSampleTime: Date,_ heartrate: Double) {
        // Unwrap optional HRSamples in table, first and last.
        if let lastSample = self.HRSampleTable.last {
            
            // Check if samples spans more than 5 minutes, if so remove first entry.
            if curSampleTime.timeIntervalSince(lastSample.date) > 300 {
                HRSampleTable.removeFirst();
            }
            
        }
        
        let timeDiffMilliSec = curSampleTime.timeIntervalSince(prevSampleTime) * 1000
        let HRPerMilliSec = heartrate/6000
        let beats = HRPerMilliSec * timeDiffMilliSec
        let averageIBI = timeDiffMilliSec/beats
        
        self.HRSampleTable.append(
            HRSample(date: curSampleTime, timeDiffMilliSec: timeDiffMilliSec, currentHRPerMilliSec: HRPerMilliSec, averageIBI: averageIBI, IBIdiff: self.HRSampleTable.last?.averageIBI ?? averageIBI - averageIBI, accuracy: 0)
        )
    }
    
    func isLow() -> Bool {
        if self.HRVTable.count > 1 && self.HRV < 50 {
            return true
        }
        return false
    }
    
    func isHigh() -> Bool {
        if self.HRVTable.count > 1 && self.HRV > 90 {
            return true
        }
        return false
    }
    
    // Recalculate and update HRV
    func updateHRV() -> Double {
        // Remove 0 in first index calculated from when there is only one sample in HRSampleTable
        if HRVTable.first == 0.0 {
            HRVTable.removeFirst()
        }

        // Calculate new HRV
        self.HRV = HRSampleTable.RMSSD

        HRVTable.append(self.HRV)
        
        // Maintain the cor
        if (HRVTable.count > HRSampleTable.count) {
            HRVTable.removeFirst()
        }

        self.maximumHRV = self.HRVTable.max() ?? 0
        self.minimumHRV = self.HRVTable.min() ?? 0
        self.averageHRV = self.HRVTable.reduce(0, {$0 + $1})/Double(HRVTable.count)

        return self.HRV
    }
    
    func reset() {
        self.HRV = 0
        self.maximumHRV = 0
        self.minimumHRV = 0
        self.averageHRV = 0
        self.predictedHRV = 0
        self.HRVTable.removeAll()
        self.HRSampleTable.removeAll()
    }
    
}
