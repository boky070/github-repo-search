//
//  OwnerResponse.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//
import Foundation

struct OwnerResponse: Decodable {
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

    enum CodingKeys: String, CodingKey {
        case id,
        username = "login",
        name,
        avatarUrl = "avatar_url",
        url = "url",
        htmlUrl = "html_url",
        company,
        location,
        email,
        bio,
        publicRepos = "public_repos",
        publicGists = "public_gists",
        followers,
        following,
        createdAt = "created_at",
        updatedAt = "updated_at"
    }
}
