import CoreData

final class WishEventDataManager {
    static let shared = WishEventDataManager()
    
    private let context = CoreDataStack.shared.context
    
    // MARK: - Load Events
    func loadEvents() -> [WishEvent] {
        let request: NSFetchRequest<WishEvent> = WishEvent.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    // MARK: - Add Event
    func addEvent(title: String, description: String, startDate: Date, endDate: Date) {
        let event = WishEvent(context: context)
        event.title = title
        event.eventDescription = description
        event.startDate = startDate
        event.endDate = endDate
        saveContext()
    }
    
    // MARK: - Edit Event
    func editEvent(_ event: WishEvent, newTitle: String, newDescription: String, newStartDate: Date, newEndDate: Date) {
        event.title = newTitle
        event.eventDescription = newDescription
        event.startDate = newStartDate
        event.endDate = newEndDate
        saveContext()
    }
    
    // MARK: - Delete Event
    func deleteEvent(_ event: WishEvent) {
        context.delete(event)
        saveContext()
    }
    
    // MARK: - Save Context
    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}
