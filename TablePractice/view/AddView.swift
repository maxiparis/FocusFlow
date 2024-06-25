//
//  AddView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import SwiftUI

struct AddView: View {
    
    private var selectedTask: Task?
    
    @State private var activityName: String
    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    
    @Binding var isPresented: Bool
    @ObservedObject var contentVM: ContentViewModel
    
    init(selectedTask: Task?, isPresented: Binding<Bool>, contentVM: ContentViewModel) {
        self.selectedTask = selectedTask
        self._isPresented = isPresented
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
                    HStack {
                        Button("Cancel") {
                            self.isPresented = false
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    Spacer()
                    
                    TextField("Enter name of activity", text: $activityName)
                        .frame(height: 20)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                    
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
                                   .pickerStyle(.wheel)
                                   .frame(width: g.size.width / 3, height: g.size.height / 4)
                        }
                    }
                    
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
                    Spacer()
                }
                .frame(width: g.size.width * 0.9)
                
                Spacer()
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
