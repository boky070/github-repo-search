//
//  SortInteractor.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 01/05/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit

protocol SortBusinessLogic {
    func fetchSortOptions(sortBy: SortType?, order: SortType?)
}

class SortInteractor: SortBusinessLogic {

    var presenter: SortPresentationLogic?
    private var sortOptions: [SortSection] = [
        SortSection(title: "sort_by".localized(), items: [
            SortItem(title: "best_match".localized(), type: .bestMatch, value: false),
            SortItem(title: "stars".localized(), type: .stars, value: false),
            SortItem(title: "forks".localized(), type: .forks, value: false),
            SortItem(title: "updated".localized(), type: .updated, value: false)
        ]),
        SortSection(title: "order".localized(), items: [
            SortItem(title: "desc".localized(), type: .desc, value: false),
            SortItem(title: "asc".localized(), type: .asc, value: false)
        ])
    ]

    func fetchSortOptions(sortBy: SortType?, order: SortType?) {
        if let sortBy = sortBy {
            for (index, item) in sortOptions[0].items.enumerated() where item.type == sortBy {
                sortOptions[0].items[index].value = true
            }
        }
        if let order = order {
            for (index, item) in sortOptions[1].items.enumerated() where item.type == order {
                sortOptions[1].items[index].value = true
            }
        } 
        self.presenter?.presentSortOptions(sortOptions)
    }
}
