//
//  PersistenceManager.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 10/16/24.
//

import Foundation


private let TASKS_KEY = "tasksArrayKey"
private let LAST_BACKGROUND_DATE_KEY = "lastBackgroundDateKey"
private let NEXT_TIMESTAMP_KEY = "nextTimeStampKey"

class PersistenceManager {
    
    // MARK: - Variables
    
    static let shared = PersistenceManager()
    
    private var defaults = UserDefaults.standard
    
    var lastBackgroundDate: Date? {
        get { defaults.object(forKey: LAST_BACKGROUND_DATE_KEY) as? Date }
        set { defaults.set(newValue, forKey: LAST_BACKGROUND_DATE_KEY) }
    }
    
    var nextTimestampObjective: TimeInterval? {
        get { defaults.object(forKey: NEXT_TIMESTAMP_KEY) as? TimeInterval }
        set { defaults.set(newValue, forKey: NEXT_TIMESTAMP_KEY) }
    }
    
    // MARK: - Private initializer
    
    private init() { }

    
    // MARK: - Data Access/Persistance
    
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

