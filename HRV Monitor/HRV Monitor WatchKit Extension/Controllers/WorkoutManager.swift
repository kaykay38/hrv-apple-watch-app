//
//  WorkoutManager.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 2/14/22.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {

    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?

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
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }

    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }

    // The app's workout state.
    @Published var running = false

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
        resetWorkout()
        session?.end()
        
    }
    
    let hour = Calendar.current.component(.hour, from: Date())
    let minute = Calendar.current.component(.minute, from: Date())
    
    struct Alert: Identifiable {
         let id = UUID()
         var direction: String
         var time: String
     }

    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var maximumHeartRate: Double = 0
    @Published var minimumHeartRate: Double = 0
    @Published var arrayCurHR: [Double] = []
    @Published var arraydiffHR: [Double] = []
    @Published var DiffHR: Double = 0
    @Published var lastHR: Double = 0
    @Published var workout: HKWorkout?
    @Published var alertTableArray: [Alert] = []

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                self.lastHR = self.heartRate
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.minimumHeartRate = statistics.minimumQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.maximumHeartRate = statistics.maximumQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                if(self.arrayCurHR.count > 10) {
                    self.arrayCurHR.removeFirst()
                }
                self.arrayCurHR.append(self.heartRate/200)
                self.DiffHR = self.heartRate - self.lastHR
                if(self.arraydiffHR.count > 10) {
                    self.arraydiffHR.removeFirst()
                }
                self.arraydiffHR.append(self.DiffHR/200)
                
                if(self.DiffHR > 10) {
                    self.alertTableArray.append(Alert(direction: "High", time: "\(self.hour):\(self.minute)"))
                }else if(self.DiffHR < -10) {
                    self.alertTableArray.append(Alert(direction: "Low", time: "\(self.hour):\(self.minute)"))
                }
                
                
            default:
                return
            }
        }
    }

    func resetWorkout() {
        averageHeartRate = 0
        heartRate = 0
        minimumHeartRate = 0
        maximumHeartRate = 0
        arrayCurHR.removeAll()
        arraydiffHR.removeAll()
        DiffHR = 0
        lastHR = 0
        return
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
