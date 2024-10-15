//
//  ContentView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/21/24.
//

import SwiftUI

struct TasksView: View {
    @State private var displayAddSheet = false
    @State private var displayTimerView = false
    @State private var selectedTask: Task? = nil
    
    @StateObject private var contentVM = TasksViewModel()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if (contentVM.tasks.isEmpty) {
                        Button {
                            triggerAddView()
                        } label: {
                            Label("Add a task", systemImage: "plus")
                        }
                        
                    } else {
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
                } header: {
                    Text("Focus Session")
                } footer: {
                    if (contentVM.tasks.isEmpty) {
                        Text("We will predict your finishing time when you add your first task.")
                    } else {
                        Text("If you stick to the plan you'd be done at \(contentVM.estimatedFinishingTime), in \(contentVM.estimatedFinishingTimeRelative) ")
                    }
                }
            }
            .sheet(isPresented: $displayAddSheet, content: {
                AddView(selectedTask: selectedTask, isPresented: $displayAddSheet, contentVM: contentVM, editing: false)
            })
            .toolbar {
                //Edit
                ToolbarItem(placement: .topBarLeading) {
                    EditButton().disabled(contentVM.tasks.isEmpty)
                }
                
                //Add
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Add tapped")
                        triggerAddView()
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
                    .disabled(contentVM.tasks.isEmpty)
                }
            }
            .navigationTitle("FocusFlow")
            .navigationDestination(isPresented: $displayTimerView) {
                TimerView(timerVM: TimerViewModel(model: contentVM.model))
            }
        }
    }
    
    func triggerAddView() {
        selectedTask = nil
        displayAddSheet = true
    }
}

#Preview {
    TasksView()
}
