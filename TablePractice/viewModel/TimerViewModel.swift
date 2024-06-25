//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Observation
import Combine

class TimerViewModel: ObservableObject {
    @Published var tasks: [Task]
    @Published var currentTaskIndex: Int?
    @Published var countdownString: String = ""
    
    init(tasks: [Task]) {
        self.tasks = tasks
        if (self.tasks.count > 0) {
            self.currentTaskIndex = 0
        } else {
            currentTaskIndex = nil
        }
    }
    
    func startTimer() {
        self.generateCountdownString()
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let index = self.currentTaskIndex {
                self.tasks[index].timer.remainingTimeInSecs -= 1
                self.generateCountdownString()
            }
        }
        
    }
    
    func generateCountdownString() {
        if let index = self.currentTaskIndex {
            countdownString = tasks[index].timer.remainingTimeInSecs.description
        }
    }
}
