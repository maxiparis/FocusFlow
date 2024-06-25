//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Observation

class TimerViewModel {
    @Published var tasks: [Task]
    @Published var currentTask: Task?
    
    init(tasks: [Task]) {
        self.tasks = tasks
        if (self.tasks.count > 0) {
            self.currentTask = tasks[0]
        } else {
            currentTask = nil
        }
    }
}
