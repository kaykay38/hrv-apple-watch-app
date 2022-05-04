//
//  WorkoutManager.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/14/22.
//

import Foundation
import HealthKit
import SwiftUI

class WorkoutManager: NSObject, ObservableObject {
    
    @Published var workout: HKWorkout?
    // The app's workout state.
    @Published var running = false
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    var hrvCalculator: HRVCalculator = HRVCalculator()
    var hrvClassificationController: HRVClassificationController = HRVClassificationController()
    
    private var currentHR: Double = 0
    
    @Published private(set) var HRV: Double = 0
    
    // private var previousHRV: Double = 0
    // private var diffHRV: Double = 0
    
    private var dob: Int? = nil
    private var sex: String? = nil
    
    @Published var hrvChartArray: [Double] = []
    
    
    private var prevSampleTime: Date? = nil
    private var curSampleTime: Date? = nil
    private var timeDiffMilliSec: Double = 0.0
    
    private var count: Int = 0
    
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
    
    // Start the workout.
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = HKWorkoutActivityType.walking
        configuration.locationType = .indoor
        
        
        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }
        
        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self
        
        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }
    
    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func endWorkout() {
        session?.end()

        hrvCalculator.reset()
        self.HRV = 0
        self.prevSampleTime = nil
        self.curSampleTime = nil
        self.hrvChartArray = []
        self.timeDiffMilliSec = 0
        self.currentHR = 0
    }
    

    var testI: Int = 0
    let testBadHR: [Double] = [181, 185, 154, 181, 156, 191, 183, 155, 194, 170, 200, 192, 186, 160, 154, 189, 163, 182, 188, 152, 163, 181, 192, 187, 181]
    
    let testModerateHR: [Double] = [141, 117, 124, 135, 115, 142, 125, 129, 134, 115, 146, 114, 148, 130, 118, 148, 109, 147, 139, 116, 140, 127, 117, 130, 135]
    
    let testGoodHR: [Double] = [62, 64, 80, 60, 98, 93, 104, 86, 116, 115, 96, 87, 89, 69, 95, 67, 111, 96, 113, 109, 68, 114, 100, 92, 70, 84, 101, 86, 82, 89, 111, 114, 82, 87]
    
    let testfullHR: [Double] = [62, 64, 80, 60, 98, 93, 104, 86, 116, 115, 96, 87, 89, 69, 95, 67, 111, 96, 113, 109, 68, 114, 100, 92, 70, 84, 101, 86, 82, 89, 111, 114, 82, 87, 141, 117, 124, 135, 115, 142, 125, 129, 134, 115, 146, 114, 148, 130, 118, 148, 109, 147, 139, 116, 140, 127, 117, 130, 135, 181, 185, 154, 181, 156, 191, 183, 155, 194, 170, 200, 192, 186, 160, 154, 189, 163, 182, 188, 152, 163, 181, 192, 187, 181, 141, 117, 124, 135, 115, 142, 125, 129, 134, 115, 146, 114, 148, 130, 118, 148, 109, 147, 139, 116, 140, 127, 117, 116, 115, 96, 87, 89, 69, 95, 67, 111, 96, 113, 109, 68, 114, 100, 92, 70, 84, 101, 86, 82, 89, 111, 114, 82, 87]
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        // Run in background thread
        DispatchQueue.main.async { [self] in
            
            self.prevSampleTime = self.curSampleTime
            self.curSampleTime = Date()
            
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                
//                self.currentHR = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0 //sensor value for first value
                
                //UI testing purpoes only
                self.currentHR = testfullHR[testI];
                if(testI < testfullHR.count) {
                    testI += 1
                }
                else {
                    testI = 0
                }
                

                self.hrvCalculator.addSample(self.curSampleTime ?? Date(), self.prevSampleTime ?? Date(), self.currentHR)
                self.HRV = self.hrvCalculator.updateHRV()
                
                

                if(count > 6) {
                    self.hrvChartArray.append((self.HRV)/300)
                }else{
                    count += 1
                }
                
                if(self.hrvChartArray.count > 6) {
                    hrvClassificationController.classifyHRV(HR: self.currentHR, HRV: self.HRV);
                    
                    self.saveHRVData(date: self.curSampleTime!, hrv: self.HRV)
                    
                    hrvClassificationController.updateHRVClassification(HR: self.currentHR, HRV: self.HRV, label: "high")
                    
//                    for _ in 1...1 {
//                        self.prevSampleTime = self.curSampleTime
//                        self.curSampleTime = Date()
//                        
//                        self.HRV = self.hrvCalculator.predictHRV(curSampleTime: self.curSampleTime ?? Date(), prevSampleTime: self.prevSampleTime ?? Date())
//                        self.hrvChartArray.append((self.HRV)/300)
//                    }
//                    
                    if(self.hrvChartArray.count > 60) {
                        self.hrvChartArray.removeFirst()
//                        self.hrvChartArray.removeFirst()
//                        self.hrvChartArray.removeFirst()
                    }
                    
                }
                
                print("\n\n")
            default:
                return
            }
        }
    }
    
    func saveHRVData(date: Date, hrv: Double) {
        let quantityType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        
        let hrv = HKQuantitySample.init(type: quantityType!,
                                        quantity: HKQuantity.init(unit: HKUnit.secondUnit(with: .milli), doubleValue: hrv),
                                        start: date,
                                        end: date)
        
        healthStore.save(hrv) { success, error in
                if (error != nil) {
//                    print("Error: \(String(describing: error))")
                }
                if success {
//                    print("📗 Saved: \(success) 📗")
//                    print("Value Stored: \(hrv)")
                }
        }
    }
}


extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        NotificationManager.instance.anotherWorkoutStarted()
    }
}


extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
