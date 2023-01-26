//
//  UserDetailsRouter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 29/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol UserDetailsDataPassing {
  var dataStore: UserDetailsDataStore? { get }
}

class UserDetailsRouter: NSObject, UserDetailsDataPassing {

    weak var viewController: UserDetailsViewController?
    var dataStore: UserDetailsDataStore?
}
