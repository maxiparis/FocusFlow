//
//  Tasks.swift
//  TablePractice
//
//  Created by Maximiliano París Gaete on 10/1/24.
//

import Foundation

struct TasksData {
    
    //MARK: - Properties
    
    private var persistanceManager = PersistenceManager.shared
    
    //Every time these tasks are set we are saving them to the UsersDefaults.
    var tasks: [Task] {
        didSet {
//            print("\n\nTasks in the model was set to = \(tasks)")
            saveTasks()
        }
    }
    
    var estimatedFinishingTime: String {
        // Filter out completed tasks
        let incompleteTasks = tasks.filter { !$0.completed }
        
        // Calculate the total time for incomplete tasks
        let totalTimeInSeconds = incompleteTasks.reduce(0) { (result, task) -> Int in
            // Extract the timer from the task
            let timer = task.timer
            
            let exceededTime: TimeInterval = {
                if let timerState = timer.timerState {
                    switch timerState {
                        case .exceeded(let seconds):
                            return seconds
                        default: //I only care if the current task has exceeded time
                            return 0
                    }
                }
                return 0
            }()
            
            // Calculate total seconds for the current task
//            let hoursInSeconds = timer.hours * 3600
//            let minutesInSeconds = timer.minute * 60
            let totalSecondsForTask = timer.remainingTimeInSecs + exceededTime
            
            // Return the accumulated result
            return result + Int(totalSecondsForTask)
        }
        
        // Calculate the estimated finishing time
        let finishingTime = Date().addingTimeInterval(TimeInterval(totalTimeInSeconds))
        
        // Format the finishing time as a short time string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: finishingTime)

    }

    var estimatedFinishingTimeRelative: String {
        let totalTimeInSeconds = tasks.reduce(0) { (result, task) -> Int in
            let time = task.timer
            return result + (time.hours * 3600 + time.minute * 60)
        }
        
        // If total time is zero, return "No tasks remaining"
        guard totalTimeInSeconds > 0 else {
            return "No tasks remaining"
        }
        
        // Calculate hours and minutes
        let hours = totalTimeInSeconds / 3600
        let minutes = (totalTimeInSeconds % 3600) / 60
        
        // Create a human-readable string
        var components = [String]()
        
        if hours > 0 {
            components.append("\(hours) hour\(hours > 1 ? "s" : "")")
        }
        if minutes > 0 {
            components.append("\(minutes) minute\(minutes > 1 ? "s" : "")")
        }
        
        return components.joined(separator: " and ")
    }
    
    var nextTimestampObjective: TimeInterval? {
        get { persistanceManager.nextTimestampObjective }
        set { persistanceManager.nextTimestampObjective = newValue }
    }
    
    //MARK: - Initializers
    
    init() {
        self.tasks = persistanceManager.loadTasks() ?? []
    }
    
    //MARK: - Logic
    
    mutating func completeTask(in index: Int) {
        self.tasks[index].completed = true
    }
    
    mutating func addMinutesToTask(minutes: AddMinutes, at index: Int) {
        if self.tasks[index].timer.isOverdue {
            self.tasks[index].timer.remainingTimeInSecs = Double(minutes.rawValue) * 60
        } else {
            self.tasks[index].timer.remainingTimeInSecs += Double(minutes.rawValue) * 60
        }
    }
    
    mutating func importDefaultTasks() {
        let tasks: [Task] = [
            Task(title: "Arrive home/unwind", timer: TimeTracked(hours: 0, minute: 15)),
            Task(title: "Quick snack", timer: TimeTracked(hours: 0, minute: 10)),
            Task(title: "Complete CS 340 homework", timer: TimeTracked(hours: 1, minute: 0)),
            Task(title: "Break/exercise", timer: TimeTracked(hours: 0, minute: 15)),
            Task(title: "Work on HIST201 paper", timer: TimeTracked(hours: 0, minute: 45)),
            Task(title: "Dinner/relax", timer: TimeTracked(hours: 0, minute: 35))
        ]
        
        self.tasks = tasks
    }
    
    mutating func importOverdueTasks() {
        let tasks: [Task] = [
            Task(title: "Arrive home/unwind", timer: TimeTracked(hours: 0, minute: 0, timerState: TimerState.exceeded(30))),
            Task(title: "Quick snack", timer: TimeTracked(hours: 0, minute: 10)),
            Task(title: "Complete CS 340 homework", timer: TimeTracked(hours: 1, minute: 0)),
            Task(title: "Break/exercise", timer: TimeTracked(hours: 0, minute: 15)),
            Task(title: "Work on HIST201 paper", timer: TimeTracked(hours: 0, minute: 45)),
            Task(title: "Dinner/relax", timer: TimeTracked(hours: 0, minute: 35))
        ]
        
        self.tasks = tasks
    }
    
    mutating func clearAllTasks() {
        tasks.removeAll()
    }
    
    //MARK: - Persistance
    
    func saveTasks() {
        persistanceManager.saveTasks(tasks)
    }
    
}
