//
//  RepositoriesWorkerTest.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 21/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import XCTest
@testable import GitHubRepoSearch

class RepositoriesWorkerTest: XCTestCase {
    private let repositoriesWorker = RepositoriesWorker()

    func testFetchRepositoryList() {
        let promise = expectation(description: "Completion handler invoked")
        let searchParam = "abaaa"
        let page = 1

        repositoriesWorker.fetchRepositories(searchParam: searchParam, page: page, sortBy: nil, order: nil) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                promise.fulfill()
            case .failure:
                XCTFail("Request should succeed")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchRepositoryListEmptyString() {
        let promise = expectation(description: "Completion handler invoked")
        let searchParam = ""
        let page = 1

        repositoriesWorker.fetchRepositories(searchParam: searchParam, page: page, sortBy: nil, order: nil) { result in
            switch result {
            case .success(let response):
                XCTFail("Request should fail")
                XCTAssertNotNil(response)
                promise.fulfill()
            case .failure:
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
