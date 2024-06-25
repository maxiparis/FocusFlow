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
            List($contentVM.elements, id: \.self, editActions: .all) { element in
                Button(action: {
                    selectedTask = element.wrappedValue
                    displayAddSheet = true
                }) {
                    Text("\(element.title.wrappedValue) - \(element.wrappedValue.generateTimerText())")
                }
                .tint(Color.black) //TODO: fix color to match dark mode as well
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
                    .disabled(contentVM.elements.isEmpty)
                }
            }
            .navigationTitle("Routine")
            .navigationDestination(isPresented: $displayTimerView) {
                TimerView(timerVM: TimerViewModel(tasks: contentVM.elements))
            }
        }
        
    }
}

#Preview {
    ContentView()
}
