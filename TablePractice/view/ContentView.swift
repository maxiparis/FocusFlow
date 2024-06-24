//
//  ContentView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false
    @ObservedObject private var contentVM = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List($contentVM.elements, id: \.self, editActions: .all) { element in
                Text(element.wrappedValue)
            }
            .listStyle(.automatic)
            .navigationTitle("List of activities")
            .toolbar {
                EditButton()
                Button {
                    print("Add tapped")
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            .sheet(isPresented: $showingSheet, content: {
                AddView(isPresented: $showingSheet, contentVM: contentVM)
            })
        }
    }
}

#Preview {
    ContentView()
}
