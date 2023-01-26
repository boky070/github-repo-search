//
//  RepositoryDetailsPresenter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 29/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoryDetailsPresentationLogic {
  func presentRepository(_ repository: Repository)
}

class RepositoryDetailsPresenter: RepositoryDetailsPresentationLogic {
  weak var viewController: RepositoryDetailsDisplayLogic?

  func presentRepository(_ repository: Repository) {
      viewController?.displayRepository(repository)
  }
}
