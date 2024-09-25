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
//            List {
//                ForEach(contentVM.tasks.indices, id: \.self) { index in
//                    let task = contentVM.tasks[index]
//                    
//                    Button(action: {
//                        testFunc(index: index)
//                    }) {
//                        Text("\(task.title)")
//                            .foregroundColor(Color.primary) // Adjust text color for dark mode
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
            List($contentVM.tasks, id: \.self, editActions: .all) { task in
//                Button(action: {
//                    selectedTask = task.wrappedValue
//                    displayAddSheet = true
//                }) {
//                    Text("\(task.title.wrappedValue) - \(task.wrappedValue.generateTimerText())")
//                }
//                .tint(Color.primary) //TODO: fix color to match dark mode as well
                NavigationLink {
                    AddView(selectedTask: task.wrappedValue, isPresented: $displayAddSheet, contentVM: contentVM)
                } label: {
                    Text("\(task.wrappedValue.title)")
                }

            }
            .sheet(isPresented: $displayAddSheet, content: {
                AddView(selectedTask: selectedTask, isPresented: $displayAddSheet, contentVM: contentVM)
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
                        Text("Start Routine")
                            .font(.callout)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .tint(Color.green)
                    .disabled(contentVM.tasks.isEmpty)
                }
            }
            .navigationTitle("Routine")
            .navigationDestination(isPresented: $displayTimerView) {
                TimerView(timerVM: TimerViewModel(tasks: contentVM.tasks))
            }
        }
        
    }
}

//#Preview {
//    ContentView()
//}
