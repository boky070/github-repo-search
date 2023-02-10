//
//  RepositoryTableViewCell.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoryTableViewCellDelegate: AnyObject {
    func ownerTapped(owner: Owner)
}

class RepositoryTableViewCell: UITableViewCell {

    private let countLabel = UILabel.autolayoutView()
    private let repositoryNameLabel = UILabel.autolayoutView()
    private let ownerStackView =  UIStackView.autolayoutView()
    private let ownerAvatarImageView = UIImageView.autolayoutView()
    private let ownerNameLabel = UILabel.autolayoutView()
    private let watchersImageView = UIImageView.autolayoutView()
    private let watchersCountLabel = UILabel.autolayoutView()
    private let issuesImageView = UIImageView.autolayoutView()
    private let issuesCountLabel = UILabel.autolayoutView()
    private let forkImageView = UIImageView.autolayoutView()
    private let forkCountLabel = UILabel.autolayoutView()

    private var repository: Repository?

    weak var delegate: RepositoryTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()

        let ownerTap = UITapGestureRecognizer(target: self, action: #selector(ownerTapped))
        ownerStackView.addGestureRecognizer(ownerTap)
        ownerStackView.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        repository = nil
        ownerAvatarImageView.image = nil
    }
}

// MARK: - Public methods
extension RepositoryTableViewCell {

    func setRepository(_ repository: Repository, index: Int) {
        self.repository = repository
        
        countLabel.text = "\(index + 1)."
        repositoryNameLabel.text = repository.name

        forkImageView.image = UIImage(named: "fork")
        forkCountLabel.text = "\(repository.forks) \("fork".localized())\(repository.forks == 1 ? "" : "s")"

        issuesImageView.image = UIImage(named: "issues")
        issuesCountLabel.text = "\(repository.issues) \("issue".localized())\(repository.issues == 1 ? "" : "s")"

        watchersImageView.image = UIImage(named: "eye")
        watchersCountLabel.text = "\(repository.watchers) \("watcher".localized())\(repository.watchers == 1 ? "" : "s")"

        guard let owner = repository.owner else { return }

        ownerAvatarImageView.kf.indicatorType = .activity
        ownerNameLabel.text = owner.username

        guard let avatarUrl = owner.avatarUrl else { return }
        ownerAvatarImageView.kf.setImage(with: avatarUrl)
    }
}

// MARK: - Private methods
extension RepositoryTableViewCell {

    @objc private func ownerTapped() {
        guard let owner = repository?.owner else { return }
        delegate?.ownerTapped(owner: owner)
    }
}

// MARK: - ViewLifecycle
extension RepositoryTableViewCell: ViewLifecycle {

    func setupViews() {
        backgroundColor = .white

        addSubview(countLabel)
        countLabel.font = UIFont.systemFont(ofSize: 14)
        countLabel.textColor = .lightGray
        countLabel.textAlignment = .center

        addSubview(repositoryNameLabel)
        repositoryNameLabel.font = UIFont.systemFont(ofSize: 18)
        repositoryNameLabel.textColor = .black
        repositoryNameLabel.numberOfLines = 2

        addSubview(ownerStackView)
        ownerStackView.axis = .horizontal
        ownerStackView.spacing = 5

        ownerStackView.addArrangedSubview(ownerAvatarImageView)
        ownerAvatarImageView.image = UIImage()
        ownerAvatarImageView.clipsToBounds = true
        ownerAvatarImageView.layer.cornerRadius = 5
        ownerAvatarImageView.layer.borderWidth = 2
        ownerAvatarImageView.layer.borderColor = UIColor.repoSearchGray.cgColor

        ownerStackView.addArrangedSubview(ownerNameLabel)
        ownerNameLabel.font = UIFont.systemFont(ofSize: 17)
        ownerNameLabel.textColor = .repoSearchGray

        addSubview(forkImageView)
        forkImageView.image = UIImage(named: "fork")
        forkImageView.contentMode = .scaleAspectFit
        forkImageView.tintColor = .gray

        addSubview(forkCountLabel)
        forkCountLabel.font = UIFont.systemFont(ofSize: 12)
        forkCountLabel.textColor = .gray

        addSubview(issuesImageView)
        issuesImageView.image = UIImage(named: "issue")
        issuesImageView.contentMode = .scaleAspectFit
        issuesImageView.tintColor = .gray

        addSubview(issuesCountLabel)
        issuesCountLabel.font = UIFont.systemFont(ofSize: 12)
        issuesCountLabel.textColor = .gray

        addSubview(watchersImageView)
        watchersImageView.image = UIImage(named: "eye")
        watchersImageView.contentMode = .scaleAspectFit
        watchersImageView.tintColor = .gray

        addSubview(watchersCountLabel)
        watchersCountLabel.font = UIFont.systemFont(ofSize: 12)
        watchersCountLabel.textColor = .gray
    }

    func setupConstraints() {
        countLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.width.equalTo(30)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

        repositoryNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(countLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-10)
            make.top.equalToSuperview().offset(8)
        }

        ownerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(repositoryNameLabel.snp.leading)
            make.height.equalTo(25)
            make.trailing.equalTo(-10)
        }

        ownerAvatarImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
        }

        watchersImageView.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom)
            make.leading.equalTo(repositoryNameLabel.snp.leading)
            make.height.width.equalTo(24)
            make.bottom.equalToSuperview().offset(-8)
        }

        watchersCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom).offset(5)
            make.leading.equalTo(watchersImageView.snp.trailing)
        }

        forkImageView.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom).offset(5)
            make.leading.greaterThanOrEqualTo(watchersCountLabel.snp.trailing).offset(10)
            make.height.width.equalTo(15)
        }

        forkCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom).offset(5)
            make.leading.equalTo(forkImageView.snp.trailing).offset(5)
            make.leading.equalTo(self.snp.centerX).offset(10)
        }

        issuesImageView.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom).offset(5)
            make.leading.greaterThanOrEqualTo(forkCountLabel.snp.trailing).offset(10)
            make.height.width.equalTo(15)
        }

        issuesCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom).offset(5)
            make.leading.equalTo(issuesImageView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(-15)
        }
    }
}
