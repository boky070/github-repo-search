//
//  UserDetailsViewController.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 29/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit
import SafariServices

struct UserItem {
    let title: String
    let value: String
}

protocol UserDetailsDisplayLogic: class {
    func displayUser(_ owner: Owner)
}

class UserDetailsViewController: UIViewController {
    
    var interactor: UserDetailsBusinessLogic?
    var router: (NSObjectProtocol & UserDetailsDataPassing)?

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UIView()
    private let headerImageView = UIImageView()
    private let headerImageViewHeight: CGFloat = 300

    private var githubUrl: URL?
    private var items: [UserItem] = []

    // MARK: Object lifecycle
    init(owner: Owner) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = UserDetailsInteractor()
        let presenter = UserDetailsPresenter()
        let router = UserDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        interactor?.fetchUser()
    }
}

// MARK: - Display Logic
extension UserDetailsViewController: UserDetailsDisplayLogic {

    func displayUser(_ owner: Owner) {
        self.githubUrl = owner.htmlUrl
        title = owner.name ?? ""
        items = []

        items.append(UserItem(title: "username".localized(), value: owner.username))
        if let email = owner.email {
            items.append(UserItem(title: "email".localized(), value: email))
        }
        if let location = owner.location {
            items.append(UserItem(title: "location".localized(), value: location))
        }
        if let bio = owner.bio {
            items.append(UserItem(title: "bio".localized(), value: bio))
        }
        if let company = owner.company {
            items.append(UserItem(title: "company".localized(), value: company))
        }
        if let publicRepos = owner.publicRepos {
            items.append(UserItem(title: "public_repos".localized(), value: "\(publicRepos)"))
        }
        if let publicGists = owner.publicGists {
            items.append(UserItem(title: "public_gists".localized(), value: "\(publicGists)"))
        }
        if let followers = owner.followers {
            items.append(UserItem(title: "followers".localized(), value: "\(followers)"))
        }
        if let following = owner.following {
            items.append(UserItem(title: "following".localized(), value: "\(following)"))
        }
        if let createdAt = owner.createdAt {
            items.append(UserItem(title: "created_at".localized(), value: createdAt.getDateString()))
        }
        if let updatedAt = owner.updatedAt {
            items.append(UserItem(title: "updated_at".localized(), value: updatedAt.getDateString()))
        }

        guard let avatarUrl = owner.avatarUrl else { return }
        headerImageView.kf.setImage(with: avatarUrl)
        tableView.reloadData()
    }
}

// MARK: - UIStyling
extension UserDetailsViewController: UIStyling {

    func setupViews() {
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UserDetailsTableViewCell.self, forCellReuseIdentifier: "UserDetailsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.repoSearchGray.withAlphaComponent(0.5)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerImageViewHeight)
        headerView.clipsToBounds = true
        headerImageView.frame = headerView.frame
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.kf.indicatorType = .activity
        headerImageView.image = UIImage(named: "placeholder")
        headerView.addSubview(headerImageView)
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerImageViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: headerImageViewHeight)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Table view
extension UserDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == items.count {
            let cell = UITableViewCell()
            cell.textLabel?.text = "show_details".localized()
            cell.textLabel?.isUserInteractionEnabled = false
            cell.accessoryType = .disclosureIndicator
            return cell
        }

        let cell = tableView.dequeueReusableCell(ofType: UserDetailsTableViewCell.self, for: indexPath)
        cell.setUserItem(items[indexPath.row])
        return cell
    }
}

extension UserDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == items.count else { return }

        tableView.deselectRow(at: indexPath, animated: false)
        guard let url = githubUrl else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var headerRect = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerImageViewHeight)
        
        let yPosition = scrollView.contentOffset.y
        if yPosition < 0 {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        } else {
            headerRect.origin.y = tableView.contentOffset.y / 2
        }

        headerView.frame = headerRect
    }
}
