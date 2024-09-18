//
//  TimerView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerVM: TimerViewModel
    
    var body: some View {
        VStack(spacing: 120) {
            if let currentTaskIndex = timerVM.currentTaskIndex {
                Spacer()
                
                Text(timerVM.tasks[currentTaskIndex].title).font(.largeTitle)
                
                Text(timerVM.countdownString)
                    .font(.largeTitle)
                
                HStack(spacing: 20) {
                    Button {
                        //TODO
                    } label: {
                        Text("Add time")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }.buttonStyle(BorderedButtonStyle())

                    Button {
                        if (timerVM.timerPaused) {
                            timerVM.startTimer()
                        } else {
                            timerVM.pauseTimer()
                        }
                        print("button tapped")
                    } label: {
                        if (timerVM.timerPaused) {
                            Text("Continue")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        } else {
                            Text("Pause")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                    
                    Button {
                        //TODO
                    } label: {
                        Text("Done")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }.buttonStyle(BorderedButtonStyle())
                }
                
                Text("Next Actity: ")
                Text("Time you will be done: ")
                
                Spacer()
            }
        }.onAppear() {
            timerVM.startTimer()
        }
    }
}


#Preview {
    var task: Task = Task(title: "test", timer: Time(hours: 0, minute: 1))
    var taskList = [task]
    
    TimerView(timerVM: TimerViewModel(tasks: taskList))
}
