//
//  TimerView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerVM: TimerViewModel
    var parentVM: TasksViewModel
    
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
                
                //Add time
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
                    ButtonImageView(systemImage: "plus.circle")
                }
                
                //Pause/Resume
                Button {
                    if (timerVM.timerPaused) {
                        timerVM.startTimer()
                    } else {
                        timerVM.pauseTimer()
                    }
                    print("button tapped")
                } label: {
                    if (timerVM.timerPaused) {
                        ButtonImageView(systemImage: "play.circle")
                    } else {
                        ButtonImageView(systemImage: "pause.circle")
                    }
                }
                
                //Complete
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        timerVM.completeTask()
                    }
                } label: {
                    ButtonImageView(systemImage: "checkmark.circle")
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
                case.exceeded:
                    Text("Time Exceeded:")
                case .saved:
                    Text("Time Saved:")
                }
                Text(timerVM.sessionTimerStateText)
            }
            
            Spacer()
        }.onAppear() {
            timerVM.startTimer()
        }
        .onDisappear() {
            timerVM.pauseTimer()
            //            timerVM.restartCurrentTaskIndex()
            parentVM.markTasksAsNotCompleted()
        }
        .sheet(isPresented: $timerVM.displayReportView, content: {
            SessionReportView(timerVM: timerVM)
        })
    }
}


//#Preview {
//    let task: Task = Task(title: "test", timer: TimeTracked(hours: 0, minute: 1))
//    let taskList = [task]
//
//    TimerView(timerVM: TimerViewModel(isPresented: .constant(true)), parentVM: TasksViewModel())
//}


struct ButtonImageView: View {
    var systemImage: String
    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 75))
            .foregroundColor(.blue)
            .fontWeight(.thin)
    }
}
