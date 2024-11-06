//
//  NotificationsManager.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 11/6/24.
//

import Foundation
import UserNotifications


class NotificationsManager {
    
    static func scheduleExpirationNotifications(task: Task) {
        let center = UNUserNotificationCenter.current()
        if !task.timer.isOverdue {
            
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
            let expirationRequest = UNNotificationRequest(identifier: "\(NotificationsIdentifiers.onExpiration)-\(task.id)", content: expirationContent, trigger: expirationTrigger)
            
            center.add(expirationRequest)
            print("expiration notifications set")
        }
    }
    
    static func cancelNotifications(for task: Task) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: getExpirationIds(for: task))
        print("removed notifications")
    }
    
    static func schedulePreExpirationNotification() {
        
    }
    
    private static func getExpirationIds(for task: Task) -> [String] {
        var ids: [String] = []
        for type in NotificationsIdentifiers.allCases {
            switch type {
            default:
                ids.append("\(type)-\(task.id)")
            }
        }
        return ids
    }
}

enum NotificationsIdentifiers: String, CaseIterable {
    //Minutes before expiration
    case preExpiration5 = "preExpiration5"
    case preExpiration1 = "preExpiration1"
    
    //Whe n it expires
    case onExpiration = "expiration"
    
    //Minutes after expiration
    case expiration1 = "expiration1"
    case expiration2 = "expiration2"
    case expiration5 = "expiration5"
    case expiration10 = "expiration10"
}
