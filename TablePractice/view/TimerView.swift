//
//  TimerView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    
    @StateObject var timerVM: TimerViewModel
    var parentVM: TasksViewModel
    @Environment(\.scenePhase) var scenePhase

    
    var body: some View {
        VStack(spacing: 60) {
            Spacer()
            
            Text(timerVM.currentTask.title).font(.largeTitle)
            
            VStack {
                Text(timerVM.countdownString ?? "Error")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(timerVM.currentTaskIsOverdue ? .red : .primary)
                if (timerVM.currentTaskIsOverdue) {
                    Text("Overdue").foregroundStyle(.red)
                }
            }
            
            HStack(spacing: 20) {
                
                // Add time
                Menu {
                    Section {
                        Text("Add time")
                            .font(.title2)
                    }
                    
                    Section() {
                        Button("+ 1 minute") {
                            timerVM.addTime(.oneMinute)
                        }
                        Button("+ 5 minutes") {
                            timerVM.addTime(.fiveMinutes)
                        }
                        Button("+ 10 minutes") {
                            timerVM.addTime(.tenMinutes)
                        }
                    }
                } label: {
                    ButtonImageViewSecondary(systemImage: "plus.circle")
                }
                
                // Complete
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        timerVM.completeTask()
                        timerVM.cancelNotifications(for: timerVM.currentTask) // Cancel notifications when the task is completed
                    }
                } label: {
                    ButtonImageView(systemImage: "checkmark.circle")
                }
                
                // Pause/Resume
                Button {
                    if (timerVM.timerPaused) {
                        timerVM.startTimer()
                        timerVM.scheduleExpirationNotifications(task: timerVM.currentTask) // Schedule notifications when the timer starts
                    } else {
                        timerVM.pauseTimer()
                    }
                } label: {
                    if (timerVM.timerPaused) {
                        ButtonImageViewSecondary(systemImage: "play.circle")
                    } else {
                        ButtonImageViewSecondary(systemImage: "pause.circle")
                    }
                }
            }
            
            VStack {
                if let nextActivityText = timerVM.nextActivityText {
                    Text("Next Activity:")
                    Text(nextActivityText)
                        .font(.title3)
                } else {
                    Text("This is your last activity")
                        .font(.title3)
                }
            }
            
            VStack {
                Text("Time you will be done:")
                Text(timerVM.estimatedFinishingTime)
                    .font(.title2)
            }
            
            VStack {
                switch(timerVM.sessionTimerState) {
                case .exceeded:
                    Text("Time Exceeded:")
                case .saved:
                    Text("Time Saved:")
                }
                Text(timerVM.sessionTimerStateText)
            }
            
            Spacer()
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                print(newValue)
                timerVM.recalculateTimer()
            } else if newValue == .inactive {
                print(newValue)
            } else { //background
                print(newValue)
                timerVM.saveBackgroundDate()
            }
        })
        .onAppear() {
            requestNotificationPermission() // Request notification permission on view load
            timerVM.startTimer()
        }
        .onDisappear() {
            timerVM.pauseTimer()
            parentVM.markTasksAsNotCompleted()
            timerVM.cancelNotifications(for: timerVM.currentTask)
        }
        .sheet(isPresented: $timerVM.displayReportView, content: {
            SessionReportView(timerVM: timerVM)
        })
    }
    
    // Request notification permission function
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
}


// Supporting button views

struct ButtonImageView: View {
    var systemImage: String
    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 85))
            .foregroundColor(.blue)
            .fontWeight(.thin)
    }
}

struct ButtonImageViewSecondary: View {
    var systemImage: String
    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 70))
            .foregroundColor(.blue.opacity(0.8))
            .fontWeight(.thin)
    }
}

