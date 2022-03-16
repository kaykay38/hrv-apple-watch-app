//
//  HapticController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/16/22.
//

import Foundation
import WatchKit

class HapticController: ObservableObject {
    static let instance = HapticController()
    
    
    
    func triggerHaptic () {
        WKInterfaceDevice.current().play(.notification)
    }
}
