//
//  TodosRepository.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation
import CoreData

protocol TodosRepositoryProtocol {
    func fetch(query: String?, completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func upsert(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func upsert(_ items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TodosRepository: TodosRepositoryProtocol {
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    func fetch(query: String?, completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        stack.performBackground { context in
            do {
                let request = CDTodo.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                
                if let q = query, !q.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let p1 = NSPredicate(format: "title CONTAINS[cd] %@", q)
                    let p2 = NSPredicate(format: "todoDescription CONTAINS[cd] %@", q)
                    request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
                }
                
                let objects = try context.fetch(request)
                let items = objects.map { $0.toDomain()}
                
                DispatchQueue.main.async { completion(.success(items)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func upsert(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        stack.performBackground { context in
            do {
                let request = CDTodo.fetchRequest()
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "id == %@",NSNumber(value: item.id))
                
                let object = try context.fetch(request).first ?? CDTodo(context: context)
                object.apply(item)
                
                try context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func upsert(_ items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        stack.performBackground { context in
            do {
                for item in items {
                    let request = CDTodo.fetchRequest()
                    request.fetchLimit = 1
                    request.predicate = NSPredicate(format: "id == %@", NSNumber(value: item.id))

                    let object = try context.fetch(request).first ?? CDTodo(context: context)
                    object.apply(item)
                }

                try context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func delete(id: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        stack.performBackground { context in
            do {
                let request = CDTodo.fetchRequest()
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
                
                if let object = try context.fetch(request).first {
                    context.delete(object)
                    try context.save()
                }
                
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
}
