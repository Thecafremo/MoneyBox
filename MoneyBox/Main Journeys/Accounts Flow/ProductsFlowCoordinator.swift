//
//  AccountsFlowCoordinator.swift
//  MoneyBox
//
//  Created by Thecafremo on 12/09/2023.
//

import UIKit
import Networking

final class ProductsFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties.
    
    var navigationController: UINavigationController
    
    private weak var delegate: ProductsFlowCoordinatorDelegate?

    private let assetProvider: AssetProviderProtocol
    private let dataProvider: DataProviderLogic
    private let theme: Theme
    private let numberFormatter: NumberFormatter
    
    //MARK: - Life Cycle.
    
    init(assetProvider: AssetProviderProtocol, dataProvider: DataProviderLogic, theme: Theme, numberFormatter: NumberFormatter, username: String?, delegate: ProductsFlowCoordinatorDelegate) {
        
        self.assetProvider = assetProvider
        self.dataProvider = dataProvider
        self.theme = theme
        self.numberFormatter = numberFormatter
        
        self.delegate = delegate

        self.navigationController = UINavigationController()
        self.navigationController.modalPresentationStyle = .fullScreen
        
        pushProductsViewController(with: username)
    }
}

//MARK: – Private Methods.

extension ProductsFlowCoordinator {
    
    private func pushProductsViewController(with username: String?) {
        
        let productsViewController = ProductsViewController()
        productsViewController.assetProvider = assetProvider
        productsViewController.theme = theme
        productsViewController.presenter = ProductsPresenter(view: productsViewController,
                                                             dataProvider: dataProvider,
                                                             username: username,
                                                             numberFormatter: numberFormatter,
                                                             delegate: self)
        
        navigationController.pushViewController(productsViewController, animated: true)
    }
}

//MARK: - ProductsPresenterDelegate.

extension ProductsFlowCoordinator: ProductsPresenterDelegate {
    
    func productsPresenter(_ presenter: ProductsPresenter, didSelectProductResponse productResponse: ProductResponse, withRefreshClosure refreshClosure: ((Bool) -> Void)) {
        //TODO: Implement, and push, next screen and appropriately call the `refreshClosure`.
    }
}

//MARK: - Definitions.

protocol ProductsFlowCoordinatorDelegate: AnyObject {
    
}
