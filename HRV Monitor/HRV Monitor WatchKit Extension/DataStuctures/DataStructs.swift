//
//  DataStructs.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia Hunt on 4/18/22.
//

import Foundation

struct Alert: Identifiable {
    let id = UUID()
    var direction: String
    var time: String
}

struct HRSample: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var timeDiffMilliSec: Double = 0 // Difference between this and previous sample time.
    var currentHRPerMilliSec: Double = 0
    var averageIBI: Double = 0 // Interbeat Interval (IBI/nn).
    var IBIdiff: Double = 0 // Difference between this and previous IBI.
    var accuracy: Double = 0
}
