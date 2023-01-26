//
//  RepositoriesViewControllerTests.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 23/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import XCTest
@testable import GitHubRepoSearch

class RepositoriesViewControllerTests: XCTestCase {

    var actionPerformed = false

    private lazy var viewController: RepositoriesViewController = {
        let vc = RepositoriesViewController()
        _ = vc.view
        return vc
    }()

    override func setUp() {
        super.setUp()
        actionPerformed = false
    }
    
    func testThatClickOnRepositoryNavigatesToDetails() {
        let mockedRouter = RepositoriesRouterMock {
            self.actionPerformed = true
        }
        viewController.router = mockedRouter
        viewController.repositories = [.mock, .mock, .mock, .mock, .mock]

        viewController.tableView.reloadData()
        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))
        XCTAssertTrue(actionPerformed)
    }

    func testDisplayRepositories() {
        let repositories: [Repository] = [.mock, .mock, .mock, .mock, .mock]
        viewController.displayRepositories(repositories, for: 1)

        XCTAssertTrue(viewController.infoLabel.isHidden)
    }

    func testDisplayRepositoriesWithEmptyArray() {
        let repositories: [Repository] = []
        viewController.displayRepositories(repositories, for: 1)

        XCTAssertFalse(viewController.infoLabel.isHidden)
    }

    func testDisplayRepositoriesForPage2() {
        let repositories: [Repository] = [.mock, .mock, .mock, .mock, .mock]
        viewController.repositories = repositories
        viewController.displayRepositories(repositories, for: 2)

        XCTAssert(viewController.repositories.count == repositories.count * 2)
    }
}

class RepositoriesRouterLogicMock: NSObject & RepositoriesRoutingLogic {

    private let handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler
    }

    func navigateToRepositoryDetails(repository: Repository) {
        handler()
    }
    func navigateToUserDetails(owner: Owner) {
        handler()
    }
    func showSortSettings(sortBy: SortType, order: SortType) {
        handler()
    }
}

class RepositoriesRouterMock: RepositoriesRouterLogicMock {

}

extension Repository {

    static var mock: Repository = {
        return Repository(
            id: 0,
            name: "Mock",
            fullName: "Mocked repository",
            description: "",
            url: URL(string: "https://api.github.com/users/creativemarket")!,
            htmlUrl: URL(string: "https://api.github.com/users/creativemarket")!,
            language: "",
            createdAt: Date(),
            updatedAt: Date(),
            stars: 0,
            forks: 0,
            issues: 0,
            watchers: 0,
            owner: nil)
    }()
}
