//
//  HRVClassificationController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia Hunt on 4/18/22.
//

import Foundation
class HRVClassificationController: NSObject, ObservableObject  {
    
    @Published var warning: Bool = false
    @Published var alert: Bool = false
    @Published var alertTableArray: [Alert] = [Alert]()
    
    func classifyHRV(HR: Double, HRV: Double) {
        
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        let second = Calendar.current.component(.second, from: Date())
        
        let classificationModel = HRV_Classification();
        guard let classification = try? classificationModel.prediction(HR: HR, RMSSD: HRV) else {
            fatalError("Unexpected runtime error.")
        }
        
        self.warning = false;
        self.alert = false;
        
        if(classification.label == "moderate") {
            self.warning = true;
        }
        if(classification.label == "high") {
            self.alert = true;
            alertTableArray.append(Alert(direction: "Alert", time: "\(hour):\(minute):\(second)"))
            NotificationManager.instance.scheduleHighNotification()
        }
        print("HR: \(HR) HRV: \(HRV) Classification: \(classification.label)")
    }

}
