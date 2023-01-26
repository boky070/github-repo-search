//
//  String+Extra.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation

extension String {
    func localized(args: CVarArg...) -> String {
        let localizedString = localized()
        
        return withVaList(args, { (args) -> String in
            return NSString(format: localizedString, locale: Locale.current, arguments: args) as String
        })
    }
    
    func localized() -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
}
