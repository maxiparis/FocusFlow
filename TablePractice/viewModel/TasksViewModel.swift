//
//  ContentViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation
import Observation

class TasksViewModel: ObservableObject {
    
    //MARK: - Properties
    
    var model = TasksData()
    @Published var tasks: [Task] {
        didSet {
            saveTasksToModel()
        }
    }
    
    
    //MARK: - Initializer
    
    init() {
        self.tasks = model.tasks
    }
    
    
    //MARK: - Model access
    
    var estimatedFinishingTime: String {
        model.estimatedFinishingTime
    }
    
    var estimatedFinishingTimeRelative: String {
        model.estimatedFinishingTimeRelative
    }
    
    func saveTasksToModel() {
        model.saveTasks(self.tasks)
    }
    
    func markTasksAsNotCompleted() {
        for i in 0..<tasks.count {
            tasks[i].completed = false
        }
        saveTasksToModel()
    }
}
