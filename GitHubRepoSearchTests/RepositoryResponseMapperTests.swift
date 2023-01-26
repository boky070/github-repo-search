//
//  RepositoryMapperTests.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 21/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import XCTest
@testable import GitHubRepoSearch

class RepositoryResponseMapperTests: XCTestCase {
    private let repositoryResponse = RepositoriesDataMock().mockRepositoryResponses()

    func testMapping() {
        let entities = RepositoryResponseMapper.map(response: repositoryResponse)
        XCTAssertEqual(entities.count, repositoryResponse.count)

        for i in 0..<entities.count {
            let entity = entities[i]
            let response = repositoryResponse[i]
            XCTAssertEqual(entity.id, response.id)
            XCTAssertEqual(entity.name, response.name)
            XCTAssertEqual(entity.fullName, response.fullName)
            XCTAssertEqual(entity.description, response.description)
            XCTAssertEqual(entity.url, response.url)
            XCTAssertEqual(entity.htmlUrl, response.htmlUrl)
            XCTAssertEqual(entity.language, response.language)
            XCTAssertEqual(entity.createdAt, response.createdAt)
            XCTAssertEqual(entity.updatedAt, response.updatedAt)
            XCTAssertEqual(entity.stars, response.stars)
            XCTAssertEqual(entity.forks, response.forks)
            XCTAssertEqual(entity.issues, response.issues)
            XCTAssertEqual(entity.watchers, response.watchers)
            XCTAssertEqual(entity.owner != nil, response.owner != nil)
        }
    }
}
