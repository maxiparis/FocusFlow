//
//  TimerViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import Foundation
import Observation
import Combine

private let SECONDS_IN_MINUTE = 60
private let SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60


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
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if var index = self.currentTaskIndex {
                if self.tasks[index].timer.remainingTimeInSecs > 0 {
                    self.tasks[index].timer.remainingTimeInSecs -= 1
                    self.generateCountdownString()
                } else {
                    index += 1
                    self.currentTaskIndex = index
                    self.tasks[index].timer.remainingTimeInSecs -= 1
                    self.generateCountdownString()

                }
            }
        }
        
    }
    
    func generateCountdownString() {
        if let index = self.currentTaskIndex {
            var remainingSecondsForString = tasks[index].timer.remainingTimeInSecs
            
            let hours: Int = remainingSecondsForString / SECONDS_IN_HOUR
            remainingSecondsForString -= hours * SECONDS_IN_HOUR
            let minutes: Int = remainingSecondsForString / SECONDS_IN_MINUTE
            remainingSecondsForString -= minutes * SECONDS_IN_MINUTE
            
            let hoursText: String? = {
                if hours >= 10 {
                    return hours.description
                } else if hours >= 1 {
                    return "0\(hours.description)"
                } else {
                    return nil
                }
            }()
            let minutesText: String = {
                if minutes >= 10 {
                    return minutes.description
                } else {
                    return "0\(minutes.description)"
                }
            }()
            let secondsText: String = {
                if remainingSecondsForString >= 10 {
                    return remainingSecondsForString.description
                } else {
                    return "0\(remainingSecondsForString.description)"
                }
            }()
            
            
            if let hoursText = hoursText {
                let countdownStringWithHours = hoursText + ":" + minutesText + ":" + secondsText
                countdownString = countdownStringWithHours
            } else {
                let countdownStringWithoutHours = minutesText + ":" + secondsText
                countdownString = countdownStringWithoutHours
            }
        }
    }
    
}
