//
//  ViewLifecycle.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

protocol ViewLifecycle {
    func setupViews()
    func setupConstraints()
}

extension ViewLifecycle where Self: UIView {
    func setup() {
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
}
