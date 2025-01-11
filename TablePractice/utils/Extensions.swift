//
//  Extensions.swift
//  TablePractice
//
//  Created by Maximiliano París Gaete on 12/27/24.
//

import Foundation

//MARK: - TimeInterval

extension TimeInterval {
    /// Converts a number from minutes to seconds.
    var minutesToSeconds: TimeInterval {
        return self * 60
    }
    
    /// Converts a number from hours to minutes.
    var hoursToMinutes: TimeInterval {
        return self * 60
    }
    
    /// Converts a number from hours to seconds.
    var hoursToSeconds: TimeInterval {
        return self * 3600
    }
    
    var secondsToMinutes: Int {
        return Int(self) / 60
    }
}
