//
//  TodosDTOMappingTests.swift
//  ToDoListTests
//
//  Created by khamzaev on 03.03.2026.
//

import XCTest
@testable import ToDoList
import CoreData

final class TodosDTOMappingTests: XCTestCase {

    func test_CD_Todo_maps_toDomain_correctly() {

        let container = NSPersistentContainer(name: "ToDoList")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        
        let context = container.viewContext
        
        let cdTodo = CDTodo(context: context)
        
        cdTodo.id = 10
        cdTodo.title = "Test"
        cdTodo.todoDescription = "Desc"
        cdTodo.createdAt = Date(timeIntervalSince1970: 123)
        cdTodo.isCompleted = true
        
        let domain = cdTodo.toDomain()
        
        XCTAssertEqual(domain.id, 10)
        XCTAssertEqual(domain.title, "Test")
        XCTAssertEqual(domain.description, "Desc")
        XCTAssertEqual(domain.isCompleted, true)
    }
}
