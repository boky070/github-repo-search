//
//  OwnerDataMock.swift
//  GitHubRepoSearchTests
//
//  Created by Bojan Gaspar on 21/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation
@testable import GitHubRepoSearch

class OwnerDataMock {
    func mockOwnerEntity() -> Owner? {
        guard let ownerResponse = mockOwnerResponse() else { return nil }

        return OwnerResponseMapper.transform(response: ownerResponse)
    }

    func mockOwnerResponse() -> OwnerResponse? {
        do {
            let json = try laodJsonFromFile("owner")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let ownerResponse = try decoder.decode(OwnerResponse.self, from: json)
            return ownerResponse
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

private extension OwnerDataMock {
    func laodJsonFromFile(_ file: String) throws -> Data {
        guard let path = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else { throw HttpClientError(type: .unknown, httpStatusCode: nil, localizedDescription: "Unable to load file from json") }

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}
