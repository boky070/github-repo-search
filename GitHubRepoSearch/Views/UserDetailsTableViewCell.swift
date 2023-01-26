//
//  UserDetailsTableViewCell.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 30/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    private let titleLabel = UILabel.autolayoutView()
    private let valueLabel = UILabel.autolayoutView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension UserDetailsTableViewCell {

    func setUserItem(_ item: UserItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}

// MARK: - ViewLifecycle
extension UserDetailsTableViewCell: ViewLifecycle {

    func setupViews() {
        backgroundColor = .white
        selectionStyle = .none

        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .gray

        addSubview(valueLabel)
        valueLabel.font = UIFont.systemFont(ofSize: 15)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 5
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalToSuperview().offset(8)
        }

        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
