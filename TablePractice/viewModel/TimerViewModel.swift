//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Observation
import Combine
import SwiftUI

private let SECONDS_IN_MINUTE = 60
private let SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60


class TimerViewModel: ObservableObject {
    
    //MARK: - Variables
    
    @Published var tasksData: TasksData = TasksData()
    var tasks: [Task] {
        get {
            tasksData.tasks
        }
        set {
            tasksData.tasks = newValue
        }
    }
    var currentTaskIndex: Int {
        return tasks.firstIndex { !$0.completed } ?? 0
    }
    var currentTask: Task {
        get {
            tasks[currentTaskIndex]
        }
        set {
            tasks[currentTaskIndex] = newValue
        }
    }
    var countdownString: String? {
        currentTask.timer.isOverdue ? formatTime(from: currentTask.timer.timeExceeded) : formatTime(from: currentTask.timer.remainingTimeInSecs)
    }
    var currentTaskIsOverdue: Bool {
        currentTask.timer.isOverdue
    }
    @Published var timerPaused: Bool = false
    @Published var nextActivityText: String = ""
    
    @Binding var isPresented: Bool //this variable controls when the TimerView is presented.
    
    var timer: Timer = Timer()
    
    //MARK: - Initializer
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    //MARK: - Model access
    
    var estimatedFinishingTime: String {
        tasksData.estimatedFinishingTime
    }
    
    var estimatedFinishingTimeRelative: String {
        tasksData.estimatedFinishingTimeRelative
    }
    
    func saveTasksToModel() {
        self.tasksData.tasks = self.tasks
    }
    
    //MARK: - User Intents
    
    func startTimer() {
        self.timerPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !self.currentTask.timer.isOverdue { // we are on track
                self.currentTask.timer.remainingTimeInSecs -= 1
            } else { // we are overdue
                self.currentTask.timer.timeExceeded += 1
            }
        }
    }
    
    
    func pauseTimer() {
        timer.invalidate()
        timerPaused = true
    }
    
    func completeTask() {
        self.pauseTimer()
        
        tasksData.completeTask(in: currentTaskIndex)
        self.tasks = tasksData.tasks
        
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        if currentTaskIsLastOne {
            //dismiss view
            //tell the user how much time they saved or wasted
            isPresented = false
        }
        
        generateNextActivityText()
        self.startTimer()
    }
    
    //MARK: - Utils
    
    
    
    //MARK: - UI Utils
    
    func formatTime(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func generateNextActivityText() {
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        if currentTaskIsLastOne {
            self.nextActivityText = "This is your last task. "
        } else {
            let nextTaskTitle = self.tasks[currentTaskIndex+1].title
            self.nextActivityText = "Next Activity: \(nextTaskTitle)."
        }
    }
    
    
    
}
