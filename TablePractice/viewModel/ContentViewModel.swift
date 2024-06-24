//
//  ContentViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation
import Observation

class ContentViewModel: ObservableObject {
    @Published var elements: [String] {
        didSet {
            print(elements)
        }
    }
    
    @Published var hours: [Int]
    @Published var minutes: [Int]
    
    init() {
        self.elements = ["Eat","Run","Do Homework","Make dinner"]
        self.hours = [0,1,2,3,4,5,6,7,8,9,10,11,12]
        self.minutes = []
        
        for number in 0...59 {
            self.minutes.append(number)
        }
    }
}
