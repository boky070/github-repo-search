//
//  OwnerResponseMapper.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation
import Kingfisher

final class OwnerResponseMapper: ResponseMapper {
    static func transform(response: OwnerResponse) -> Owner? {
        return Owner(id: response.id,
            username: response.username,
            name: response.name,
            avatarUrl: response.avatarUrl,
            url: response.url,
            htmlUrl: response.htmlUrl,
            company: response.company,
            location: response.location,
            email: response.email,
            bio: response.bio,
            publicRepos: response.publicRepos,
            publicGists: response.publicGists,
            followers: response.followers,
            following: response.following,
            createdAt: response.createdAt,
            updatedAt: response.updatedAt)
    }
}
