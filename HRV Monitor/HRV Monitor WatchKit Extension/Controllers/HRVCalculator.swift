//
//  HRVCalulatorController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia on 3/8/22.
//

import Foundation
import SwiftUI


extension Collection where Iterator.Element == HRSample {
    // Standard deviation of IBI/NN samples in 24 hrs. Must have 24hr of data.
    var SDNN: Double {
        let length = Double(self.count)
        let avg = self.reduce(0, {$0 + $1.averageIBI}) / length
        let sumOfSquaredAvgDiff = self.map { pow($0.averageIBI - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    // Standard deviation of successive IBI/NN differences.
    var SDSD: Double {
        let length = Double(self.count)
        let avg = self.reduce(0, {$0 + $1.IBIdiff}) / length
        let sumOfSquaredAvgDiffs = self.map { pow($0.IBIdiff - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiffs / length)
    }
    
    // Root mean square of successive IBI/NN differences.
    var RMSSD: Double {
        let length = Double(self.count)
        let avgOfSumOfSquaredDiffs = self.map {pow($0.IBIdiff, 2.0)}.reduce(0, {$0 + $1}) / length
        return sqrt(avgOfSumOfSquaredDiffs)
    }
}

class HRVCalculator: NSObject, ObservableObject {
    
    private var HRSampleTable: [HRSample] = []
    
    private var PrevHRV: Double = 0
    private var HRVTable: [Double] = [Double]()
    private var HRTable: [Double] = [Double]()
    private var currentHR: Double = 0
    private var hasFilledTable: Bool = false
    
    @Published private(set) var HRV: Double = 0
    @Published private(set) var maximumHRV: Double = 0
    @Published private(set) var minimumHRV: Double = 0
    @Published private(set) var averageHRV: Double = 0

    private var predictedHRV: Double = 0
    
    let hrModel = HeartRatePredictions()

    private(set) var notificationThreshold: Double = 0

    
    // heartrate comes in as beats per second
    func addSample(_ curSampleTime: Date, _ prevSampleTime: Date, _ heartrate: Double) {
        // Unwrap optional HRSamples in table, first and last.
        if let oldestSample = self.HRSampleTable.first {
            
            // Check if samples spans more than a specified time, if so remove first entry. 30 seconds
            if curSampleTime.timeIntervalSince(oldestSample.date) > 30 {
                HRSampleTable.removeFirst();
            }
        }
        
        self.currentHR = heartrate;
        
        let timeDiffMilliSec = curSampleTime.timeIntervalSince(prevSampleTime) * 1000
        let HRPerMilliSec = heartrate/6000
        let beats = HRPerMilliSec * timeDiffMilliSec
        let averageIBI = timeDiffMilliSec/beats
        
        self.HRSampleTable.append(
            HRSample(date: curSampleTime, timeDiffMilliSec: timeDiffMilliSec, currentHRPerMilliSec: HRPerMilliSec, averageIBI: averageIBI, IBIdiff: self.HRSampleTable.last?.averageIBI ?? averageIBI - averageIBI, accuracy: 0)
        )
    }
    
    // Recalculate and update HRV
    func updateHRV() -> Double {
        // Remove 0 in first index which is default initial value
        if HRVTable.first == 0.0 {
            HRVTable.removeFirst()
        }
        
        HRTable.append(self.currentHR)
        
        self.PrevHRV = self.HRV

        // Calculate new HRV
        self.HRV = HRSampleTable.RMSSD

        HRVTable.append(self.HRV)
        
        // Maintain the size of HRVTable to be in sync with HRSampleTable
        if (HRVTable.count > HRSampleTable.count) {
            HRVTable.removeFirst()
            hasFilledTable = true
        }
        
        // Update maximumHRV and minimumHRV
        let newMax = self.HRVTable.max() ?? 0
        let newMin = self.HRVTable.min() ?? 0
        if self.maximumHRV < newMax {
            self.maximumHRV = newMax
        }
        if self.minimumHRV == 0 || self.minimumHRV > newMin {
            self.minimumHRV = newMin
        }
        
        if (hasFilledTable) {
            self.averageHRV = (self.averageHRV + self.HRVTable.reduce(0, +))/Double(HRVTable.count + 1)
        }
        else {
            self.averageHRV = self.HRVTable.reduce(0, +)/Double(HRVTable.count)
        }
        return self.HRV
    }
    
    func hrvTrendPrecentage() -> Double {
        return (self.PrevHRV - self.HRV)/100
    }
    
    func predictHRV(curSampleTime: Date, prevSampleTime: Date) -> Double {
        guard let hrPredictionOutput = try? hrModel.prediction(T1: HRTable[0], T2: HRTable[1], T3: HRTable[2], T4: HRTable[3], HRV: self.HRV) else {
            fatalError("Unexpected runtime error.")
        }
        self.addSample(curSampleTime, prevSampleTime, hrPredictionOutput.T5)
        return updateHRV();
    }
    
    func reset() {
        self.HRV = 0
        self.maximumHRV = 0
        self.minimumHRV = 0
        self.averageHRV = 0
        self.predictedHRV = 0
        self.HRVTable.removeAll()
        self.HRTable.removeAll()
        self.HRSampleTable.removeAll()
    }
    
}
