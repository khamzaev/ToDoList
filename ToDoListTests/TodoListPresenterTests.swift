//
//  TodoListPresenterTests.swift
//  ToDoListTests
//
//  Created by khamzaev on 03.03.2026.
//


import XCTest
@testable import ToDoList

final class TodoListPresenterTests: XCTestCase {
    
    private final class ViewSpy: TodoListViewProtocol {
        private(set) var shownTitle: String?
        private(set) var shownItems: [TodoListViewModel] = []
        
        func showTitle(_ text: String) { shownTitle = text }
        
        func showItems(_ items: [ToDoList.TodoListViewModel]) {
            shownItems = items
        }
        
        func reloadRow(at indexPath: IndexPath) {
            
        }
        
        
    }
    
    private final class InteractorSpy: TodoListInteractorProtocol {
        
        private(set) var deleteCalled = 0
        private(set) var deleteId: Int64?
        private(set) var loadInitialCalled = 0
        
        private(set) var fetchTodosCalled = 0
        private(set) var fetchTodosQuery: String?

        private(set) var toggleCalled = 0
        private(set) var toggleId: Int64?
        
        func loadInitialIfNeeded() { loadInitialCalled += 1 }
        
        func fetchTodos(query: String?) {
            fetchTodosCalled += 1
            fetchTodosQuery = query
        }
        
        func deleteTodo(id: Int64) {
            deleteCalled += 1
            deleteId = id
        }
        
        func toggleCompleted(id: Int64) {
            toggleCalled += 1
            toggleId = id
        }
        
        
    }
    
    private final class RouterSpy: TodoListRouterProtocol {
        
        private(set) var openCreateCalled = 0
        private(set) var openEditorCalled = 0
        private(set) var openEditorId: Int64?
        
        func openCreate() {
            openCreateCalled += 1
        }
        
        func openEditor(id: Int64) {
            openEditorCalled += 1
            openEditorId = id
        }
        
        
    }
    
    private func makeSUT() -> (presenter: TodoListPresenter,
                               view: ViewSpy,
                               interactor: InteractorSpy,
                               router: RouterSpy) {
        
        let view = ViewSpy()
        let interactor = InteractorSpy()
        let router = RouterSpy()
        
        let presenter = TodoListPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        return (presenter, view, interactor, router)
    }
    
    func test_viewDidLoad_setsTitle_andLoadsInitial() {
        let sut = makeSUT()

        sut.presenter.viewDidLoad()

        XCTAssertEqual(sut.view.shownTitle, "Задачи")
        XCTAssertEqual(sut.interactor.loadInitialCalled, 1)
    }
    
    func test_didTapAdd_callsRouterOpenCreate() {
        
        let sut = makeSUT()
        
        sut.presenter.didTapAdd()
        
        XCTAssertEqual(sut.router.openCreateCalled, 1)
    }
    
    func test_didDelete_callsInteractorDelete() {
        
        let sut = makeSUT()
        let id: Int64 = 7
        
        sut.presenter.didDelete(id: id)
        
        XCTAssertEqual(sut.interactor.deleteCalled, 1)
        XCTAssertEqual(sut.interactor.deleteId, id)
    }
    
    func test_didFetchTodos_mapsDomainToViewModel() {

        let sut = makeSUT()

        let date = Date(timeIntervalSince1970: 100)

        let domainItem = TodoItem(
            id: 1,
            title: "Title",
            description: "Desc",
            createdAt: date,
            isCompleted: true
        )

        sut.presenter.didFetchTodos([domainItem])

        XCTAssertEqual(sut.view.shownItems.count, 1)

        let viewModel = sut.view.shownItems.first

        XCTAssertEqual(viewModel?.id, 1)
        XCTAssertEqual(viewModel?.title, "Title")
        XCTAssertEqual(viewModel?.subtitle, "Desc")
        XCTAssertEqual(viewModel?.isCompleted, true)
    }
    
    func test_viewWillAppear_fetchesTodosWithNilQuery() {
        let sut = makeSUT()

        sut.presenter.viewWillAppear()

        XCTAssertEqual(sut.interactor.fetchTodosCalled, 1)
        XCTAssertNil(sut.interactor.fetchTodosQuery)
    }
    
    func test_didTapToggleCompleted_callsInteractorToggle() {
        let sut = makeSUT()
        let id: Int64 = 5

        sut.presenter.didTapToggleCompleted(id: id)

        XCTAssertEqual(sut.interactor.toggleCalled, 1)
        XCTAssertEqual(sut.interactor.toggleId, id)
    }
    
    func test_didSelect_opensEditor() {
        let sut = makeSUT()
        let id: Int64 = 11

        sut.presenter.didSelect(id: id)

        XCTAssertEqual(sut.router.openEditorCalled, 1)
        XCTAssertEqual(sut.router.openEditorId, id)
    }

}
