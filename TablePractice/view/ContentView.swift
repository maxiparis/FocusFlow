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
                .tint(Color.black)
            }
            .listStyle(.automatic)
            .navigationTitle("Routine")
            .toolbar {
                EditButton()
                Button {
                    print("Add tapped")
                    selectedTask = nil
                    showingSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            .sheet(isPresented: $showingSheet, content: {
                AddView(selectedTask: selectedTask, isPresented: $showingSheet, editable: true, contentVM: contentVM)
            })
            
            
            Button("Start routine") {
                print("Start tapped")
            }
            .padding(15)
            .background() {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.green)
            }
            .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    ContentView()
}
