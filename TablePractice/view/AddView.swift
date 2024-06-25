//
//  AddView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import SwiftUI

struct AddView: View {
    
    private var selectedTask: Task?
    @State private var editButtonPressed: Bool = false
    @State private var editable: Bool
    @State private var shouldDisplayEditButton: Bool
    
    @State private var activityName: String
    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    
    @Binding var isPresented: Bool
    @ObservedObject var contentVM: ContentViewModel
    
    init(selectedTask: Task?, isPresented: Binding<Bool>, editable: Bool, contentVM: ContentViewModel) {
        self.selectedTask = selectedTask
        self._isPresented = isPresented
        self._editable = State(initialValue: editable)
        self._shouldDisplayEditButton = State(initialValue: !editable)
        self.contentVM = contentVM
        
        if let task = selectedTask {
            activityName = task.title
            selectedHour = task.timer.hours
            selectedMinute = task.timer.minute
        } else {
            activityName = ""
            selectedHour = 0
            selectedMinute = 0
        }
    }
    
    var body: some View {
        GeometryReader() { g in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    
                    TextField("Enter name of activity", text: $activityName)
                        .frame(height: 20)
                        .textFieldStyle(.roundedBorder)
                        .disabled(!editable)
                    
                    Spacer()
                    
                    HStack {
                        //Hours
                        VStack {
                            Text("Hours")
                            Picker("Flavor",
                                   selection: $selectedHour) {
                                ForEach(contentVM.hours.indices) {
                                    Text(contentVM.hours[$0].description)
                                        .tag($0)
                                }
                            }
                                   .disabled(!editable)
                                   .pickerStyle(.wheel)
                                   .frame(width: g.size.width / 3, height: g.size.height / 4)
                        }
                        
                        //Minutes
                        VStack {
                             Text("Minutes")
                            Picker("Flavor",
                                   selection: $selectedMinute) {
                                ForEach(contentVM.minutes.indices) {
                                    Text(contentVM.minutes[$0].description)
                                        .tag($0)
                                }
                            }
                                   .disabled(!editable)
                                   .pickerStyle(.wheel)
                                   .frame(width: g.size.width / 3, height: g.size.height / 4)
                        }
                    }
                    
                    if (editable) {
                        Spacer()
                        Button("Submit") {
                            if let task = selectedTask,
                               let index = contentVM.elements.firstIndex(of: task) {
                                contentVM.elements[index] = Task(title: activityName, timer: Time(hours: selectedHour, minute: selectedMinute))
                            } else {
                                contentVM.elements.append(Task(title: activityName, timer: Time(hours: selectedHour, minute: selectedMinute)))
                            }
                            self.isPresented = false
                        }
                        .disabled(activityName == "" || (selectedHour == 0 && selectedMinute == 0))
                        .buttonStyle(.bordered)
                    }
                    Spacer()
                }
                .frame(width: g.size.width * 0.9)
                
                Spacer()
            }
        }
        .toolbar {
            if (shouldDisplayEditButton) {
                Button {
                    editButtonPressed.toggle()
                    editable.toggle()
                } label: {
                    editButtonPressed ? Text("Cancel") : Text("Edit")
                }
            }
        }
    }
}

//#Preview {
//    AddView(isPresented: .constant(true), contentVM: ContentViewModel())
//}


extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)
    }
}
