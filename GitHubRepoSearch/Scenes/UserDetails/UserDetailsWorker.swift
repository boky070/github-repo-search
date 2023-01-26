//
//  RepositoriesWorker.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

class UserDetailsWorker {

    private let httpClient = HttpClient()

    func fetchOwner(username: String, handler: @escaping (Result<Owner, HttpClientError>) -> Void) {

        httpClient.loadData(path: "\(Paths.users)/\(username)") { error, json in
            guard let json = json else {
                handler(.failure(HttpClientError(type: .unknown, httpStatusCode: nil, localizedDescription: nil)))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let ownerResponse = try decoder.decode(OwnerResponse.self, from: json)
                if let owner = OwnerResponseMapper.transform(response: ownerResponse) {
                    handler(.success(owner))
                } else {
                    handler(.failure(HttpClientError(type: .invalidJSON, httpStatusCode: nil, localizedDescription: "An error occured while parsing owner json response")))
                }
            } catch let error {
                handler(.failure(HttpClientError(type: .invalidJSON, httpStatusCode: nil, localizedDescription: error.localizedDescription)))
            }
        }
    }
}
