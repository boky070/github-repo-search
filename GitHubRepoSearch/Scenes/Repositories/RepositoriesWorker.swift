//
//  RepositoriesWorker.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

class RepositoriesWorker {

    private let httpClient = HttpClient()

    func fetchRepositories(searchParam: String, page: Int, sortBy: SortType?, order: SortType?, handler: @escaping (Result<[Repository], HttpClientError>) -> Void) {

        var queryString: String = ""
        if let escapedSearchQuery = searchParam.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            queryString = escapedSearchQuery
        } else {
            queryString = searchParam
        }

        var path = "\(Paths.searchRepositories)?q=\(queryString)&page=\(page)"
        if let sortBy = sortBy {
            path += "&sort=\(sortBy.rawValue)"
        }
        if let order = order {
            path += "&order=\(order.rawValue)"
        }
        
        httpClient.loadData(path: path) { error, json in

            if let error = error {
                handler(.failure(error))
                return
            }

            guard let json = json else {
                handler(.failure(HttpClientError(type: .unknown, httpStatusCode: nil, localizedDescription: nil)))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let repositories = try decoder.decode([RepositoryResponse].self, from: json, keyPath: "items")
                handler(.success(RepositoryResponseMapper.map(response: repositories)))
            } catch let error {
                handler(.failure(HttpClientError(type: .invalidJSON, httpStatusCode: nil, localizedDescription: error.localizedDescription)))
            }
        }
    }
}
