//
//  WishDataManager.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 06.11.2024.
//

import CoreData

final class WishDataManager {
    static let shared = WishDataManager()
    
    private let context = CoreDataStack.shared.context
    
    func loadWishes() -> [Wish] {
        let request: NSFetchRequest<Wish> = Wish.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func addWish(text: String) {
        let wish = Wish(context: context)
        wish.text = text
        saveContext()
    }
    
    func editWish(_ wish: Wish, newText: String) {
        wish.text = newText
        saveContext()
    }
    
    func deleteWish(_ wish: Wish) {
        context.delete(wish)
        saveContext()
    }
    
    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}
