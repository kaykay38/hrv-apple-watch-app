//
//  WorkoutManager.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/14/22.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    
    @Published var workout: HKWorkout?
    // The app's workout state.
    @Published var running = false
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    var hrvCalculator: HRVCalculator = HRVCalculator()
    
    private var currentHR: Double = 0
    
    @Published private(set) var HRV: Double = 0
    
    // private var previousHRV: Double = 0
    // private var diffHRV: Double = 0
    
    @Published var hrvChartArray: [Double] = []
    @Published var alertTableArray: [Alert] = []
    
    
    private var prevSampleTime: Date? = nil
    private var curSampleTime: Date? = nil
    private var timeDiffMilliSec: Double = 0.0
    
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
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
    
    struct Alert: Identifiable {
        let id = UUID()
        var direction: String
        var time: String
    }
    
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        // Run in background thread
        DispatchQueue.main.async {
            
            let hour = Calendar.current.component(.hour, from: Date())
            let minute = Calendar.current.component(.minute, from: Date())
            let second = Calendar.current.component(.second, from: Date())
            
            self.prevSampleTime = self.curSampleTime
            self.curSampleTime = Date()
            
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                
                self.currentHR = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
               
                self.hrvCalculator.addSample(self.curSampleTime ?? Date(), self.prevSampleTime ?? Date(), self.currentHR)
                
                self.HRV = self.hrvCalculator.updateHRV()
                
                if(self.hrvChartArray.count > 20) {
                    self.hrvChartArray.removeFirst()
                }
                self.hrvChartArray.append(self.HRV/250)

                if(self.hrvCalculator.isHigh()) {
                    self.alertTableArray.append(Alert(direction: "High", time: "\(hour):\(minute):\(second)"))
                } else if(self.hrvCalculator.isLow()) {
                    self.alertTableArray.append(Alert(direction: "Low", time: "\(hour):\(minute):\(second)"))
                }
                
            default:
                return
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
