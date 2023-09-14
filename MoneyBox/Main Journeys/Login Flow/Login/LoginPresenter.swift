//
//  LoginPresenter.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Foundation
import Networking

final class LoginPresenter {
    
    //MARK: - Properties.
    
    private weak var view: LoginDisplayable?
    private weak var delegate: LoginPresenterDelegate?
    
    private let dataProvider: DataProviderLogic
    private let emailValidator: EmailValidatorProtocol
    
    private var email: String?
    private var password: String?
    
    //MARK: - Life Cycle.
    
    init(view: LoginDisplayable, dataProvider: DataProviderLogic, emailValidator: EmailValidatorProtocol, delegate: LoginPresenterDelegate) {
        
        self.view = view
        self.delegate = delegate

        self.dataProvider = dataProvider
        self.emailValidator = emailValidator
    }
}

//MARK: - Internal Methods.

extension LoginPresenter {
    
    func viewDidLoad() {
        updateView(isLoading: false)
    }
    
    func viewDidAppear() {
        //TODO: Add Analytics.
    }
    
    func viewDidChangePrimaryTextFieldText(_ text: String?) {
        
        email = text
        updateView(isLoading: false)
    }
    
    func viewDidChangeSecondaryTextFieldText(_ text: String?) {
        
        password = text
        updateView(isLoading: false)
    }
    
    func viewDidPressPrimaryButton() {
        
        updateView(isLoading: true)
        
        guard let email, let password else {
            return
        }
        
        guard emailValidator.isValidEmail(email) else {
            updateView(isLoading: false, error: GenericError.withMessage("Error: Invalid email format."))
            return
        }
        
        let loginRequest = LoginRequest.init(email: email, password: password)
        
        dataProvider.login(request: loginRequest) { [weak self] (result: Result<LoginResponse, Error>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let loginResponse):
                self.delegate?.loginPresenter(self, didFinishWithLoginResponse: loginResponse)
                
            case .failure(let error):
                self.updateView(isLoading: false, error: error)
            }
        }
    }
}

//MARK: – Private Methods.

extension LoginPresenter {
    
    private func updateView(isLoading: Bool, error: Error? = nil) {
        
        view?.populate(with: .buildForData(email: email,
                                           password: password,
                                           isLoading: isLoading,
                                           error: error))
    }
}

//MARK: - Definitions.

protocol LoginPresenterDelegate: AnyObject {
    
    func loginPresenter(_ loginPresenter: LoginPresenter, didFinishWithLoginResponse loginResponse: LoginResponse)
}
