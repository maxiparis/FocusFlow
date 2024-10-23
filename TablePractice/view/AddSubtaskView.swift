//
//  AddSubtaskView.swift
//  TablePractice
//
//  Created by Spencer Navas on 10/19/24.
//

import SwiftUI

struct AddSubtaskView: View {
    @State private var subtaskName: String = ""
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    
    let hours = Array(0...23) // Hours from 0 to 23
    let minutes = Array(0...59) // Minutes from 0 to 59

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Subtask Details")) {
                        TextField("Subtask Name", text: $subtaskName)

                        HStack {
                            Text("Estimated Time to Complete")
                            Spacer()
                            Picker("Hours", selection: $selectedHour) {
                                ForEach(hours, id: \.self) { hour in
                                    Text("\(hour) hr")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80)
                            Picker("Minutes", selection: $selectedMinute) {
                                ForEach(minutes, id: \.self) { minute in
                                    Text("\(minute) min")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80)
                        }
                    }
                }

                Spacer()

                // Centered button
                Button(action: {
                    // Action to save the subtask with the name and time
                    print("Subtask: \(subtaskName), Time: \(selectedHour) hours and \(selectedMinute) minutes")
                }) {
                    Text("Add Subtask")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40) // Padding for centering
                }
                .disabled(subtaskName.isEmpty) // Disable if subtask name is empty
                
                Spacer()
            }
            .navigationBarTitle("Add Subtask", displayMode: .inline)
        }
    }
}

#Preview {
    AddSubtaskView()
}
