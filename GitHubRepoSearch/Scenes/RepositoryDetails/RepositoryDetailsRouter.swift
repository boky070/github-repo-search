//
//  RepositoriesRouter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoryDetailsRoutingLogic {
    func navigateToUserDetails(owner: Owner)
}

protocol RepositoryDetailsDataPassing {
  var dataStore: RepositoryDetailsDataStore? { get }
}

class RepositoryDetailsRouter: NSObject, RepositoryDetailsDataPassing {

    weak var viewController: RepositoryDetailsViewController?
    var dataStore: RepositoryDetailsDataStore?
}

// MARK: - Routing Logic
extension RepositoryDetailsRouter: RepositoryDetailsRoutingLogic {

    func navigateToUserDetails(owner: Owner) {
        let userDetailsViewController = UserDetailsViewController(owner: owner)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController?.navigationItem.backBarButtonItem = backItem
        viewController?.navigationController?.pushViewController(userDetailsViewController, animated: true)
        
        var userDetailsDataStore = userDetailsViewController.router?.dataStore
        userDetailsDataStore?.owner = owner
    }
}
