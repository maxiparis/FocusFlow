//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Observation
import Combine
import SwiftUI

private let SECONDS_IN_MINUTE = 60
private let SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60

enum AddMinutes: Int {
    case oneMinute = 1
    case fiveMinutes = 5
    case tenMinutes = 10
}

class TimerViewModel: ObservableObject {
    
    //MARK: - Variables
    
    @Published var tasksData: TasksData = TasksData() //model
    
    var tasks: [Task] {
        get {
            tasksData.tasks
        }
        set {
            tasksData.tasks = newValue
        }
    }
    var currentTaskIndex: Int {
        return tasks.firstIndex { !$0.completed } ?? 0
    }
    var currentTask: Task {
        get {
            tasks[currentTaskIndex]
        }
        set {
            tasks[currentTaskIndex] = newValue
        }
    }
    var countdownString: String? {
        if currentTask.timer.isOverdue {
            // Unwrap the optional timerState safely
            if let timerState = currentTask.timer.timerState {
                switch timerState {
                case .exceeded(let seconds):
                    return formatTime(from: seconds)
                default:
                    return formatTime(from: currentTask.timer.remainingTimeInSecs)
                }
            } else {
                return formatTime(from: currentTask.timer.remainingTimeInSecs)
            }
        } else {
            return formatTime(from: currentTask.timer.remainingTimeInSecs)
        }
    }
    var currentTaskIsOverdue: Bool {
        currentTask.timer.isOverdue
    }
    
    var nextActivityText: String? {
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        if currentTaskIsLastOne {
            return nil
        } else {
            return self.tasks[currentTaskIndex+1].title
        }
    }
    var sessionTimerState: TimerState {
        let totalTimeSaveOrExceeded = tasks.reduce(0) { (result, task) in
            if let timerState = task.timer.timerState {
                switch(timerState) {
                case .exceeded(let seconds):
                    return result - seconds
                case .saved(let seconds):
                    return result + seconds
                }
            } else {
                return result
            }
        }
        
        return totalTimeSaveOrExceeded > 0 ? .saved(totalTimeSaveOrExceeded) : .exceeded(totalTimeSaveOrExceeded * -1)
    }
    
    // example: 1:34:23
    var sessionTimerStateText: String {
        switch(sessionTimerState) {
        case .saved(let seconds),.exceeded(let seconds):
            formatTime(from: seconds)
        }
    }
    
    //example: 1 hour, 5 minutes and 30 seconds
    var sessionTimerStateWorded: String {
        switch(sessionTimerState) {
        case .saved(let seconds),.exceeded(let seconds):
            formatTimeWords(from: seconds)
        }
    }
    
    @Published var timerPaused: Bool = false
    @Binding var isPresented: Bool //this variable controls when the TimerView is presented.
    @Published var displayReportView: Bool = false //this variable controls when the ReportView is presented.

    var timer: Timer = Timer()
    
    //MARK: - Initializer
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    //MARK: - Model access
    
    var estimatedFinishingTime: String {
        tasksData.estimatedFinishingTime
    }
    
    var estimatedFinishingTimeRelative: String {
        tasksData.estimatedFinishingTimeRelative
    }
    
    func saveTasksToModel() {
        self.tasksData.tasks = self.tasks
    }
    
    //MARK: - User Intents
    
    func startTimer() {
        self.timerPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !self.currentTask.timer.isOverdue { // we are on track
                self.currentTask.timer.remainingTimeInSecs -= 1
                self.currentTask.timer.timerState = .saved(self.currentTask.timer.remainingTimeInSecs)
            } else { // we are overdue
                if let timerState = self.currentTask.timer.timerState {
                    switch timerState {
                    case .exceeded(let seconds):
                        self.currentTask.timer.timerState = .exceeded(seconds + 1)
                    case .saved:
                        self.currentTask.timer.timerState = .exceeded(1)
                    }
                }
            }
        }
    }
    
    
    func pauseTimer() {
        timer.invalidate()
        timerPaused = true
    }
    
    func completeTask() {
        self.pauseTimer()
        
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        tasksData.completeTask(in: currentTaskIndex)
        self.tasks = tasksData.tasks
        
        
        if currentTaskIsLastOne {
            displayReportView = true
            return
        }
        
        self.startTimer()
    }
    
    func addTime(_ minutes: AddMinutes) {
        tasksData.addMinutesToTask(minutes: minutes, at: currentTaskIndex)
    }
    
    //MARK: - Utils
    
    
    
    //MARK: - UI Utils
    
    func formatTime(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func formatTimeWords(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60

        var components: [String] = []

        if hours > 0 {
            components.append(hours == 1 ? "\(hours) hour" : "\(hours) hours")
        }
        
        if minutes > 0 {
            components.append(minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes")
        }
        
        if seconds > 0 {
            components.append(seconds == 1 ? "\(seconds) second" : "\(seconds) seconds")
        }

        // Combine the components with appropriate separators
        if components.count > 1 {
            let lastComponent = components.removeLast()
            return components.joined(separator: ", ") + ", and " + lastComponent
        } else if let firstComponent = components.first {
            return firstComponent
        } else {
            return "0 seconds"
        }
    }
}
