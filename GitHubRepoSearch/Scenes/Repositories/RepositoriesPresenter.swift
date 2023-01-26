//
//  RepositoriesPresenter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoriesPresentationLogic {
    func presentRepositories(_ repositories: [Repository], for page: Int)
    func presentRepositoriesError(_ error: HttpClientError)
}

class RepositoriesPresenter: RepositoriesPresentationLogic {

    weak var viewController: RepositoriesDisplayLogic?

    func presentRepositories(_ repositories: [Repository], for page: Int) {
        viewController?.displayRepositories(repositories, for: page)
    }

    func presentRepositoriesError(_ error: HttpClientError) {
        viewController?.displayError(error)
    }
}
