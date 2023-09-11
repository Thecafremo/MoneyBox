//
//  LoginFlowCoordinator.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Networking
import UIKit

final class LoginFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties.
    
    var navigationController: UINavigationController
    
    private let assetProvider: AssetProviderProtocol
    private let dataProvider: DataProviderLogic
    private let emailValidator: EmailValidatorProtocol
    private let theme: Theme
    
    //MARK: – Life Cycle.
    
    init(assetProvider: AssetProviderProtocol, dataProvider: DataProviderLogic, emailValidator: EmailValidatorProtocol, theme: Theme) {
        
        self.assetProvider = assetProvider
        self.dataProvider = dataProvider
        self.emailValidator = emailValidator
        self.theme = theme
        
        self.navigationController = UINavigationController()
        self.navigationController.modalPresentationStyle = .fullScreen
        
        pushLoginViewController()
    }
}

//MARK: - Private Methods.

extension LoginFlowCoordinator {
    
    private func pushLoginViewController() {
        
        let loginViewController = LoginViewController()
        loginViewController.assetProvider = assetProvider
        loginViewController.theme = theme
        loginViewController.presenter = LoginPresenter(view: loginViewController,
                                                       dataProvider: dataProvider,
                                                       emailValidator: emailValidator,
                                                       delegate: self)
        
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

//MARK: - LoginPresenterDelegate.

extension LoginFlowCoordinator: LoginPresenterDelegate {
    
    func loginPresenter(_ loginPresenter: LoginPresenter, didFinishWithLoginResponse loginResponse: LoginResponse) {
        
    }
}
