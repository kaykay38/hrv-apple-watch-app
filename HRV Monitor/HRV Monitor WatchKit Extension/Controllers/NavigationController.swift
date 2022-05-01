//
//  NavigationController.swift
//  HRV Monitor WatchKit Extension
//
//  Created by Whitney Bolar on 5/1/22.
//

import Foundation
import SwiftUI
import UserNotifications

class NavigationManager: ObservableObject {
    
    @Published var NavActive: Bool = false
    
    func openSurvey() {
        self.NavActive = true
    }
}

