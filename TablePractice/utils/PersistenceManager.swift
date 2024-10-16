//
//  PersistenceManager.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 10/16/24.
//

import Foundation


private let TASKS_KEY = "tasksArrayKey"

class PersistenceManager {
    private var defaults = UserDefaults.standard

    
    func saveTasks(_ tasks: [Task]) {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            defaults.set(encodedData, forKey: TASKS_KEY)
        }
    }
    
    func loadTasks() -> [Task]? {
        if let tasksData = defaults.data(forKey: TASKS_KEY),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            return decodedTasks
        }
        return nil
    }
}
