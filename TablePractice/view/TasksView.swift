//
//  ContentView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/21/24.
//

import SwiftUI
import EventKit

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
                    
                } header: {
                    Text("Focus Session")
                } footer: {
                    if (tasksVM.tasks.isEmpty) {
                        Text("We will predict your finishing time when you add your first task.")
                    } else {
                        Text("If you stick to the plan you'd be done at \(tasksVM.estimatedFinishingTime), in \(tasksVM.estimatedFinishingTimeRelative) ")
                    }
                }
                
                Section {
                    // Test tasks
                    Button {
                        withAnimation(.smooth) {
                            tasksVM.importDefaultTasks()
                        }
                    } label: {
                        Label("Import test tasks", systemImage: "square.and.arrow.down")
                    }
                    
                    Button {
                        withAnimation(.smooth) {
                            tasksVM.importOverdueTasks()
                        }
                    } label: {
                        Label("Import overdue tasks", systemImage: "square.and.arrow.down")
                    }
                    
                    
                    //Import tasks from calendar
                    Button {
                        withAnimation(.smooth(duration: 0.3)) {
                            tasksVM.fetchEvents()
                        }
                    } label: {
                        Label("Import tasks from calendar", systemImage: "calendar")
                    }
                    
                    //Delete all tasks
                    if !tasksVM.tasks.isEmpty {
                        Button {
                            withAnimation(.smooth) {
                                tasksVM.clearAllTasks()
                            }
                        } label: {
                            Label("Clear all tasks", systemImage: "trash")
                                .foregroundStyle(.red)
                        }
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
                    .padding(.bottom, 20)
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
