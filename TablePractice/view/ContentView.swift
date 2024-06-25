//
//  ContentView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false
    @State private var selectedTask: Task? = nil
    
    @StateObject private var contentVM = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            List($contentVM.elements, id: \.self, editActions: .all) { element in
                Button(action: {
                    selectedTask = element.wrappedValue
                    showingSheet = true
                }) {
                    Text("\(element.title.wrappedValue) - \(element.wrappedValue.generateTimerText())")
                }
                .tint(Color.black) //TODO: fix color to match dark mode as well
            }
            //                .listStyle(.plain)
            .sheet(isPresented: $showingSheet, content: {
                AddView(selectedTask: selectedTask, isPresented: $showingSheet, contentVM: contentVM)
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
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                //Start Routine
                ToolbarItem(placement: .bottomBar){
                    Button{
                        print("Start tapped")
                    } label: {
                        Text("Start Routine")
                    }
                    .padding(15)
                    .background() {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.green)
                    }
                    .foregroundStyle(Color.white)
                }
            }
            .navigationTitle("Routine")
        }
        
    }
}

#Preview {
    ContentView()
}
