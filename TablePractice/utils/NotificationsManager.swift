//
//  NotificationsManager.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 11/6/24.
//

import Foundation
import UserNotifications


//MARK: - NotificationsManager

class NotificationsManager {
    
    static let timePerNotification: [NotificationsIdentifiers : TimeInterval] = [
        .preExpiration1: -1.minutesToSeconds,
        .preExpiration5: -5.minutesToSeconds,
        .onExpiration: 0,
        .postExpiration1: 1.minutesToSeconds,
        .postExpiration2: 2.minutesToSeconds,
        .postExpiration5: 5.minutesToSeconds,
        .postExpiration10: 10.minutesToSeconds
    ]
    
    static let titlePerNotification: [NotificationsIdentifiers : String] = [
        .preExpiration1: "Task Reminder",
        .preExpiration5: "Task Reminder",
        .onExpiration: "Task Expiration",
        .postExpiration1: "Task Has Expired",
        .postExpiration2: "Task Has Expired",
        .postExpiration5: "Task Has Expired",
        .postExpiration10: "Task Has Expired"
    ]
    
    
    static func scheduleExpirationNotifications(task: Task) {
        let center = UNUserNotificationCenter.current()
        NotificationsIdentifiers.allCases.forEach { notification in
            if let request = createNotification(for: task, type: notification) {
                center.add(request)
                print("Notification added for \(notification)")
            }
        }
        
        print("Expiration notifications set")
    }
    
    ///Creates a `UNNotificationRequest` object if the specified type applies to that specific task. Else, we return nil.
    ///Example:
    ///If the `task` has expired, we wont set a timer for 5 minutes before `NotificationsIdentifier.preExpiration5`, so we return nil
    ///If the `task` has 3 minutes left, and the type is `NotificationsIdentifier.onExpiration` then we create a nofication object, calculate its time, and return it.
    static func createNotification(for task: Task, type: NotificationsIdentifiers) -> UNNotificationRequest? {
        
        guard !task.timer.isOverdue else { return nil }
        
        let secondsToNotification = task.timer.remainingTimeInSecs + timePerNotification[type]!
        
        guard secondsToNotification > 0 else { return nil }
        
        let content = UNMutableNotificationContent()
        content.title = titlePerNotification[type]!
        
        var body = ""
        let minutesFormatted = abs(timePerNotification[type]!.secondsToMinutes)
        let minutesDescription = "\(minutesFormatted) minute\(minutesFormatted > 1 ? "s" : "")" /// Example: "5 minutes" or "1 minute"
        
        switch type {
        case .preExpiration1, .preExpiration5:
            body = "Your task \"\(task.title)\" will be due in \(minutesDescription)."
        case .onExpiration:
            body = "Your task \"\(task.title)\" has expired."
        default: //post-expiration
            body = "Your task \"\(task.title)\" expired \(minutesDescription) ago."
        }
        
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("mainBell.wav"))
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secondsToNotification), repeats: false)
        
        return UNNotificationRequest(identifier: "\(type)-\(task.id)", content: content, trigger: trigger)
    }
    
    static func cancelNotifications(for task: Task) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("removed notifications")
    }
    
    
    
//    private static func getExpirationIds(for task: Task) -> [String] {
//        var ids: [String] = []
//        for type in NotificationsIdentifiers.allCases {
//            switch type {
//            default:
//                ids.append("\(type)-\(task.id)")
//            }
//        }
//        return ids
//    }
}

//MARK: - NotificationsIdentifiers

enum NotificationsIdentifiers: String, CaseIterable {
    //Minutes before expiration
    case preExpiration5 = "preExpiration5"
    case preExpiration1 = "preExpiration1"
    
    //When it expires
    case onExpiration = "expiration"
    
    //Minutes after expiration
    case postExpiration1 = "postExpiration1"
    case postExpiration2 = "postExpiration2"
    case postExpiration5 = "postExpiration5"
    case postExpiration10 = "postExpiration10"
}
