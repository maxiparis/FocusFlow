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
    
    
}
