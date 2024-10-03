//
//  Tasks.swift
//  TablePractice
//
//  Created by Maximiliano París Gaete on 10/1/24.
//

import Foundation

private let TASKS_KEY = "tasksArrayKey"

struct TasksData {
    private var defaults = UserDefaults.standard
    var tasks: [Task]
    
    init() {
        self.tasks = []
        loadTasks()
    }

    func saveTasks(_ tasks: [Task] ) {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            defaults.set(encodedData, forKey: TASKS_KEY)
        }
    }
    
    private mutating func loadTasks() {
        if let tasksData = defaults.data(forKey: TASKS_KEY),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            self.tasks = decodedTasks
        }
    }
    
//    mutating func addTask(_ task: Task) {
//        tasks.append(task)
//        saveTasks(self.tasks)
//    }
    
}
