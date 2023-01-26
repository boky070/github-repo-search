//
//  UserDetailsPresenter.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 29/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol UserDetailsPresentationLogic {
  func presentUser(_ owner: Owner)
}

class UserDetailsPresenter: UserDetailsPresentationLogic {
  weak var viewController: UserDetailsDisplayLogic?

  func presentUser(_ owner: Owner) {
      viewController?.displayUser(owner)
  }
}
