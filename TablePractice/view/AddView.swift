//
//  AddView.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import SwiftUI

struct AddView: View {
    @State private var activityName: String = ""
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @Binding var isPresented: Bool
    @StateObject var contentVM: ContentViewModel
    
    var body: some View {
        GeometryReader() { g in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    
                    TextField("Enter name of activity", text: $activityName)
                        .frame(height: 20)
                        .textFieldStyle(.roundedBorder)
                    
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
                        if (activityName != "") {
                            contentVM.elements.append(activityName)
                            self.isPresented = false //Dismiss self view
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                }
                .frame(width: g.size.width * 0.9)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AddView(isPresented: .constant(true), contentVM: ContentViewModel())
}


extension UIPickerView {   open override var intrinsicContentSize: CGSize {     return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)   } }
