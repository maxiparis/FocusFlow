//
//  ContentViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation
import Observation

private let TASKS_KEY = "tasksArrayKey"

class ContentViewModel: ObservableObject {
    
    private var defaults = UserDefaults.standard
    @Published var currentTime: String?
    @Published var tasks: [Task] {
        didSet {
            print(tasks)
            saveTasks() //Every time tasks is updated (deleting or updating a task) the tasks array is saved to the defaults
        }
    }
    
    var hours: [Int]
    var minutes: [Int]
    
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
    
    
    
    
    init() {
        self.hours = [0,1,2,3,4,5,6,7,8,9,10,11,12]
        self.minutes = []
        
        for number in 0...59 {
            self.minutes.append(number)
        }
        
        self.tasks = []
        loadTasks()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            defaults.set(encodedData, forKey: TASKS_KEY)
        }
    }
    
    private func loadTasks() {
        if let tasksData = defaults.data(forKey: TASKS_KEY),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            self.tasks = decodedTasks
        }
    }
    
    func updateCurrentTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        currentTime = dateFormatter.string(from: Date())
    }
}
