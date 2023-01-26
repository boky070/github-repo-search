//
//  UserDetailsInteractor.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 29/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol UserDetailsBusinessLogic {
    func fetchUser()
}

protocol UserDetailsDataStore {
    var owner: Owner! { get set }
}

class UserDetailsInteractor: UserDetailsBusinessLogic, UserDetailsDataStore {
    
    var presenter: UserDetailsPresentationLogic?
    var worker: UserDetailsWorker?
    var owner: Owner!

    func fetchUser() {
        presenter?.presentUser(self.owner)

        worker = UserDetailsWorker()
        worker?.fetchOwner(username: owner.username) { handler in
            switch handler {
            case .success(let owner):
                self.presenter?.presentUser(owner)
            case .failure(let error):
                print("Error while fetching owner: \(String(describing: error.localizedDescription))")
                self.presenter?.presentUser(self.owner)
            }
        }
    }
}
