//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Observation
import Combine

private let SECONDS_IN_MINUTE = 60
private let SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60


class TimerViewModel: ObservableObject {
    
    //MARK: - Variables
    
    @Published var tasksData: TasksData
    @Published var tasks: [Task] = []
    @Published var currentTaskIndex: Int?
    @Published var countdownString: String = ""
    @Published var timerPaused: Bool = false
    @Published var nextActivityText: String = ""
    
    var timer: Timer = Timer()
    
    //MARK: - Initializer

    init(model: TasksData) {
        self.tasksData = model
        self.tasks = tasksData.tasks
        if (self.tasks.count > 0) {
            self.currentTaskIndex = 0
        } else {
            currentTaskIndex = nil
        }
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
        self.generateCountdownString()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if var index = self.currentTaskIndex {
                if self.tasks[index].timer.remainingTimeInSecs > 0 {
                    self.tasks[index].timer.remainingTimeInSecs -= 1
                    self.generateCountdownString()
                    self.saveTasksToModel()
                } else {
                    index += 1
                    self.currentTaskIndex = index
                    self.tasks[index].timer.remainingTimeInSecs -= 1
                    self.generateCountdownString()
                    self.saveTasksToModel()
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
                //dismiss
            } else {
                self.currentTaskIndex = currentTaskIndex + 1
            }
            
            generateNextActivityText()
            self.startTimer()
            
        }
        
    }
    
    //MARK: - Utils
    
    func restartCurrentTaskIndex() {
        self.currentTaskIndex = 0
    }

    
    //MARK: - UI Utils
    
        
    func generateCountdownString() {
        if let index = self.currentTaskIndex {
            var remainingSecondsForString = tasks[index].timer.remainingTimeInSecs
            
            let hours: Int = remainingSecondsForString / SECONDS_IN_HOUR
            remainingSecondsForString -= hours * SECONDS_IN_HOUR
            let minutes: Int = remainingSecondsForString / SECONDS_IN_MINUTE
            remainingSecondsForString -= minutes * SECONDS_IN_MINUTE
            
            let hoursText: String? = {
                if hours >= 10 {
                    return hours.description
                } else if hours >= 1 {
                    return "0\(hours.description)"
                } else {
                    return nil
                }
            }()
            let minutesText: String = {
                if minutes >= 10 {
                    return minutes.description
                } else {
                    return "0\(minutes.description)"
                }
            }()
            let secondsText: String = {
                if remainingSecondsForString >= 10 {
                    return remainingSecondsForString.description
                } else {
                    return "0\(remainingSecondsForString.description)"
                }
            }()
            
            
            if let hoursText = hoursText {
                let countdownStringWithHours = hoursText + ":" + minutesText + ":" + secondsText
                countdownString = countdownStringWithHours
            } else {
                let countdownStringWithoutHours = minutesText + ":" + secondsText
                countdownString = countdownStringWithoutHours
            }
        }
    }
    
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
