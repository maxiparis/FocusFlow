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


class TimerViewModel: ObservableObject {
    
    //MARK: - Variables
    
    @Published var tasksData: TasksData = TasksData()
    var tasks: [Task] {
        get {
            tasksData.tasks
        }
        set {
            tasksData.tasks = newValue
        }
    }
    var currentTaskIndex: Int? {
        if (tasks.count > 0) {
            return tasks.firstIndex { task in
                !task.completed
            }
        } else {
            return nil
        }
    }
    var currentTask: Task? {
        if let currentTaskIndex {
            return tasks[currentTaskIndex]
        } else {
            return nil
        }
    }
    var countdownString: String? {
        if let currentTask {
            if currentTask.timer.isOverdue {
                return formatTime(from: currentTask.timer.timeExceeded)
            } else {
                return formatTime(from: currentTask.timer.remainingTimeInSecs)
            }
        } else {
            return nil
        }
    }
    @Published var timerPaused: Bool = false
    @Published var nextActivityText: String = ""
    
    @Binding var isPresented: Bool //this variable controls when the TimerView is presented.
    
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
            if let index = self.currentTaskIndex {
                if !self.tasks[index].timer.isOverdue { // we are on track
                    self.tasks[index].timer.remainingTimeInSecs -= 1
                } else { // we are overdue
                    self.tasks[index].timer.timeExceeded += 1
                }
            }
        }
    }
    
    
    func pauseTimer() {
        timer.invalidate()
        timerPaused = true
    }
    
    func completeTask() {
        if let currentTaskIndex {
            self.pauseTimer()
            
            tasksData.completeTask(in: currentTaskIndex)
            self.tasks = tasksData.tasks
            
            let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
            
            if currentTaskIsLastOne {
                //dismiss view
                //tell the user how much time they saved or wasted
                isPresented = false
            }
            
            generateNextActivityText()
            self.startTimer()
        }
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

    
//    func generateCountdownString() {
//        if let index = self.currentTaskIndex {
//            var remainingSecondsForString = tasks[index].timer.remainingTimeInSecs
//            
//            let hours: Int = Int(remainingSecondsForString) / SECONDS_IN_HOUR
//            remainingSecondsForString -= Double(hours * SECONDS_IN_HOUR)
//            let minutes: Int = Int(remainingSecondsForString) / SECONDS_IN_MINUTE
//            remainingSecondsForString -= Double(minutes * SECONDS_IN_MINUTE)
//            
//            let hoursText: String? = {
//                if hours >= 10 {
//                    return hours.description
//                } else if hours >= 1 {
//                    return "0\(hours.description)"
//                } else {
//                    return nil
//                }
//            }()
//            let minutesText: String = {
//                if minutes >= 10 {
//                    return minutes.description
//                } else {
//                    return "0\(minutes.description)"
//                }
//            }()
//            let secondsText: String = {
//                if remainingSecondsForString >= 10 {
//                    return remainingSecondsForString.description
//                } else {
//                    return "0\(remainingSecondsForString.description)"
//                }
//            }()
//            
//            
//            if let hoursText = hoursText {
//                let countdownStringWithHours = hoursText + ":" + minutesText + ":" + secondsText
//                countdownString = countdownStringWithHours
//            } else {
//                let countdownStringWithoutHours = minutesText + ":" + secondsText
//                countdownString = countdownStringWithoutHours
//            }
//        }
//    }
    
    func generateNextActivityText() {
        if let currentTaskIndex {
            let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
            
            if currentTaskIsLastOne {
                self.nextActivityText = "This is your last task. "
            } else {
                let nextTaskTitle = self.tasks[currentTaskIndex+1].title
                self.nextActivityText = "Next Activity: \(nextTaskTitle)."
            }
        }
    }
    
    
    
}
