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
                
                HStack {
                    Spacer()
                    Button {
                        print("button tapped")
                    } label: {
                        Text("Button")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    Spacer()
                }
                
                Spacer()
            }
        }.onAppear() {
            timerVM.startTimer()
        }
    }
}

//
//#Preview {
//    TimerView()
//}
