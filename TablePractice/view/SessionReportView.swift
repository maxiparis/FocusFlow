//
//  SessionReportView.swift
//  TablePractice
//
//  Created by Maximiliano París Gaete on 10/18/24.
//

import SwiftUI

struct SessionReportView: View {
    @ObservedObject var timerVM: TimerViewModel
    
    var body: some View {
        VStack(spacing: 100) {
            Spacer()
            switch(timerVM.sessionTimerState) {
            case .exceeded:
                exceededTimeView
            case .saved:
//                exceededTimeView //for testing
                savedTimeView
            }
            Spacer()
        }
        .padding()
        .onDisappear {
            timerVM.isPresented = false
        }
    }
    
    var savedTimeView: some View {
        Group {
            VStack(spacing: 10) {
                    Text("Congratulations! 🎉")
                        .font(.largeTitle)
                    Text("You Saved")
                        .font(.title2)
                        .foregroundStyle(HierarchicalShapeStyle.secondary)
            }
            
            Text(timerVM.sessionTimerStateWorded)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Text("by staying focused in your Focus Session")
                .foregroundStyle(HierarchicalShapeStyle.secondary)
                .font(.title2)
                .multilineTextAlignment(.center)
            
        }
    }
    
    var exceededTimeView: some View {
        Group {
            VStack(spacing: 30) {
                Text("Congratulations! 🎉")
                    .font(.largeTitle)

                Text("You finished your Focus Session")
                    .font(.title2)
                    .foregroundStyle(HierarchicalShapeStyle.secondary)
                
            }
            
            VStack (spacing: 30) {
                Text("You exceeded your planned time by")
                    .foregroundStyle(HierarchicalShapeStyle.secondary)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                Text("\(timerVM.sessionTimerStateWorded).")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}


//#Preview {
//    SessionReportView()
//}
