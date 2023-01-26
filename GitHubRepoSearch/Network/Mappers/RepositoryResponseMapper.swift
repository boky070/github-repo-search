//
//  RepositoryResponseMapper.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation

final class RepositoryResponseMapper: ResponseMapper {
    static func transform(response: RepositoryResponse) -> Repository? {
        var owner: Owner?
        if let resposeOwner = response.owner {
            owner = OwnerResponseMapper.transform(response: resposeOwner)
        }
        
        return Repository(id: response.id,
                          name: response.name,
                          fullName: response.fullName,
                          description: response.description ?? "",
                          url: response.url,
                          htmlUrl: response.htmlUrl,
                          language: response.language ?? "-",
                          createdAt: response.createdAt,
                          updatedAt: response.updatedAt,
                          stars: response.stars,
                          forks: response.forks,
                          issues: response.issues,
                          watchers: response.watchers,
                          owner: owner)
    }
}
