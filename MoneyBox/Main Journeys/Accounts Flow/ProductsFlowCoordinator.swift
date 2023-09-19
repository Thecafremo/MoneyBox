//
//  AccountsFlowCoordinator.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 12/09/2023.
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
    
    private var refreshClosure: ((Bool) -> Void)?
    
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
    
    func productsPresenter(_ presenter: ProductsPresenter, didSelectProductResponse productResponse: ProductResponse, withRefreshClosure refreshClosure: @escaping ((Bool) -> Void)) {
        
        self.refreshClosure = refreshClosure
        
        let accountViewController = AccountViewController()
        accountViewController.title = productResponse.product?.friendlyName
        accountViewController.assetProvider = assetProvider
        accountViewController.theme = theme
        accountViewController.presenter = AccountPresenter(view: accountViewController,
                                                           dataProvider: dataProvider,
                                                           numberFormatter: numberFormatter,
                                                           productResponse: productResponse,
                                                           delegate: self)
        
        navigationController.pushViewController(accountViewController, animated: true)
    }
}

//MARK: – AccountPresenterDelegate.

extension ProductsFlowCoordinator: AccountPresenterDelegate {
    
    func accountPresenterDidSuccesfullyPerformAction(_ presenter: AccountPresenter) {
        refreshClosure?(true)
    }
}

//MARK: - Definitions.

protocol ProductsFlowCoordinatorDelegate: AnyObject {
    
}
