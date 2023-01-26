//
//  Mappers.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation

protocol ResponseMapper {
    associatedtype T
    associatedtype U
    
    static func map(response: [T]) -> [U]
    
    // If you return nil, then map will ignore your data
    static func transform(response: T) -> U?
}

extension ResponseMapper {
    static func map(response: [T]) -> [U] {
        return response.compactMap(transform)
    }
}
