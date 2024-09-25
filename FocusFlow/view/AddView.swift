//
//  AddView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss

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
                        .font(.title3)
                        .frame(height: 20)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    HStack {
                        //Hours
                        VStack {
                            Text("Hours").font(.headline)
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
                            Text("Minutes").font(.headline)
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
                    Button {
                        if let task = selectedTask,
                           let index = contentVM.tasks.firstIndex(of: task) {
                            contentVM.tasks[index] = Task(title: activityName, timer: Time(hours: selectedHour, minute: selectedMinute))
                        } else {
                            contentVM.tasks.append(Task(title: activityName, timer: Time(hours: selectedHour, minute: selectedMinute)))
                        }
                        self.isPresented = false
                        dismiss()
                        // TODO: dismiss view here??
                        
                    } label: {
                        Text("Save").font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
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
