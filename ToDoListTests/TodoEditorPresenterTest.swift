//
//  TodoEditorPresenterTest.swift
//  ToDoListTests
//
//  Created by khamzaev on 03.03.2026.
//

import XCTest
@testable import ToDoList

final class TodoEditorPresenterTest: XCTestCase {

    private final class ViewSpy: TodoEditorViewProtocol {
        private(set) var shownTitle: String?
        private(set) var shownDescription: String?
        private(set) var shownCreatedAt: Date?
        
        func showTodo(title: String, description: String, createdAt: Date) {
            shownTitle = title
            shownDescription = description
            shownCreatedAt = createdAt
        }
        
    }
    
    private final class InteractorSpy: TodoEditorInteractorProtocol {
        private(set) var loadTodoCalled = 0

        private(set) var saveCalled = 0
        private(set) var savedTitle: String?
        private(set) var savedDescription: String?

        func loadTodo() {
            loadTodoCalled += 1
        }

        func save(title: String, description: String) {
            saveCalled += 1
            savedTitle = title
            savedDescription = description
        }
    }
    
    private final class RouterSpy: TodoEditorRouterProtocol {
        private(set) var closeCalled = 0

        func close() {
            closeCalled += 1
        }
    }
    
    private func makeSUT(mode: TodoEditorMode = .create) -> (presenter: TodoEditorPresenter, view: ViewSpy, interactor: InteractorSpy, router: RouterSpy) {
        let view = ViewSpy()
        let interactor = InteractorSpy()
        let router = RouterSpy()
        let presenter = TodoEditorPresenter(view: view, interactor: interactor, router: router, mode: mode)
        return (presenter, view, interactor, router)
    }
    
    func test_viewDidLoad_callsInteractorLoadTodo() {
        let sut = makeSUT()

        sut.presenter.viewDidLoad()

        XCTAssertEqual(sut.interactor.loadTodoCalled, 1)
    }
    
    func test_didTapSave_callsInteractorSaveWithSameValues() {
        let sut = makeSUT()

        sut.presenter.didTapSave(title: "A", description: "B")

        XCTAssertEqual(sut.interactor.saveCalled, 1)
        XCTAssertEqual(sut.interactor.savedTitle, "A")
        XCTAssertEqual(sut.interactor.savedDescription, "B")
    }
    
    func test_didLoad_showsTodoOnView() {
        let sut = makeSUT()
        let date = Date(timeIntervalSince1970: 100)

        let todo = TodoItem(id: 1, title: "T", description: "D", createdAt: date, isCompleted: false)
        sut.presenter.didLoad(todo: todo)

        XCTAssertEqual(sut.view.shownTitle, "T")
        XCTAssertEqual(sut.view.shownDescription, "D")
        XCTAssertEqual(sut.view.shownCreatedAt, date)
    }
    
    func test_didSave_closesRouter() {
        let sut = makeSUT()

        sut.presenter.didSave()

        XCTAssertEqual(sut.router.closeCalled, 1)
    }
    
    func test_didTapBack_closesRouter() {
        let sut = makeSUT()

        sut.presenter.didTapBack()

        XCTAssertEqual(sut.router.closeCalled, 1)
    }
    
    func test_didLoadInitial_showsInitialTodo() {
        let sut = makeSUT()

        let before = Date()
        sut.presenter.didLoadInitial(title: "X", description: "Y")
        let after = Date()

        XCTAssertEqual(sut.view.shownTitle, "X")
        XCTAssertEqual(sut.view.shownDescription, "Y")

        guard let date = sut.view.shownCreatedAt else {
            return XCTFail("createdAt should not be nil")
        }
        XCTAssertTrue(date >= before && date <= after)
    }

}
