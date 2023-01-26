//
//  RepositoriesViewController.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 20/04/2020.
//  Copyright (c) 2020 UltraDev. All rights reserved.
//

import UIKit
import SnapKit

protocol RepositoriesDisplayLogic: class {
    func displayRepositories(_ repositories: [Repository], for page: Int)
    func displayError(_ error: HttpClientError)
}

class RepositoriesViewController: UIViewController {
    
    var interactor: RepositoriesBusinessLogic?
    var router: (NSObjectProtocol & RepositoriesRoutingLogic)?

    let defaults = UserDefaults.standard

    let searchController = UISearchController()
    let tableView = UITableView(frame: .zero, style: .plain)
    let infoLabel = UILabel.autolayoutView()
    let activityIndicator = UIActivityIndicatorView(frame: .zero)

    var repositories: [Repository] = []
    private var searchParam = ""
    private let pageSize = 30
    private var pageCounter = 1
    private var sortBy: SortType?
    private var order: SortType?
    private var isLoading = false

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.repoSearchGray

        return refreshControl
    }()

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = RepositoriesInteractor()
        let presenter = RepositoriesPresenter()
        let router = RepositoriesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

        if let detaultSortBy = defaults.string(forKey: "repo_sort_by") {
            sortBy = SortType(rawValue: detaultSortBy)
        }
        if let detaultOrder = defaults.string(forKey: "repo_order") {
            order = SortType(rawValue: detaultOrder)
        }
    }
}

// MARK: - Display Logic
extension RepositoriesViewController: RepositoriesDisplayLogic {

    func displayRepositories(_ repositories: [Repository], for page: Int) {
        isLoading = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()

        if page == 1 {
            self.repositories = repositories
            tableView.reloadData()
            refreshControl.endRefreshing()

            guard tableView.numberOfRows(inSection: 0) > 0 else {
                infoLabel.isHidden = false
                return
            }
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            infoLabel.isHidden = true
        } else {
            self.repositories.append(contentsOf: repositories)
            pageCounter = page
            tableView.reloadData()
        }
    }

    func displayError(_ error: HttpClientError) {
        isLoading = false
        infoLabel.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()

        let alert = UIAlertController(title: "general_error".localized(), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private Methods
private extension RepositoriesViewController {

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        pageCounter = 1
        loadDataFor(page: pageCounter)
    }

    func loadDataFor(page: Int) {
        if searchParam != "" {
            isLoading = true
            interactor?.fetchRepositoriesFor(searchParam: searchParam, page: page, sortBy: sortBy, order: order)
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
        }
    }

    @objc func showSortPage() {
        router?.showSortSettings(sortBy: sortBy ?? .bestMatch, order: order ?? .desc)
    }
}

// MARK: - UIStyling
extension RepositoriesViewController: UIStyling {
    func setupViews() {
        navigationItem.title = "repositories".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(showSortPage))

        view.backgroundColor = .white

        setupTableView()

        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "search".localized()

        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = .repoSearchGray
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        view.addSubview(infoLabel)
        infoLabel.font = UIFont.systemFont(ofSize: 17)
        infoLabel.numberOfLines = 2
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        infoLabel.isHidden = true
        infoLabel.text = "no_data_fount".localized()

        isLoading = false
        activityIndicator.color = .repoSearchGray
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: "RepositoryTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 92
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.repoSearchGray.withAlphaComponent(0.5)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.addSubview(refreshControl)
    }

    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - TableView
extension RepositoriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: RepositoryTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.setRepository(repositories[indexPath.row], index: indexPath.row)
        let pageNumber = indexPath.row / pageSize + 2
        if indexPath.row > 0, indexPath.row % pageSize == 5, pageCounter < pageNumber, !isLoading {
            loadDataFor(page: pageNumber)
        }
        return cell
    }
}

extension RepositoriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        router?.navigateToRepositoryDetails(repository: repositories[indexPath.row])
    }
}

// MARK: - Search Bar
extension RepositoriesViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
        searchParam = searchBar.text ?? ""
        pageCounter = 1
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        loadDataFor(page: pageCounter)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - RepositoryTableViewCellDelegate
extension RepositoriesViewController: RepositoryTableViewCellDelegate {

    func ownerTapped(owner: Owner) {
        router?.navigateToUserDetails(owner: owner)
    }
}

// MARK: - SortViewControllerDelegate
extension RepositoriesViewController: SortViewControllerDelegate {

    func didUpdateSortOptions(sortBy: SortType, order: SortType) {
        self.sortBy = sortBy
        self.order = order
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        pageCounter = 1
        loadDataFor(page: pageCounter)
    }
}
