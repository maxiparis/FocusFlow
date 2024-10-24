//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications
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
        if currentTask.timer.isOverdue {
            if let timerState = currentTask.timer.timerState {
                switch timerState {
                case .exceeded(let seconds):
                    return formatTime(from: seconds)
                default:
                    return formatTime(from: currentTask.timer.remainingTimeInSecs)
                }
            } else {
                return formatTime(from: currentTask.timer.remainingTimeInSecs)
            }
        } else {
            return formatTime(from: currentTask.timer.remainingTimeInSecs)
        }
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
    
    // MARK: - User Intents
    
    func startTimer() {
        self.timerPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !self.currentTask.timer.isOverdue {
                self.currentTask.timer.remainingTimeInSecs -= 1
                self.currentTask.timer.timerState = .saved(self.currentTask.timer.remainingTimeInSecs)
            } else {
                if let timerState = self.currentTask.timer.timerState {
                    switch timerState {
                    case .exceeded(let seconds):
                        self.currentTask.timer.timerState = .exceeded(seconds + 1)
                    case .saved:
                        self.currentTask.timer.timerState = .exceeded(1)
                    }
                }
            }
        }
        
        // Schedule notifications when the timer starts
        scheduleExpirationNotifications(task: currentTask)
    }
    
    func pauseTimer() {
        timer.invalidate()
        timerPaused = true
        cancelNotifications(for: currentTask)
    }
    
    func completeTask() {
        self.pauseTimer()
        
        let currentTaskIsLastOne = self.tasks[currentTaskIndex] == self.tasks.last
        
        tasksData.completeTask(in: currentTaskIndex)
        self.tasks = tasksData.tasks
        
        if currentTaskIsLastOne {
            displayReportView = true
            return
        }
        
        self.startTimer()
        cancelNotifications(for: currentTask)
    }
    
    func addTime(_ minutes: AddMinutes) {
        tasksData.addMinutesToTask(minutes: minutes, at: currentTaskIndex)
        cancelNotifications(for: currentTask)
        scheduleExpirationNotifications(task: currentTask)
    }
    
    // MARK: - Notification Management
    
    func scheduleExpirationNotifications(task: Task) {
        let center = UNUserNotificationCenter.current()
        
//        // Pre-expiration notification
//        guard task.timer.isOverdue else { return }
//        
//        if task.timer.remainingTimeInSecs > 300 {
//            let preExpirationContent = UNMutableNotificationContent()
//            preExpirationContent.title = "Task Expiring Soon"
//            preExpirationContent.body = "Your task \"\(task.title)\" is expiring in 5 minutes."
//            preExpirationContent.sound = .default
//            
//            let preExpirationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: task.timer, repeats: false)
//            let preExpirationRequest = UNNotificationRequest(identifier: "preExpiration-\(task.id)", content: preExpirationContent, trigger: preExpirationTrigger)
//            center.add(preExpirationRequest)
//        }
        
        // Expiration notification
        let expirationContent = UNMutableNotificationContent()
        expirationContent.title = "Task Expired"
        expirationContent.body = "Your task \"\(task.title)\" has expired."
        expirationContent.sound = .default
        
        let expirationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: task.timer.remainingTimeInSecs, repeats: false)
        let expirationRequest = UNNotificationRequest(identifier: "expiration-\(task.id)", content: expirationContent, trigger: expirationTrigger)
        center.add(expirationRequest)
        print("expiration notifications set")
    }
    
    func cancelNotifications(for task: Task) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["preExpiration-\(task.id)", "expiration-\(task.id)"])
        print("removed notifications")
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
