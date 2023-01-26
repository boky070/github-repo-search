//
//  UITableView+Extra.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(ofType: T.Type, withIdentifier: String? = nil, for indexPath: IndexPath) -> T {
        let identifier = withIdentifier ?? String(describing: ofType)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Table view \(self) can't dequeue a cell of type \(ofType) for identifier \(identifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(ofType: T.Type, withIdentifier: String? = nil) -> T {
        let identifier = withIdentifier ?? String(describing: ofType)
        
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Table view \(self) can't dequeue a header/footer view of type \(ofType) for identifier \(identifier)")
        }
        
        return view
    }
    
}
