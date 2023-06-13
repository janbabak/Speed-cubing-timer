//
//  DataController.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 11.06.2023.
//

import CoreData

protocol HasDataControllerService {
    var dataControllerService: any DataControllerServicing { get } // TODO: why any required
}

protocol DataControllerServicing: ObservableObject {
    var container: NSPersistentContainer { get }
    
    // save all changes
    func save()
    
    // return all solves, can specify the fetch request (sorting, predicate)
    func fetchSolves() -> [CDSolve]
    
    // return solves sorted by date from the newest to the oldest
    func fetchSolvesSortedByDateDesc() -> [CDSolve]
    
    // return solves that don't have DNF penalty
    func fetchNotDNFSolves() -> [CDSolve]
    
    func deleteSolve(solve: CDSolve)
    
    func deleteAllSolves()
    
    func addSolve(solve: Solve)
    
    func addSolve(
        scramble: String,
        date: Date,
        hours: Int16,
        minutes: Int16,
        seconds: Int16,
        fractions: Int16,
        note: String,
        penalty: Solve.Penalty
    )
    
    func editSolve(
        solve: CDSolve,
        scramble: String?,
        date: Date?,
        hours: Int16?,
        minutes: Int16?,
        seconds: Int16?,
        fractions: Int16?,
        note: String?,
        penalty: Solve.Penalty?
    )
}

// MARK: - implementation

final class DataControllerService: DataControllerServicing {
    let container = NSPersistentContainer(name: "SpeedCubingTimerModel")
        
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    // save all changes in context
    func save() {
        do {
            try container.viewContext.save()
            print("🗂️ Data was saved.")
        } catch {
            print("Data wasn't saved: \(error.localizedDescription)")
        }
    }
    
    func fetchSolves() -> [CDSolve] {
        return fetchSolves(fetchRequest: CDSolve.fetchRequest())
    }
    
    // return all solves, can specify the fetch request (sorting, predicate)
    private func fetchSolves(fetchRequest: NSFetchRequest<CDSolve>) -> [CDSolve] {
        do {
            let solves = try container.viewContext.fetch(fetchRequest)
            print("🚚 Fetch solves.")
            return solves
        } catch {
            print("Fetch solves failded: \(error.localizedDescription)")
            return []
        }
    }
    
    // return solves sorted by date from the newest to the oldest
    func fetchSolvesSortedByDateDesc() -> [CDSolve] {
        let fetchRequest = CDSolve.fetchRequest()
        let dateSort =  NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        return fetchSolves(fetchRequest: fetchRequest)
    }
    
    // return solves that don't have DNF penalty
    func fetchNotDNFSolves() -> [CDSolve] {
        let fetchRequest = CDSolve.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "penaltyStr != %@", "DNF"
        )
        return fetchSolves(fetchRequest: fetchRequest)
    }
    
    func deleteSolve(solve: CDSolve) {
        container.viewContext.delete(solve)
        
        print("🗑️ Delet solve.")
        
        save()
    }
    
    func deleteAllSolves() {
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: CDSolve.fetchRequest()
        )
        // Specify the result of the NSBatchDeleteRequest
        // should be the NSManagedObject IDs for the deleted objects
        deleteRequest.resultType = .resultTypeObjectIDs
        
        var batchDelete: NSBatchDeleteResult? = nil
        do {
            batchDelete = try container.viewContext.execute(deleteRequest) as? NSBatchDeleteResult
        } catch {
            print("batch delete error: \(error.localizedDescription)")
            return
        }
        
        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else {
            return
        }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        // Merge the delete changes into the managed object context
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [container.viewContext]
        )
        
        print("🗑️ Delete all solves.")
    }
    
    func addSolve(solve: Solve) {
        addSolve(
            scramble: solve.scramble,
            date: solve.date,
            hours: Int16(solve.hours),
            minutes: Int16(solve.minutes),
            seconds: Int16(solve.seconds),
            fractions: Int16(solve.fractions),
            note: solve.note,
            penalty: solve.penalty
        )
    }
    
    func addSolve(
        scramble: String,
        date: Date = Date(),
        hours: Int16 = 0,
        minutes: Int16 = 0,
        seconds: Int16 = 0,
        fractions: Int16 = 0,
        note: String = "",
        penalty: Solve.Penalty = .noPenalty
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
        
        print("➕ Add solve.")
        
        save()
    }
    
    func editSolve(
        solve: CDSolve,
        scramble: String? = nil,
        date: Date? = nil,
        hours: Int16? = nil,
        minutes: Int16? = nil,
        seconds: Int16? = nil,
        fractions: Int16? = nil,
        note: String? = nil,
        penalty: Solve.Penalty? = nil
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
        print("✍️ Edit solve.")
        
        save()
    }
}
