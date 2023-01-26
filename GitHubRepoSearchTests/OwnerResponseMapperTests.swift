//
//  OwnerResponseMapperTests.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 21/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import XCTest
@testable import GitHubRepoSearch

class OwnerResponseMapperTests: XCTestCase {
    private let ownerResponse = OwnerDataMock().mockOwnerResponse()

    func testMapping() {
        XCTAssertNotNil(ownerResponse)
        let entityOptional = OwnerResponseMapper.transform(response: ownerResponse!)

        XCTAssertNotNil(entityOptional)
        guard let entity = entityOptional, let ownerResponse = ownerResponse else { return }

        XCTAssertEqual(entity.id, ownerResponse.id)
        XCTAssertEqual(entity.username, ownerResponse.username)
        XCTAssertEqual(entity.avatarUrl, ownerResponse.avatarUrl)
        XCTAssertEqual(entity.url, ownerResponse.url)
        XCTAssertEqual(entity.htmlUrl, ownerResponse.htmlUrl)
        XCTAssertEqual(entity.company, ownerResponse.company)
        XCTAssertEqual(entity.location, ownerResponse.location)
        XCTAssertEqual(entity.email, ownerResponse.email)
        XCTAssertEqual(entity.bio, ownerResponse.bio)
        XCTAssertEqual(entity.publicRepos, ownerResponse.publicRepos)
        XCTAssertEqual(entity.publicGists, ownerResponse.publicGists)
        XCTAssertEqual(entity.followers, ownerResponse.followers)
        XCTAssertEqual(entity.following, ownerResponse.following)
        XCTAssertEqual(entity.createdAt, ownerResponse.createdAt)
        XCTAssertEqual(entity.updatedAt, ownerResponse.updatedAt)
    }
}
