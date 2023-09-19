//
//  AccountPresenter.swift
//  MoneyBox
//
//  Created by Thecafremo on 19/09/2023.
//

import Networking
import Foundation

final class AccountPresenter {
    
    //MARK: - Properties.
    
    private weak var view: AccountDisplayable?
    private weak var delegate: AccountPresenterDelegate?
    
    private let dataProvider: DataProviderLogic
    private let numberFormatter: NumberFormatter
    private let productResponse: ProductResponse
    
    private var updatedMoneyBox: Double? //JP: In no way this should be done like this, but the API is not returning the whole object, nor the Object allows a regular `init`.
    
    //MARK: - Life Cycle.
    
    init(view: AccountDisplayable, 
         dataProvider: DataProviderLogic,
         numberFormatter: NumberFormatter,
         productResponse: ProductResponse,
         delegate: AccountPresenterDelegate) {
        
        self.view = view
        self.delegate = delegate
        
        self.dataProvider = dataProvider
        self.numberFormatter = numberFormatter
        self.productResponse = productResponse
    }
}

//MARK: - Internal Methods.

extension AccountPresenter {
    
    func viewDidLoad() {
        populateView()
    }
    
    func viewDidAppear() {
        //TODO: Add analytics.
    }
    
    func viewDidPressButton() {
        
        guard let identifier = productResponse.id else { //JP: This shouldn't be optional.
            return
        }
        
        populateView(isLoading: true)
        
        let request = OneOffPaymentRequest(amount: 10, investorProductID: identifier)
        
        dataProvider.addMoney(request: request) { [weak self] (result: Result<OneOffPaymentResponse, Error>) in
       
            guard let self = self else { return }
            
            defer {
                self.populateView(isLoading: false)
            }
            
            switch result {
            case .success(let oneOffPaymentResponse): //JP: This should be returning the whole updated object.
                self.updatedMoneyBox = oneOffPaymentResponse.moneybox
                self.delegate?.accountPresenterDidSuccesfullyPerformAction(self)
                
            case .failure(let error):
                print(error) //TODO: Properly handle error.
            }
        }
    }
}

//MARK: - Private Methods.

extension AccountPresenter {
    
    func populateView(isLoading: Bool = false) {
        
        view?.populate(with: .buildFor(productResponse: productResponse,
                                       updatedMoneyBox: updatedMoneyBox,
                                       numberFormatter: numberFormatter,
                                       isLoading: isLoading))
    }
}

//MARK: - Definitions.

protocol AccountPresenterDelegate: AnyObject {
    
    func accountPresenterDidSuccesfullyPerformAction(_ presenter: AccountPresenter)
}
