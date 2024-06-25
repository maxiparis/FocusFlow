//
//  TimerView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/25/24.
//

import SwiftUI

struct TimerView: View {
    var timerVM: TimerViewModel
    
    
    var body: some View {
        VStack(spacing: 120) {
            if let currentTask = timerVM.currentTask {
                Spacer()
                
                Text(currentTask.title).font(.largeTitle)
                
                Text("00:00").font(.largeTitle)
                
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
        }
    }
}

//
//#Preview {
//    TimerView()
//}
