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
        VStack(spacing: 80) {
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
                Button {
                    //TODO
                } label: {
                    ButtonImageView(systemImage: "plus.circle")
                }
                
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
                
                Button {
                    timerVM.completeTask()
                } label: {
                    ButtonImageView(systemImage: "checkmark.circle")
                }
            }
            
            Text(timerVM.nextActivityText)
            Text("Time you will be done: \(timerVM.estimatedFinishingTime)")
            
            Spacer()
        }.onAppear() {
            timerVM.startTimer()
            timerVM.generateNextActivityText()
        }
        .onDisappear() {
            timerVM.pauseTimer()
            //            timerVM.restartCurrentTaskIndex()
            parentVM.markTasksAsNotCompleted()
        }
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
