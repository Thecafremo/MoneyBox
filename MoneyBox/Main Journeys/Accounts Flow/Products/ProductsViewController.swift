//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 12/09/2023.
//

import UIKit

final class ProductsViewController: UIViewController {
    
    //MARK: - Properties.
    
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var headerSubTitleLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var cellViewModels = [ProductCellViewModel]()
    
    var presenter: ProductsPresenter?
    var assetProvider: AssetProviderProtocol! //TODO: Get these into an `init` method.
    var theme: Theme!
    
    //MARK: - Life Cycle.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureView()
        presenter?.viewDidLoad()
    }
}

//MARK: - ProductsDisplayable.

extension ProductsViewController: ProductsDisplayable {
    
    func populate(with viewModel: ProductsViewModel) {
        
        if viewModel.isActivityIndicatorHidden { //TODO: We would have a "shimmering" state for the initial loading.
            refreshControl.endRefreshing()
        }
        
        headerTitleLabel.text = String.from(viewModel.titleTextSource, assetProvider: assetProvider)
        headerSubTitleLabel.text = String.from(viewModel.subtitleTextSource, assetProvider: assetProvider)
        
        cellViewModels = viewModel.cellViewModels
        tableView.reloadData()
    }
}

//MARK: - Private Methods.

extension ProductsViewController {
    
    private func configureView() {
        
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 22) //TODO: This should be done without hardcoding a value, and to handle dynamic text.
        headerSubTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(presenter, action: #selector(presenter?.viewDidPushToRefresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        tableView.register(ProductTableViewCell.self)
        
        tableView.backgroundColor = .clear
    }
}

//MARK: – UITableViewDataSource.

extension ProductsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = cellViewModels[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath)
        (cell as? ProductTableViewCell)?.populate(with: cellViewModel, assetProvider: assetProvider, theme: theme)
        
        return cell
    }
}

//MARK: - UITableViewDelegate.

extension ProductsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.viewDidSelectRow(at: indexPath.row)
    }
}

//MARK: - Definitions.

protocol ProductsDisplayable: AnyObject {
    
    func populate(with viewModel: ProductsViewModel)
}
