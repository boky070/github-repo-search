//
//  Owner.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

struct Owner {
    let id: Int
    let username: String
    let name: String?
    let avatarUrl: URL?
    let url: URL?
    let htmlUrl: URL?
    let company: String?
    let location: String?
    let email: String?
    let bio: String?
    let publicRepos: Int?
    let publicGists: Int?
    let followers: Int?
    let following: Int?
    let createdAt: Date?
    let updatedAt: Date?
}
