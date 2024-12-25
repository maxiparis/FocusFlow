//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Combine
import SwiftUI
import UIKit

private let SECONDS_IN_MINUTE = 60
private let SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60

enum AddMinutes: Int {
    case oneMinute = 1
    case fiveMinutes = 5
    case tenMinutes = 10
}

class TimerViewModel: ObservableObject {
    
    // MARK: - Variables
    
    @Published var tasksData: TasksData = TasksData() //model
    
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
        return formatTime(from: currentTask.timer.remainingTimeInSecs)
//        if currentTask.timer.isOverdue {
//            if let timerState = currentTask.timer.timerState {
//                switch timerState {
//                case .exceeded(let seconds):
//                    return formatTime(from: seconds)
//                default:
//                    return formatTime(from: currentTask.timer.remainingTimeInSecs)
//                }
//            } else {
//                return formatTime(from: currentTask.timer.remainingTimeInSecs)
//            }
//        } else {
//            return formatTime(from: currentTask.timer.remainingTimeInSecs)
//        }
    }
    
    var currentTaskIsOverdue: Bool {
        currentTask.timer.isOverdue
    }
    
    var nextActivityText: String? {
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        if currentTaskIsLastOne {
            return nil
        } else {
            return self.tasks[currentTaskIndex + 1].title
        }
    }
    
    var sessionTimerState: TimerState {
        let totalTimeSaveOrExceeded = tasks.reduce(0) { (result, task) in
            if let timerState = task.timer.timerState {
                switch(timerState) {
                case .exceeded(let seconds):
                    return result - seconds
                case .saved(let seconds):
                    return result + seconds
                }
            } else {
                return result
            }
        }
        
        return totalTimeSaveOrExceeded > 0 ? .saved(totalTimeSaveOrExceeded) : .exceeded(totalTimeSaveOrExceeded * -1)
    }
    
    var sessionTimerStateText: String {
        switch(sessionTimerState) {
        case .saved(let seconds), .exceeded(let seconds):
            return formatTime(from: seconds)
        }
    }
    
    var sessionTimerStateWorded: String {
        switch(sessionTimerState) {
        case .saved(let seconds), .exceeded(let seconds):
            return formatTimeWords(from: seconds)
        }
    }
    private var pendingSavedDateFromBackground: Bool = false // This variable acts as a semaphore to know when we should recalculate time or not.
    
    @Published var timerPaused: Bool = false
    @Binding var isPresented: Bool
    @Published var displayReportView: Bool = false
    
    var timer: Timer = Timer()
    
    // MARK: - Initializer
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    // MARK: - Model access
    
    var estimatedFinishingTime: String {
        tasksData.estimatedFinishingTime
    }
    
    var estimatedFinishingTimeRelative: String {
        tasksData.estimatedFinishingTimeRelative
    }
    
    func saveTasksToModel() {
        self.tasksData.tasks = self.tasks
    }
    
    
    // MARK: - Background/Active State Logic
    
    func recalculateTimer() {
        guard pendingSavedDateFromBackground else { return }
        guard let lastBackgroundDate = PersistenceManager.shared.lastBackgroundDate else { return }
        
        pendingSavedDateFromBackground = false
        
        var secondsGone = Date().timeIntervalSince(lastBackgroundDate).rounded()
        print("Seconds gone: \(secondsGone)") //TODO: remove
        
        if !timerPaused {
            //find out which state we are in
            if currentTaskIsOverdue, let timerState = currentTask.timer.timerState {
                switch timerState {
                    case .exceeded(let seconds):
                        let newSeconds = seconds + secondsGone
                        self.currentTask.timer.timerState = .exceeded(newSeconds)
                    case .saved:
                        return
                }
            } else { //is not overdue
                if currentTask.timer.remainingTimeInSecs >= secondsGone {
                    //first case: user left and came back before going into "overdue".
                    currentTask.timer.remainingTimeInSecs -= secondsGone
                    currentTask.timer.timerState = .saved(currentTask.timer.remainingTimeInSecs)
                } else {
                    //second case: user left and came back after the timer reached 0, meaning it went "overdue".
                    secondsGone -= currentTask.timer.remainingTimeInSecs
                    currentTask.timer.remainingTimeInSecs = 0
                    currentTask.timer.timerState = .exceeded(secondsGone)
                }
            }
        }
    }
    
    func calculateNextTimestampObjective(_ task: Task) {
        let calendar = Calendar.current
        let nextTimestamp = calendar.date(byAdding: .second, value: Int(task.timer.originalHoursAndMinutesAsSeconds), to: Date())
        tasksData.nextTimestampObjective = nextTimestamp?.timeIntervalSince1970
    }
    
    func saveBackgroundDate() {
        pendingSavedDateFromBackground = true
        PersistenceManager.shared.lastBackgroundDate = Date()
    }
    
    // MARK: - User Intents
    
    func startTimer() {
        self.timerPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            //calculate the difference between now
            if let nextTimestampObjective = self.tasksData.nextTimestampObjective {
                let now = Date()
                let difference = nextTimestampObjective - now.timeIntervalSince1970
                self.currentTask.timer.remainingTimeInSecs = difference
            } else {
                print("❌ERROR")
            }
            
            
            
//            if !self.currentTask.timer.isOverdue {
//                self.currentTask.timer.remainingTimeInSecs -= 1
//                self.currentTask.timer.timerState = .saved(self.currentTask.timer.remainingTimeInSecs)
//            } else {
//                if let timerState = self.currentTask.timer.timerState {
//                    switch timerState {
//                    case .exceeded(let seconds):
//                        self.currentTask.timer.timerState = .exceeded(seconds + 1)
//                    case .saved:
//                        self.currentTask.timer.timerState = .exceeded(1)
//                    }
//                }
//            }
        }
        
        // Schedule notifications when the timer starts
//        NotificationsManager.scheduleExpirationNotifications(task: currentTask)
    }
    
    func pauseTimer() {
        timer.invalidate()
        timerPaused = true
        NotificationsManager.cancelNotifications(for: currentTask)
    }
    
    func completeTask() {
        self.pauseTimer()
        
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        tasksData.completeTask(in: currentTaskIndex)
        calculateNextTimestampObjective(currentTask) //TODO: should this be here or earlier, later?
        self.tasks = tasksData.tasks
        
        if currentTaskIsLastOne {
            displayReportView = true
            return
        }
        
        self.startTimer()
//        NotificationsManager.cancelNotifications(for: currentTask)
    }
    
    func addTime(_ minutes: AddMinutes) {
        tasksData.addMinutesToTask(minutes: minutes, at: currentTaskIndex)
        NotificationsManager.cancelNotifications(for: currentTask)
        NotificationsManager.scheduleExpirationNotifications(task: currentTask)
    }
    
    func cancelNotifications(for task: Task) {
        NotificationsManager.cancelNotifications(for: task)
    }
    
    func scheduleExpirationNotifications(for task: Task) {
        NotificationsManager.scheduleExpirationNotifications(task: task)
    }
    
    func handleStartTimer() {
        calculateNextTimestampObjective(currentTask)
        startTimer()
    }
    
    
    
    // MARK: - Utils
    
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
    
    func formatTimeWords(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        var components: [String] = []
        
        if hours > 0 {
            components.append(hours == 1 ? "\(hours) hour" : "\(hours) hours")
        }
        
        if minutes > 0 {
            components.append(minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes")
        }
        
        if seconds > 0 {
            components.append(seconds == 1 ? "\(seconds) second" : "\(seconds) seconds")
        }
        
        if components.count > 1 {
            let lastComponent = components.removeLast()
            return components.joined(separator: ", ") + ", and " + lastComponent
        } else if let firstComponent = components.first {
            return firstComponent
        } else {
            return "0 seconds"
        }
    }
}

// AppDelegate.swift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        print("Notification received with identifier \(notification.request.identifier)")
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
        completionHandler([.banner, .sound])
    }
}
