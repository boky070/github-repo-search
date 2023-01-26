//
//  RepositoriesInteractor.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoriesBusinessLogic {
    func fetchRepositoriesFor(searchParam: String, page: Int, sortBy: SortType?, order: SortType?)
}

class RepositoriesInteractor: RepositoriesBusinessLogic {

    var presenter: RepositoriesPresentationLogic?
    var worker: RepositoriesWorker?

    func fetchRepositoriesFor(searchParam: String, page: Int, sortBy: SortType?, order: SortType?) {
        worker = RepositoriesWorker()
        worker?.fetchRepositories(searchParam: searchParam, page: page, sortBy: sortBy, order: order) { handler in
            switch handler {
            case .success(let repositories):
                self.presenter?.presentRepositories(repositories, for: page)
            case .failure(let error):
                self.presenter?.presentRepositoriesError(error)
            }
        }
    }
}
