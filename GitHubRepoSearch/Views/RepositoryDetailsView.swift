//
//  RepositoryDetailsView.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 21/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

protocol RepositoryDetailsViewDelegate: class {
    func ownerTapped(owner: Owner)
}

class RepositoryDetailsView: UIView {

    private let ownerStackView =  UIStackView.autolayoutView()
    private let ownerAvatarImageView = UIImageView.autolayoutView()
    private let ownerNameLabel = UILabel.autolayoutView()
    private let nameLabel = UILabel.autolayoutView()
    private let descriptionLabel = UILabel.autolayoutView()
    private let starImageView = UIImageView.autolayoutView()
    private let starsCountLabel = UILabel.autolayoutView()
    private let forkImageView = UIImageView.autolayoutView()
    private let forkCountLabel = UILabel.autolayoutView()
    private let issuesLabel = UILabel.autolayoutView()
    private let issuesCountLabel = UILabel.autolayoutView()
    private let watchersLabel = UILabel.autolayoutView()
    private let watchersCountLabel = UILabel.autolayoutView()
    private let languageLabel = UILabel.autolayoutView()
    private let repoLanguageLabel = UILabel.autolayoutView()
    private let createdLabel = UILabel.autolayoutView()
    private let createdAtLabel = UILabel.autolayoutView()
    private let updatedLabel = UILabel.autolayoutView()
    private let updatedAtLabel = UILabel.autolayoutView()

    private var repository: Repository?

    weak var delegate: RepositoryDetailsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

        let ownerTap = UITapGestureRecognizer(target: self, action: #selector(ownerTapped))
        ownerStackView.addGestureRecognizer(ownerTap)
        ownerStackView.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension RepositoryDetailsView {

    func setRepository(_ repository: Repository) {
        self.repository = repository
        
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        starsCountLabel.text = "\(repository.stars) \("star".localized())\(repository.stars == 1 ? "" : "s")"
        forkCountLabel.text = "\(repository.forks) \("fork".localized())\(repository.forks == 1 ? "" : "s")"

        issuesLabel.text = "issues".localized()
        issuesCountLabel.text = "\(repository.issues)"
        watchersLabel.text = "watchers".localized()
        watchersCountLabel.text = "\(repository.watchers)"
        languageLabel.text = "language".localized()
        repoLanguageLabel.text = repository.language
        createdLabel.text = "created_at".localized()
        createdAtLabel.text = "\(repository.updatedAt != nil ? repository.createdAt!.getDateString() : "")"
        updatedLabel.text = "updated_at".localized()
        updatedAtLabel.text = "\(repository.updatedAt != nil ? repository.updatedAt!.getDateString() : "")"

        guard let owner = repository.owner else { return }

        ownerAvatarImageView.kf.indicatorType = .activity
        ownerNameLabel.text = owner.username
        guard let avatarUrl = owner.avatarUrl else { return }
        ownerAvatarImageView.kf.setImage(with: avatarUrl)
    }
}

// MARK: - Private methods
extension RepositoryDetailsView {

    @objc private func ownerTapped() {
        guard let owner = repository?.owner else { return }
        delegate?.ownerTapped(owner: owner)
    }
}

// MARK: - ViewLifecycle
extension RepositoryDetailsView: ViewLifecycle {
    func setupViews() {

        backgroundColor = .white

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

        addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 3

        addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 6

        addSubview(starImageView)
        starImageView.image = UIImage(named: "star")
        starImageView.contentMode = .scaleAspectFit
        starImageView.tintColor = .repoSearchGray

        addSubview(starsCountLabel)
        starsCountLabel.font = UIFont.systemFont(ofSize: 15)
        starsCountLabel.textColor = .black

        addSubview(forkImageView)
        forkImageView.image = UIImage(named: "fork")
        forkImageView.contentMode = .scaleAspectFit
        forkImageView.tintColor = .repoSearchGray

        addSubview(forkCountLabel)
        forkCountLabel.font = UIFont.systemFont(ofSize: 15)
        forkCountLabel.textColor = .black

        addSubview(issuesLabel)
        issuesLabel.font = UIFont.systemFont(ofSize: 15)
        issuesLabel.textColor = .gray

        addSubview(issuesCountLabel)
        issuesCountLabel.font = UIFont.systemFont(ofSize: 15)
        issuesCountLabel.textColor = .black

        addSubview(watchersLabel)
        watchersLabel.font = UIFont.systemFont(ofSize: 15)
        watchersLabel.textColor = .gray

        addSubview(watchersCountLabel)
        watchersCountLabel.font = UIFont.systemFont(ofSize: 15)
        watchersCountLabel.textColor = .black

        addSubview(languageLabel)
        languageLabel.font = UIFont.systemFont(ofSize: 15)
        languageLabel.textColor = .gray

        addSubview(repoLanguageLabel)
        repoLanguageLabel.font = UIFont.systemFont(ofSize: 15)
        repoLanguageLabel.textColor = .black

        addSubview(createdLabel)
        createdLabel.font = UIFont.systemFont(ofSize: 15)
        createdLabel.textColor = .gray

        addSubview(createdAtLabel)
        createdAtLabel.font = UIFont.systemFont(ofSize: 15)
        createdAtLabel.textColor = .black

        addSubview(updatedLabel)
        updatedLabel.font = UIFont.systemFont(ofSize: 15)
        updatedLabel.textColor = .gray

        addSubview(updatedAtLabel)
        updatedAtLabel.font = UIFont.systemFont(ofSize: 15)
        updatedAtLabel.textColor = .black
    }

    func setupConstraints() {
        ownerStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(20)
            make.height.equalTo(25)
            make.trailing.equalTo(-10)
        }

        ownerAvatarImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ownerStackView.snp.bottom).offset(10)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }

        starImageView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(19)
            make.leading.equalTo(20)
            make.height.width.equalTo(20)
        }

        starsCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(starImageView.snp.trailing).offset(5)
        }

        forkImageView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(starsCountLabel.snp.trailing).offset(20)
            make.height.width.equalTo(18)
        }

        forkCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(forkImageView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(-20)
        }

        issuesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starImageView.snp.bottom).offset(19)
            make.leading.equalTo(20)
        }

        issuesCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(issuesLabel.snp.top)
            make.leading.greaterThanOrEqualTo(issuesLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-20)
        }

        watchersLabel.snp.makeConstraints { (make) in
            make.top.equalTo(issuesLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
        }

        watchersCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(watchersLabel.snp.top)
            make.leading.greaterThanOrEqualTo(watchersLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-20)
        }

        languageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(watchersLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
        }

        repoLanguageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(languageLabel.snp.top)
            make.leading.greaterThanOrEqualTo(languageLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-20)
        }

        createdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(languageLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
        }

        createdAtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(createdLabel.snp.top)
            make.leading.greaterThanOrEqualTo(createdLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-20)
        }

        updatedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(createdLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
        }

        updatedAtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(updatedLabel.snp.top)
            make.leading.greaterThanOrEqualTo(updatedLabel.snp.trailing).offset(8)
            make.trailing.equalTo(-20)
        }
    }
}
