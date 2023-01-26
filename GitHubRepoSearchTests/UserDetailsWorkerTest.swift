//
//  UserDetailsWorkerTest.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 02/05/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import XCTest
@testable import GitHubRepoSearch

class UserDetailsWorkerTest: XCTestCase {
    private let userDetailsWorker = UserDetailsWorker()

    func testFetchOwner() {
        let promise = expectation(description: "Completion handler invoked")

        userDetailsWorker.fetchOwner(username: "phosphos") { result in
            switch result {
            case .success(let owner):
                XCTAssertNotNil(owner)
                XCTAssertEqual("Boris-Kun", owner.name)
                promise.fulfill()
            case .failure:
                XCTFail("Request should succeed")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchOwnerEmptyString() {
        let promise = expectation(description: "Completion handler invoked")

        userDetailsWorker.fetchOwner(username: "") { result in
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
