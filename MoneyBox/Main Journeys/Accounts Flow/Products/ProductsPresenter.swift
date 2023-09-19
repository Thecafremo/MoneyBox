//
//  ProductPresenter.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 12/09/2023.
//

import Networking
import Foundation

final class ProductsPresenter {
    
    //MARK: - Properties.
    
    private weak var view: ProductsDisplayable?
    private weak var delegate: ProductsPresenterDelegate?
    
    private let dataProvider: DataProviderLogic
    private let username: String?
    private let numberFormatter: NumberFormatter
    
    private var isLoading = false
    private var productResponses: [ProductResponse]?
    
    //MARK: - Life Cycle.
    
    init(view: ProductsDisplayable, dataProvider: DataProviderLogic, username: String?, numberFormatter: NumberFormatter, delegate: ProductsPresenterDelegate) {
        
        self.view = view
        self.delegate = delegate
        
        self.dataProvider = dataProvider
        self.username = username
        self.numberFormatter = numberFormatter
    }
}

//MARK: - Internal Methods.

extension ProductsPresenter {
    
    func viewDidLoad() {
        getProductResponses()
    }
    
    func viewDidAppear() {
        //TODO: Add analytics.
    }
    
    @objc func viewDidPushToRefresh() {
        getProductResponses()
    }
    
    func viewDidSelectRow(at index: Int) {
        
        guard let productResponses else {
            return
        }
        
        delegate?.productsPresenter(self,
                                    didSelectProductResponse: productResponses[index],
                                    withRefreshClosure: { [weak self] (needsRefreshing: Bool) in
            
            if needsRefreshing {
                self?.getProductResponses()
            }
        })
    }
}

//MARK: - Private Methods.

extension ProductsPresenter {
    
    private func populateView(error: Error? = nil) {
        
        if let error {
            view?.populate(with: .buildForError(error, username: username))
            return
        }
        
        view?.populate(with: .buildForData(productResponses: productResponses,
                                           username: username,
                                           numberFormatter: numberFormatter,
                                           isLoading: isLoading))
    }
    
    private func getProductResponses() {
        
        isLoading = true
        populateView()
        
        dataProvider.fetchProducts { [weak self] (result: Result<AccountResponse, Error>) in
            
            self?.isLoading = false
            
            switch result {
            case .success(let accountResponse):
                self?.productResponses = accountResponse.productResponses
                self?.populateView()
                
            case .failure(let error):
                self?.populateView(error: error)
            }
        }
    }
}


//MARK: - Definitions.

protocol ProductsPresenterDelegate: AnyObject {
    
    func productsPresenter(_ presenter: ProductsPresenter, didSelectProductResponse productResponse: ProductResponse, withRefreshClosure refreshClosure: @escaping ((Bool) -> Void))
    
}
