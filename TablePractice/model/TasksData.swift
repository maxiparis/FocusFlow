//
//  Tasks.swift
//  TablePractice
//
//  Created by Maximiliano París Gaete on 10/1/24.
//

import Foundation

private let TASKS_KEY = "tasksArrayKey"

class TasksData {
    private var defaults = UserDefaults.standard
    var tasks: [Task] {
        didSet {
            print("\n\n***Tasks in the model was set to = \(tasks)")
        }
    }
    var currentTaskIndex = 0
    
    init() {
        self.tasks = []
        loadTasks()
    }

    func saveTasks(_ tasks: [Task] ) {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            self.tasks = tasks
            defaults.set(encodedData, forKey: TASKS_KEY)
        }
    }
    
    private func loadTasks() {
        if let tasksData = defaults.data(forKey: TASKS_KEY),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            self.tasks = decodedTasks
        }
    }
    
    var estimatedFinishingTime: String {
        // Filter out completed tasks
        let incompleteTasks = tasks.filter { !$0.completed }
        
        // Calculate the total time for incomplete tasks
        let totalTimeInSeconds = incompleteTasks.reduce(0) { (result, task) -> Int in
            let time = task.timer
            return result + (time.hours * 3600 + time.minute * 60)
        }
        
        // Calculate the estimated finishing time
        let finishingTime = Date().addingTimeInterval(TimeInterval(totalTimeInSeconds))
        
        // Format the finishing time as a short time string
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
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
    
    func completeTask(in index: Int) {
        self.tasks[index].completed = true
        saveTasks(self.tasks)
    }
    
    
}
