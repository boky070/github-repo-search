//
//  RepositoriesDataMock.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 21/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation
@testable import GitHubRepoSearch

class RepositoriesDataMock {
    func mockRepositoryEntities() -> [Repository] {
        return RepositoryResponseMapper.map(response: mockRepositoryResponses())
    }

    func mockRepositoryResponses() -> [RepositoryResponse] {
        do {
            guard let json = try laodJsonFromFile("repositories") as? Data else { return [] }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let repositoryResponse = try decoder.decode([RepositoryResponse].self, from: json, keyPath: "items")
            return repositoryResponse
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}

private extension RepositoriesDataMock {
    func laodJsonFromFile(_ file: String) throws -> Any {
        guard let path = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else { throw HttpClientError(type: .unknown, httpStatusCode: nil, localizedDescription: "Unable to load file from json") }

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult
    }
}
