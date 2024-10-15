//
//  ContentViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation
import Observation

class TasksViewModel: ObservableObject {
    
    var model = TasksData()
    @Published var tasks: [Task] {
        didSet {
            saveTasksToModel()
        }
    }
    var estimatedFinishingTime: String {
        get {
            let totalTimeInSeconds = tasks.reduce(0) { (result, task) -> Int in
                let time = task.timer
                return result + (time.hours * 3600 + time.minute * 60)
            }
            
            let finishingTime = Date().addingTimeInterval(TimeInterval(totalTimeInSeconds))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: finishingTime)
        }
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
    
    init() {
        self.tasks = model.tasks
    }
    
    
    func saveTasksToModel() {
        model.saveTasks(self.tasks)
    }
    
    
}
