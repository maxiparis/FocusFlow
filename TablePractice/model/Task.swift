//
//  Task.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation

struct Task: Identifiable, Equatable, Decodable, Encodable {
    var id = UUID()
    var title: String
    var timer: TimeTracked
    var completed: Bool = false
    
    // Update the initializer to include dueDate
    init(title: String, timer: TimeTracked) {
        self.title = title
        self.timer = timer
    }

    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title && lhs.timer.hours == rhs.timer.hours && lhs.timer.minute == rhs.timer.minute
    }

    func generateTimerText() -> String {
        let hoursText = timer.hours < 10 ? "0\(timer.hours.description)" : timer.hours.description
        let minutesText = timer.minute < 10 ? "0\(timer.minute.description)" : timer.minute.description
        return hoursText + ":" + minutesText
    }
}

struct TimeTracked: Decodable, Encodable {
    
    var hours: Int
    var minute: Int
    var remainingTimeInSecs: TimeInterval
    var timerState: TimerState? //if this is nil, it means we haven't started this task
    var isOverdue: Bool {
        remainingTimeInSecs == 0
    }
    var dueDate: Date? {
        if isOverdue {
            return nil
        } else {
            return Date().addingTimeInterval(remainingTimeInSecs)
        }
    }
    
    init(hours: Int, minute: Int, timerState: TimerState? = nil) {
        self.hours = hours
        self.minute = minute
        self.timerState = timerState
        self.remainingTimeInSecs = TimeInterval((hours * 60 * 60) + (minute * 60))
    }
}

enum TimerState: Codable {
    case exceeded(TimeInterval)
    case saved(TimeInterval)
}
