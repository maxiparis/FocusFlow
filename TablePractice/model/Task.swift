//
//  Task.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation

struct Task: Hashable, Equatable {
    
    var title: String
    var timer: Time
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title && lhs.timer.hours == rhs.timer.hours && lhs.timer.minute == rhs.timer.minute
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(timer.hours)
        hasher.combine(timer.minute)
    }
    
    func generateTimerText() -> String {
        let hoursText = timer.hours < 10 ? "0\(timer.hours.description)" : timer.hours.description
        let minutesText = timer.minute < 10 ? "0\(timer.minute.description)" : timer.minute.description
        return hoursText + ":" + minutesText
    }
}

struct Time {
    var hours: Int
    var minute: Int
}
