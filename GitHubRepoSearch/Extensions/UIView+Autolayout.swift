//
//  UIView+Extra.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

extension UIView {
    class func autolayoutView() -> Self {
        let instance = self.init()
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }
    
    func autoLayoutView() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
