//
//  AlertSoundController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Justin Plett on 3/16/22.
//

import Foundation
import WatchKit

class AlertSoundController: ObservableObject {
    static let instance = AlertSoundController()
    
    func triggerAlertSound() {
        WKInterfaceDevice.current().play(.notification)
    }
}
