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
        model.estimatedFinishingTime
    }
    var estimatedFinishingTimeRelative: String {
        model.estimatedFinishingTimeRelative
    }
    
    init() {
        self.tasks = model.tasks
    }
    
    
    func saveTasksToModel() {
        model.saveTasks(self.tasks)
    }
    
    
}
