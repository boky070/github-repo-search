//
//  RepositoryDetailsViewController.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit
import SafariServices

protocol RepositoryDetailsDisplayLogic: class {
    func displayRepository(_ repository: Repository)
    func displayError(_ error: HttpClientError)
}

class RepositoryDetailsViewController: UIViewController {

    var interactor: RepositoryDetailsBusinessLogic?
    var router: (NSObjectProtocol & RepositoryDetailsRoutingLogic & RepositoryDetailsDataPassing)?

    var repository: Repository?

    private let repositoryDetailsView = RepositoryDetailsView.autolayoutView()
    private let showDetailsButton = UIButton.autolayoutView()

    // MARK: Object lifecycle
    init() {
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
        let interactor = RepositoryDetailsInteractor()
        let presenter = RepositoryDetailsPresenter()
        let router = RepositoryDetailsRouter()
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
        interactor?.fetchRepository()
    }
}

// MARK: - Display Logic
extension RepositoryDetailsViewController: RepositoryDetailsDisplayLogic {
    
    func displayRepository(_ repository: Repository) {
        self.repository = repository
        repositoryDetailsView.delegate = self
        repositoryDetailsView.setRepository(repository)
    }
    
    func displayError(_ error: HttpClientError) {
        let alert = UIAlertController(title: "general_error".localized(), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private Methods
private extension RepositoryDetailsViewController {

    @objc private func showRepositoryOnline(sender: UIButton!) {
        guard let repository = repository else { return }
        let safariVC = SFSafariViewController(url: repository.htmlUrl)
        present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - UIStyling
extension RepositoryDetailsViewController: UIStyling {

    func setupViews() {
        navigationItem.title = "repository".localized()

        view.backgroundColor = .white
        view.addSubview(repositoryDetailsView)

        view.addSubview(showDetailsButton)
        showDetailsButton.setTitle("show_details".localized(), for: .normal)
        showDetailsButton.backgroundColor = .repoSearchGray
        showDetailsButton.tintColor = .white
        showDetailsButton.layer.cornerRadius = 5
        showDetailsButton.addTarget(self, action: #selector(showRepositoryOnline), for: .touchUpInside)
    }

    func setupConstraints() {
        repositoryDetailsView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.leading.trailing.equalToSuperview()
        }

        showDetailsButton.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryDetailsView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(45)
            make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
        }
    }
}

// MARK: - RepositoryDetailsViewDelegate
extension RepositoryDetailsViewController: RepositoryDetailsViewDelegate {
    func ownerTapped(owner: Owner) {
        router?.navigateToUserDetails(owner: owner)
    }
}
