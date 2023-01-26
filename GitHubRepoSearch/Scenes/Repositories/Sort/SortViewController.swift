//
//  SortViewController.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 30/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import UIKit

protocol SortViewControllerDelegate: class {
    func didUpdateSortOptions(sortBy: SortType, order: SortType)
}

protocol SortDisplayLogic: class {
    func displaySortOptions(_ sortOptions: [SortSection])
}

class SortViewController: UIViewController {

    var interactor: SortBusinessLogic?

    let tableView = UITableView(frame: .zero, style: .plain)
    private var data: [SortSection] = []

    private let defaults = UserDefaults.standard

    weak var delegate: SortViewControllerDelegate?
    var sortBy: SortType = .bestMatch
    var order: SortType = .desc

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
        let interactor = SortInteractor()
        let presenter = SortPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        interactor?.fetchSortOptions(sortBy: sortBy, order: order)
    }
}

// MARK: - Display Logic
extension SortViewController: SortDisplayLogic {

    func displaySortOptions(_ sortOptions: [SortSection]) {
        data = sortOptions
        tableView.reloadData()
    }
}

// MARK: - Private Methods
private extension SortViewController {

    @objc private func saveSortOptions() {
        delegate?.didUpdateSortOptions(sortBy: sortBy, order: order)
        dismiss(animated: true, completion: nil)
    }

    @objc private func dismissSortView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIStyling
extension SortViewController: UIStyling {

    func setupViews() {
        title = "sort".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "general_cancel".localized(), style: .plain, target: self, action: #selector(dismissSortView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save".localized(), style: .plain, target: self, action: #selector(saveSortOptions))
        
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
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Table view
extension SortViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section].items[indexPath.row]
        let cell = UITableViewCell()
        cell.tintColor = .gray
        cell.textLabel?.text = data[indexPath.section].items[indexPath.row].title.localized()
        cell.textLabel?.isUserInteractionEnabled = false
        cell.accessoryType = item.value ? .checkmark : .none
        return cell
    }
}

extension SortViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 15, width: tableView.frame.width - 30, height: 70))
        titleLabel.text = data[section].title
        titleLabel.textColor = .gray
        view.addSubview(titleLabel)
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let section = indexPath.section
        for itemIndex in 0..<data[indexPath.section].items.count {
            data[section].items[itemIndex].value = false
        }

        let selectedItem = data[section].items[indexPath.row]
        data[section].items[indexPath.row].value = true
        if section == 0 {
            sortBy = selectedItem.type
        } else {
            order = selectedItem.type
        }
        self.defaults.set(sortBy.rawValue, forKey: "repo_sort_by")
        self.defaults.set(order.rawValue, forKey: "repo_order")
        tableView.reloadData()
    }
}
