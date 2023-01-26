//
//  RepositoriesRouter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoriesRoutingLogic {
    func navigateToRepositoryDetails(repository: Repository)
    func navigateToUserDetails(owner: Owner)
    func showSortSettings(sortBy: SortType, order: SortType)
}

class RepositoriesRouter: NSObject {
    weak var viewController: RepositoriesViewController?
}

// MARK: - Routing Logic
extension RepositoriesRouter: RepositoriesRoutingLogic {
    
    func navigateToRepositoryDetails(repository: Repository) {
        let repositoryDetailsViewController = RepositoryDetailsViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController?.navigationItem.backBarButtonItem = backItem
        viewController?.navigationController?.pushViewController(repositoryDetailsViewController, animated: true)

        var repositoryDetailsDataStore = repositoryDetailsViewController.router?.dataStore
        repositoryDetailsDataStore?.repository = repository
    }

    func navigateToUserDetails(owner: Owner) {
        let userDetailsViewController = UserDetailsViewController(owner: owner)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController?.navigationItem.backBarButtonItem = backItem
        viewController?.navigationController?.pushViewController(userDetailsViewController, animated: true)

        var userDetailsDataStore = userDetailsViewController.router?.dataStore
        userDetailsDataStore?.owner = owner
    }

    func showSortSettings(sortBy: SortType, order: SortType) {
        let sortViewController = SortViewController()
        sortViewController.delegate = viewController
        sortViewController.sortBy = sortBy
        sortViewController.order = order
        let navigationController = UINavigationController(rootViewController: sortViewController)
        navigationController.navigationBar.barTintColor = .repoSearchGray
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController?.present(navigationController, animated: true)
    }
}
