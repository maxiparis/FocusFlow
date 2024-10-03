//
//  HoursMinutes.swift
//  TablePractice
//
//  Created by Maximiliano París Gaete on 10/1/24.
//

import Foundation

class HoursMinutes {
    static let shared = HoursMinutes() // Shared instance
    
    var hours: [Int]
    var minutes: [Int]
    
    private init() { // Private initializer
        self.hours = Array(0...12) // Creating hours array
        self.minutes = Array(0...59) // Creating minutes array
    }
}
