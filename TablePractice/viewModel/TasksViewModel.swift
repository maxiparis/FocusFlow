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
    
    @Published var model = TasksData()
    
    //MARK: - Model access
    
    var tasks: [Task] {
        get { model.tasks }
        set { model.tasks = newValue }
    }
    
    var estimatedFinishingTime: String {
        model.estimatedFinishingTime
    }
    
    var estimatedFinishingTimeRelative: String {
        model.estimatedFinishingTimeRelative
    }
    
    func markTasksAsNotCompleted() {
        for i in 0..<model.tasks.count {
            model.tasks[i].completed = false
        }
    }
    
    //MARK: - User Intents
    
    func importDefaultTasks() {
        model.importDefaultTasks()
    }
}
