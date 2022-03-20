//
//  HealthKitController.swift
//  HRV Monitor
//
//  Created by Justin Plett on 3/18/22.
//

import Foundation
import HealthKit

class HealthKitController: ObservableObject{
    
    static let instance = HealthKitController()
    
    @Published var avgHRV: Double = 0.0
    @Published var maxHRV: Double = 0.0
    @Published var minHRV: Double = 0.0
    
    @Published var last7Days: [Double] = [0.0]
    @Published var last30Days: [Double] = [0.0]
    @Published var today: [Double] = [0.0]

    let healthStore: HKHealthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "ms")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRateVariabilitySDNN)!
    var heartRateQuery:HKSampleQuery?

    
    func loadHKData(){
        
        let readData = Set([
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ])
        
        healthStore.requestAuthorization(toShare: [], read: readData) {(success, error) in
            if success {
                print("Request Granted")
                self.getToday()
                self.getLast7Days()
                self.getLast30Days()
            }else{
                print("Authorization Failed")
            }
        }
    }
    
    func getToday() {
        let calendar = Calendar.current

        // Create a 1-week interval.
        let interval = DateComponents(hour: 1)

        
        let date = Date()

        // Set the anchor for 3 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: calendar.component(.hour, from: date),
                                        minute: calendar.component(.minute, from: date),
                                        second: calendar.component(.second, from: date),
                                        weekday: calendar.component(.weekday, from: date))

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }

        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: nil,
                                                options: .discreteAverage,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler.
        query.initialResultsHandler = { [self]
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let threeMonthsAgo = DateComponents(hour: -48)
            
            guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            //today.removeAll()
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { [self] (statistics, stop) in
                if let quantity = statistics.averageQuantity() {
                    let value = quantity.doubleValue(for: self.heartRateUnit)
                    
                    // Extract each week's data.
                    today.append(value)
                    print(value)
                }
            }
//            // Dispatch to the main queue to update the UI.
//            DispatchQueue.main.async {
//                myUpdateGraph(weeklyData: weeklyData)
//            }
        }
        healthStore.execute(query)
    }
    
    func getLast7Days() {
        let calendar = Calendar.current

        // Create a 1-week interval.
        let interval = DateComponents(day: 1)

        // Set the anchor for 3 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }

        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: nil,
                                                options: .discreteAverage,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler.
        query.initialResultsHandler = { [self]
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let threeMonthsAgo = DateComponents(day: -7)
            
            guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            //last7Days.removeAll()
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { [self] (statistics, stop) in
                if let quantity = statistics.averageQuantity() {
                    let value = quantity.doubleValue(for: self.heartRateUnit)
                    
                    // Extract each week's data.
                    last7Days.append(value)
                }
            }
//            // Dispatch to the main queue to update the UI.
//            DispatchQueue.main.async {
//                myUpdateGraph(weeklyData: weeklyData)
//            }
        }
        healthStore.execute(query)
    }
    
    func getLast30Days() {
        let calendar = Calendar.current

        // Create a 1-week interval.
        let interval = DateComponents(day: 7)

        // Set the anchor for 3 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }

        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: nil,
                                                options: .discreteAverage,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler.
        query.initialResultsHandler = { [self]
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let threeMonthsAgo = DateComponents(month: -1)
            
            guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            //last30Days.removeAll()
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { [self] (statistics, stop) in
                if let quantity = statistics.averageQuantity() {
                    let value = quantity.doubleValue(for: self.heartRateUnit)
                    
                    // Extract each week's data.
                    
                    last30Days.append(value)
                    
                }
            }
//            // Dispatch to the main queue to update the UI.
//            DispatchQueue.main.async {
//                myUpdateGraph(weeklyData: weeklyData)
//            }
        }
        healthStore.execute(query)
    }
    
    func getAVG() {
        let calendar = Calendar.current

        // Create a 1-week interval.
        let interval = DateComponents(month: 1)

        // Set the anchor for 3 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }

        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: nil,
                                                options: .discreteAverage,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler.
        query.initialResultsHandler = { [self]
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let threeMonthsAgo = DateComponents(month: -1)
            
            guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { [self] (statistics, stop) in
                if let quantity = statistics.averageQuantity() {
                    let value = quantity.doubleValue(for: self.heartRateUnit)
                    
                    // Extract each week's data.
                    avgHRV = value
                }
            }
//            // Dispatch to the main queue to update the UI.
//            DispatchQueue.main.async {
//                myUpdateGraph(weeklyData: weeklyData)
//            }
        }
        healthStore.execute(query)
    }
    
    func getMin() {
        let calendar = Calendar.current

        // Create a 1-week interval.
        let interval = DateComponents(month: 1)

        // Set the anchor for 3 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }

        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: nil,
                                                options: .discreteMin,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler.
        query.initialResultsHandler = { [self]
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let threeMonthsAgo = DateComponents(month: -1)
            
            guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { [self] (statistics, stop) in
                if let quantity = statistics.minimumQuantity() {
                    let value = quantity.doubleValue(for: self.heartRateUnit)
                    
                    // Extract each week's data.
                    minHRV = value
                }
            }
//            // Dispatch to the main queue to update the UI.
//            DispatchQueue.main.async {
//                myUpdateGraph(weeklyData: weeklyData)
//            }
        }
        healthStore.execute(query)
    }
    
    func getMax() {
        let calendar = Calendar.current

        // Create a 1-week interval.
        let interval = DateComponents(month: 1)

        // Set the anchor for 3 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }

        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: nil,
                                                options: .discreteMax,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler.
        query.initialResultsHandler = { [self]
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let threeMonthsAgo = DateComponents(month: -1)
            
            guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { [self] (statistics, stop) in
                if let quantity = statistics.maximumQuantity() {
                    let value = quantity.doubleValue(for: self.heartRateUnit)
                    
                    // Extract each week's data.
                    maxHRV = value
                }
            }
//            // Dispatch to the main queue to update the UI.
//            DispatchQueue.main.async {
//                myUpdateGraph(weeklyData: weeklyData)
//            }
        }
        healthStore.execute(query)
    }
    
}

