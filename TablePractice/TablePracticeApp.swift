//
//  TablePracticeApp.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/21/24.
//

import SwiftUI

@main
struct TablePracticeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TasksView()       
        }
    }
}
