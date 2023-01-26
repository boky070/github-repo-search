//
//  RepositoryDetailsInteractor.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 29/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoryDetailsBusinessLogic {
    func fetchRepository()
}

protocol RepositoryDetailsDataStore {
    var repository: Repository! { get set }
}

class RepositoryDetailsInteractor: RepositoryDetailsBusinessLogic, RepositoryDetailsDataStore {
    var presenter: RepositoryDetailsPresentationLogic?
    var repository: Repository!

    func fetchRepository() {
        self.presenter?.presentRepository(repository)
    }
}
