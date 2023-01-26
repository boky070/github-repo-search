//
//  SortPresenter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 01/05/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol SortPresentationLogic {
    func presentSortOptions(_ sortOptions: [SortSection])
}

class SortPresenter: SortPresentationLogic {
    weak var viewController: SortDisplayLogic?

    func presentSortOptions(_ sortOptions: [SortSection]) {
        viewController?.displaySortOptions(sortOptions)
    }
}
