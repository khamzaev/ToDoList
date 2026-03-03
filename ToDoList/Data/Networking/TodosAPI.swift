//
//  TodosAPIProtocol.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//

import Foundation

protocol TodosAPIProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void)
}

final class TodosAPI: TodosAPIProtocol {
    
    private let session: URLSession
    private let url: URL
    
    init(
        url: URL = URL(string: "https://dummyjson.com/todos")!,
        session: URLSession = .shared
    ) {
        self.url = url
        self.session = session
    }
    
    func fetchTodos(completion: @escaping (Result<[TodoDTO], any Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "TodosAPI", code: -1)))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(TodosResponseDTO.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded.todos)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
