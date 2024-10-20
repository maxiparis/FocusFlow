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
    
    @StateObject private var tasksVM = TasksViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if (tasksVM.tasks.isEmpty) {
                        Button {
                            triggerAddView()
                        } label: {
                            Label("Add a task", systemImage: "plus")
                        }
                    } else {
                        List($tasksVM.tasks, editActions: .all) { task in
                            NavigationLink {
                                AddView(selectedTask: task.wrappedValue, isPresented: $displayAddSheet, contentVM: tasksVM, editing: true)
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
                    
                    Button {
                        //TODO: import a bunch of tasks for testing purposes
                        tasksVM.importDefaultTasks()
                        
                    } label: {
                        Label("Import test tasks", systemImage: "plus")
                    }
                    
                } header: {
                    Text("Focus Session")
                } footer: {
                    if (tasksVM.tasks.isEmpty) {
                        Text("We will predict your finishing time when you add your first task.")
                    } else {
                        Text("If you stick to the plan you'd be done at \(tasksVM.estimatedFinishingTime), in \(tasksVM.estimatedFinishingTimeRelative) ")
                    }
                }
            }
            .sheet(isPresented: $displayAddSheet, content: {
                AddView(selectedTask: selectedTask, isPresented: $displayAddSheet, contentVM: tasksVM, editing: false)
            })
            .toolbar {
                //Edit
                ToolbarItem(placement: .topBarLeading) {
                    EditButton().disabled(tasksVM.tasks.isEmpty)
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
                    .disabled(tasksVM.tasks.isEmpty)
                }
            }
            .navigationTitle("FocusFlow")
            .navigationDestination(isPresented: $displayTimerView) {
                TimerView(
                    timerVM: TimerViewModel(isPresented: $displayTimerView),
                    parentVM: tasksVM
                )
            }
        }
        .onAppear {
            tasksVM.markTasksAsNotCompleted()
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
