//
//  Repository.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation

struct Repository {
    let id: Int
    let name: String
    let fullName: String
    let description: String
    let url: URL
    let htmlUrl: URL
    let language: String
    let createdAt: Date?
    let updatedAt: Date?
    let stars: Int
    let forks: Int
    let issues: Int
    let watchers: Int
    let owner: Owner?
}
