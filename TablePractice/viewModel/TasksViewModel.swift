//
//  ContentViewModel.swift
//  TablePractice
//
//  Created by Maximiliano Paris Gaete on 6/24/24.
//

import Foundation
import Observation
import EventKit

class TasksViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var model = TasksData()
    @Published var events: [EKEvent]? {
        didSet {
            if events != nil {
                parseEvents()
            }
        }
    }
    let eventStore = EKEventStore()
    
    
    //MARK: - Model access
    
    var tasks: [Task] {
        get { model.tasks }
        set { model.tasks = newValue }
    }
    
    var estimatedFinishingTime: String {
        model.estimatedFinishingTime
    }
    
    var estimatedFinishingTimeRelative: String {
        model.estimatedFinishingTimeRelative
    }
    
    func markTasksAsNotCompleted() {
        for i in 0..<model.tasks.count {
            model.tasks[i].completed = false
        }
    }
    
    //MARK: - User Intents
    
    func importDefaultTasks() {
        model.importDefaultTasks()
    }
    
    func fetchEvents() {
        // Request access to the calendar
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                let startDate = Date()
                if let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) {
                    
                    // Get the default calendar
                    let calendars = self.eventStore.calendars(for: .event)
                    
                    // Create a predicate to search for events in the date range
                    let predicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
                    
                    // Fetch events matching the predicate
                    let fetchedEvents = self.eventStore.events(matching: predicate)
                    
                    // Update the state variable on the main thread
                    DispatchQueue.main.async {
                        self.events = fetchedEvents
                    }
                }
            } else {
                print("Permission denied to access calendar")
            }
        }
    }
    
    func clearAllTasks() {
        model.clearAllTasks()
    }
    
    //MARK: - Helpers
    
    func parseEvents() {
        if let events {
            var calendarTasks: [Task] = []
            for event in events {
                if event.isAllDay {
                    continue
                }
                
                let timeTracked = calculateEventDuration(event: event)
                
                guard let timeTracked else { continue }
                
                let task = Task(title: event.title, timer: timeTracked)
                calendarTasks.append(task)
            }
            tasks = calendarTasks
        } else {
            print("There was a problem parsing the events.")
        }
    }
    
    func calculateEventDuration(event: EKEvent) -> TimeTracked? {
        // Ensure that both startDate and endDate are available
        
        guard var start = event.startDate, let end = event.endDate else {
            print("There was a problem calculating the event duration.")
            return nil
        }
        
        if hasEventStarted(event) {
            start = Date()
        }
        
        //TODO: consider when events started before than the current time.
        
        // Calculate the time interval (in seconds) between start and end
        let duration = end.timeIntervalSince(start)
        
        // Convert the duration into hours and minutes
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        return TimeTracked(hours: hours, minute: minutes)
    }

    func hasEventStarted(_ event: EKEvent) -> Bool {
        let currentDate = Date()

        if let startDate = event.startDate {
            return startDate < currentDate
        }

        return false
    }

}
