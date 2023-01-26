//
//  SortViewControllerTest.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 03/05/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import XCTest
@testable import GitHubRepoSearch

class SortViewControllerTest: XCTestCase {

    private lazy var viewController: SortViewController = {
        let vc = SortViewController()
        _ = vc.view
        return vc
    }()

    func testSortByOptionChange() {
        viewController.sortBy = .forks
        viewController.order = .asc

        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))

        XCTAssertEqual(viewController.sortBy, .updated)
        XCTAssertEqual(viewController.order, .asc)
    }

    func testOrderOptionChange() {
        viewController.sortBy = .forks
        viewController.order = .asc

        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))

        XCTAssertEqual(viewController.sortBy, .forks)
        XCTAssertEqual(viewController.order, .desc)
    }
}
