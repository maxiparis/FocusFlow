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
    var timer: Time
    var completed: Bool = false
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title && lhs.timer.hours == rhs.timer.hours && lhs.timer.minute == rhs.timer.minute
    }
    
    func generateTimerText() -> String {
        let hoursText = timer.hours < 10 ? "0\(timer.hours.description)" : timer.hours.description
        let minutesText = timer.minute < 10 ? "0\(timer.minute.description)" : timer.minute.description
        return hoursText + ":" + minutesText
    }
}

struct Time: Decodable, Encodable {
    var hours: Int
    var minute: Int
    var remainingTimeInSecs: Int
    
    init(hours: Int, minute: Int) {
        self.hours = hours
        self.minute = minute
        self.remainingTimeInSecs = (hours * 60 * 60) + (minute * 60)
    }
}

struct SessionTask {
    var task: Task
    var totalFinishingTime: Time
    var isCompleted: Bool {
        task.completed
    }
}
