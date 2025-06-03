//
//  main.swift
//  swift-part3
//
//  Created by Anna Bzhshkyan on 03.06.25.
//

import Foundation

//task 1
protocol Borrowable: AnyObject {
    var borrowDate: Date? { get set }
    var returnDate: Date? { get set }
    var isBorrowed: Bool { get set }
    
    func checkIn()
    func isOverdue() -> Bool
}

extension Borrowable {
    func isOverdue() -> Bool {
        guard let returnDate = returnDate else {
            return false
        }
        
        if Date() > returnDate {
            return true
        }
        
        return false
    }
    
    func checkIn() {
        borrowDate = nil
        returnDate = nil
        isBorrowed = false
    }
}

class Item {
    let id: String
    let title: String
    let author: String
    
    init(id: String, title: String, author: String) {
        self.id = id
        self.title = title
        self.author = author
    }
}

class Book: Item, Borrowable {
    var borrowDate: Date?
    var returnDate: Date?
    var isBorrowed: Bool
    
    init(id: String, title: String, author: String, isBorrowed: Bool) {
        self.isBorrowed = isBorrowed
        super.init(id: id, title: title, author: author)
    }
    
}

enum LibraryError: Error {
    case itemNotFound
    case itemNotBorrowable
    case alreadyBorrowed
}

class Library {
    
    var itemStorage: [String: Item] = [:]
    func addBook(_ book: Book) {
        itemStorage[book.id] = book
    }
    
    func borrowItem(by id: String) throws -> Item {
        
        guard let existingItem = itemStorage[id] else {
            throw LibraryError.itemNotFound
        }
        
        guard let borrowableItem = existingItem as? Borrowable else {
            throw LibraryError.itemNotBorrowable
        }
        
        if borrowableItem.isBorrowed {
            throw LibraryError.alreadyBorrowed
        }
        
        borrowableItem.isBorrowed = true
        borrowableItem.borrowDate = Date()
        borrowableItem.returnDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        return existingItem
    }

}



