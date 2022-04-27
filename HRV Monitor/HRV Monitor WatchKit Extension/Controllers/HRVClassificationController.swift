//
//  HRVClassificationController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Mia Hunt on 4/18/22.
//

import Foundation
import CoreML
class HRVClassificationController: NSObject, ObservableObject  {
    
    @Published var warning: Bool = false
    @Published var alert: Bool = false
    @Published var alertTableArray: [Alert] = [Alert]()
    
    func classifyHRV(HR: Double, HRV: Double) {
        
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        let second = Calendar.current.component(.second, from: Date())
        
        let classificationModel = HRV_Classification();
        guard let classification = try? classificationModel.prediction(RMSSD: HRV, HR: HR, user: "yes") else {
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
    
    func updateHRVClassification(HR: Double, HRV: Double, label: String) {
        let dataSet: MLBatchProvider = trainingData(HR: HR, HRV: HRV, label: label);

        HRVClassificationUpdater.updateWith(trainingData: dataSet) {

        }
    }

    func trainingData(HR: Double, HRV: Double, label: String) -> MLBatchProvider {
        var featureProviders = [MLFeatureProvider]();



        let dataPointFeatures: [String: MLFeatureValue] = ["RMSSD": MLFeatureValue(double: HRV),
                                                           "label": MLFeatureValue(string: label)]

        if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
            featureProviders.append(provider)
        }
        return MLArrayBatchProvider(array: featureProviders)
    }

}
