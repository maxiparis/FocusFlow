//
//  ContentView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var displayAddSheet = false
    @State private var displayTimerView = false
    @State private var selectedTask: Task? = nil
    
    @StateObject private var contentVM = ContentViewModel()
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header: Text("Focus Session"),
                    footer: Text("Estimated finishing time: \(contentVM.estimatedFinishingTime)") //TODO: add something like "in 3 hours and 45 minutes"
                ) {
                    List($contentVM.tasks, id: \.self, editActions: .all) { task in
                        NavigationLink {
                            AddView(selectedTask: task.wrappedValue, isPresented: $displayAddSheet, contentVM: contentVM, editing: true)
                        } label: {
                            let time = task.wrappedValue.timer
                            let timeString = "\(time.hours)h \(time.minute)m"
                            HStack {
                                Text("\(task.wrappedValue.title)")
                                Spacer()
                                Text("\(timeString)")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $displayAddSheet, content: {
                AddView(selectedTask: selectedTask, isPresented: $displayAddSheet, contentVM: contentVM, editing: false)
            })
            .toolbar {
                //Edit
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                //Add
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Add tapped")
                        selectedTask = nil
                        displayAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                //Start Routine
                ToolbarItem(placement: .bottomBar){
                    Button {
                        displayTimerView.toggle()
                        print("Start tapped")
                    } label: {
                        Text("Start Focus Session")
                            .font(.callout)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .tint(Color.green)
                    .disabled(contentVM.tasks.isEmpty)
                }
            }
            .navigationTitle("FocusFlow")
            .navigationDestination(isPresented: $displayTimerView) {
                TimerView(timerVM: TimerViewModel(tasks: contentVM.tasks))
            }
        }        
    }
}

#Preview {
    ContentView()
}
