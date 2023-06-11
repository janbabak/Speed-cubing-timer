//
//  DataController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import CoreData
import SwiftUI

final class DataController: ObservableObject {
    static let shared = DataController() // shared singleton instance
    
    let container = NSPersistentContainer(name: "SpeedCubingTimerModel")
        
    // private singleton init
    private init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
            print("🗂️ Data was saved.")
        } catch {
            print("Data wasn't saved: \(error.localizedDescription)")
        }
    }
    
    func fetchSolves(fetchRequest: NSFetchRequest<CDSolve> = CDSolve.fetchRequest()) -> [CDSolve] {
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch solves failded: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchSolvesSortedByDateDesc() -> [CDSolve] {
        let fetchRequest = CDSolve.fetchRequest()
        let dateSort =  NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        return fetchSolves(fetchRequest: fetchRequest)
    }
    
    func deleteSolve(solve: CDSolve) {
        container.viewContext.delete(solve)
    }
    
    func addSolve(
        scramble: String,
        date: Date = Date(),
        hours: Int16 = 0,
        minutes: Int16 = 0,
        seconds: Int16 = 0,
        fractions: Int16 = 0,
        note: String = "",
        penalty: String = "no penalty" // TODO: - enum
    ) {
        
        let solve = CDSolve(context: container.viewContext)
        solve.scramble = scramble
        solve.date = date
        solve.hours = hours
        solve.minutes = minutes
        solve.seconds = seconds
        solve.fractions = fractions
        solve.note = note
        solve.penalty = penalty
        solve.id = UUID()
        
        save()
    }
    
    func editSolve(
        solve: CDSolve,
        scramble: String?,
        date: Date?,
        hours: Int16?,
        minutes: Int16?,
        seconds: Int16?,
        fractions: Int16?,
        note: String?,
        penalty: String?
    ) {
        if let scramble {
            solve.scramble = scramble
        }
        if let date {
            solve.date = date
        }
        if let hours {
            solve.hours = hours
        }
        if let minutes {
            solve.minutes = minutes
        }
        if let seconds {
            solve.seconds = seconds
        }
        if let fractions {
            solve.fractions = fractions
        }
        if let note {
            solve.note = note
        }
        if let penalty {
            solve.penalty = penalty
        }
        
        save()
    }
}
