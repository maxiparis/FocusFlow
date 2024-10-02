//
//  ContentViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation
import Observation

class ContentViewModel: ObservableObject {
    
    private var model = TasksData()
    @Published var tasks: [Task] {
        didSet {
            saveTasksToModel()
        }
    }
    
    init() {
        self.tasks = model.tasks
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
    
    func saveTasksToModel() {
        model.saveTasks(self.tasks)
    }
    
    
}
