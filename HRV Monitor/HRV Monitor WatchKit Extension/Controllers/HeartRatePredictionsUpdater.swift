//
//  HRVClassificationUpdater.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 4/23/22.
//

import CoreML

struct HRPredictionUpdater {
    /// The updated Drawing Classifier model.
    private static var updatedDHeartRatePredictions: HeartRatePredictions?
    /// The default Drawing Classifier model.
    private static var defaultHeartRatePredictions: HeartRatePredictions {
        do {
            return try HeartRatePredictions(configuration: .init())
        } catch {
            fatalError("Couldn't load UpdatableDrawingClassifier due to: \(error.localizedDescription)")
        }
    }
    
    private static var liveModel: HeartRatePredictions {
        updatedDHeartRatePredictions ?? defaultHeartRatePredictions
    }
    
    /// The location of the app's Application Support directory for the user.
    private static let appDirectory = FileManager.default.urls(for: .applicationSupportDirectory,
                                                               in: .userDomainMask).first!
    
    /// The default Drawing Classifier model's file URL.
    private static let defaultModelURL = HeartRatePredictions.urlOfModelInThisBundle
    /// The permanent location of the updated Drawing Classifier model.
    private static var updatedModelURL = appDirectory.appendingPathComponent("HRpersonalized.mlmodelc")
    /// The temporary location of the updated Drawing Classifier model.
    private static var tempUpdatedModelURL = appDirectory.appendingPathComponent("HRpersonalized_tmp.mlmodelc")
    
    private init() { }
    

    static func updateWith(trainingData: MLBatchProvider,
                           completionHandler: @escaping () -> Void) {
        
        /// The URL of the currently active Drawing Classifier.
        let usingUpdatedModel = updatedDHeartRatePredictions != nil
        let currentModelURL = usingUpdatedModel ? updatedModelURL : defaultModelURL
        
        /// The closure an MLUpdateTask calls when it finishes updating the model.
        func updateModelCompletionHandler(updateContext: MLUpdateContext) {
            // Save the updated model to the file system.
            saveUpdatedModel(updateContext)
            
            // Begin using the saved updated model.
            loadUpdatedModel()
            
            // Inform the calling View Controller when the update is complete
            DispatchQueue.main.async { completionHandler() }
        }
        
        HeartRatePredictions.updateModel(at: currentModelURL,
                                               with: trainingData,
                                               completionHandler: updateModelCompletionHandler)
    }
    
    /// Deletes the updated model and reverts back to original Drawing Classifier.
    static func resetDrawingClassifier() {
        // Clear the updated Drawing Classifier.
        updatedDHeartRatePredictions = nil
        
        // Remove the updated model from its designated path.
        if FileManager.default.fileExists(atPath: updatedModelURL.path) {
            try? FileManager.default.removeItem(at: updatedModelURL)
        }
    }
    
    private static func saveUpdatedModel(_ updateContext: MLUpdateContext) {
        let updatedModel = updateContext.model
        let fileManager = FileManager.default
        do {
            // Create a directory for the updated model.
            try fileManager.createDirectory(at: tempUpdatedModelURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            
            // Save the updated model to temporary filename.
            try updatedModel.write(to: tempUpdatedModelURL)
            
            // Replace any previously updated model with this one.
            _ = try fileManager.replaceItemAt(updatedModelURL,
                                              withItemAt: tempUpdatedModelURL)
            
            print("Updated model saved to:\n\t\(updatedModelURL)")
        } catch let error {
            print("Could not save updated model to the file system: \(error)")
            return
        }
    }
    
    private static func loadUpdatedModel() {
        guard FileManager.default.fileExists(atPath: updatedModelURL.path) else {
            // The updated model is not present at its designated path.
            return
        }
        
        // Create an instance of the updated model.
        guard let model = try? HeartRatePredictions(contentsOf: updatedModelURL) else {
            return
        }
        
        // Use this updated model to make predictions in the future.
        updatedDHeartRatePredictions = model
    }
    
}

extension HeartRatePredictions {
    static func updateModel(at url: URL,
                            with trainingData: MLBatchProvider,
                            completionHandler: @escaping (MLUpdateContext) -> Void) {
        
        // Create an Update Task.
        guard let updateTask = try? MLUpdateTask(forModelAt: url,
                                           trainingData: trainingData,
                                           configuration: nil,
                                           completionHandler: completionHandler)
            else {
                print("Could't create an MLUpdateTask.")
                return
        }
        
        updateTask.resume()
    }
}

extension HRPredictionUpdater {
    static func updateHeartRatePredictions(T1: Double, T2: Double, T3: Double, T4: Double, T5: Double, HRV: Double) {
        
        let dataSet: MLBatchProvider = trainingData(T1: T1, T2: T2, T3: T3, T4: T4, T5: T4, HRV: HRV);
        
        HRPredictionUpdater.updateWith(trainingData: dataSet) {
            
        }
    }
    
    static func trainingData(T1: Double, T2: Double, T3: Double, T4: Double, T5: Double, HRV: Double) -> MLBatchProvider {
        var featureProviders = [MLFeatureProvider]();
        
        
        
        let dataPointFeatures: [String: MLFeatureValue] = ["T1": MLFeatureValue(double: T1),
                                                           "T2": MLFeatureValue(double: T2),
                                                           "T3": MLFeatureValue(double: T3),
                                                           "T4": MLFeatureValue(double: T4),
                                                           "T5": MLFeatureValue(double: T5),
                                                           "HRV": MLFeatureValue(double: HRV)];
        
        if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
            featureProviders.append(provider)
        }
        return MLArrayBatchProvider(array: featureProviders)
    }
}
