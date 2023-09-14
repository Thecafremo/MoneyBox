//
//  AppCoordinator.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 11/09/2023.
//

import Networking
import UIKit

final class AppCoordinator {
    
    // MARK: - Properties.
    
    private let window: UIWindow
    
    private let assetProvider: AssetProviderProtocol
    private let dataProvider: DataProviderLogic
    private let theme: Theme //TODO: This should be a protocol. 
    
    private var childFlowCoordinators = [FlowCoordinator]()
    
    private lazy var numberFormmater: NumberFormatter = { //TODO: This should have a class of its own, handling multiple currencies, if needed.
       
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.autoupdatingCurrent
        formatter.currencyCode = "GBP" //TODO: This should be coming from the BE, as part of the Product / Account information.
        
        return formatter
    }()
        
    //MARK: - Life Cycle.
    
    init(forScreen screen: UIScreen) {
        
        self.window = UIWindow(frame: screen.bounds)
        
        self.assetProvider = AssetProvider()
        self.dataProvider = DataProvider()
        self.theme = Theme()
    }
}

//MARK: - Internal Methods.

extension AppCoordinator {
    
    func start() {
        
        configureAppearance()
        
        displayLoginJourney(on: window)
        window.makeKeyAndVisible()
    }
}

//MARK: - Private Methods.

extension AppCoordinator {
    
    private func configureAppearance() {
        
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        
        let navBarAppearanceProxy = UINavigationBar.appearance()
        navBarAppearanceProxy.titleTextAttributes = textAttributes
        navBarAppearanceProxy.largeTitleTextAttributes = textAttributes
        navBarAppearanceProxy.tintColor = .black
    }
    
    private func displayLoginJourney(on window: UIWindow) {
        
        let loginFlowCoordinator = LoginFlowCoordinator(assetProvider: assetProvider,
                                                        dataProvider: dataProvider,
                                                        emailValidator: EmailValidator(), 
                                                        theme: theme,
                                                        delegate: self)
        
        
        window.rootViewController = loginFlowCoordinator.navigationController
        childFlowCoordinators.append(loginFlowCoordinator)
    }
    
    private func displayMainJourney(on window: UIWindow, username: String?) {
        
        dismissAnyPresentedFlowCoordinators()
        
        let productsFlowCoordinator = ProductsFlowCoordinator(assetProvider: assetProvider,
                                                              dataProvider: dataProvider,
                                                              theme: theme,
                                                              numberFormatter: numberFormmater,
                                                              username: username,
                                                              delegate: self)
        
        window.rootViewController = productsFlowCoordinator.navigationController
        childFlowCoordinators.append(productsFlowCoordinator)
    }
}

//MARK: – LoginFlowCoordinatorDelegate.

extension AppCoordinator: LoginFlowCoordinatorDelegate {
    
    func loginFlowCoordinator(_ flowCoordinator: LoginFlowCoordinator, didFinishWithLoginResponse loginResponse: LoginResponse) {
        
        Authentication.token = loginResponse.session.bearerToken //TODO: The DataProvider should have a delegate to handle 401s and 403s.
        displayMainJourney(on: window, username: loginResponse.user.firstName)
    }
}

//MARK: – ProductsFlowCoordinatorDelegate.

extension AppCoordinator: ProductsFlowCoordinatorDelegate {
    
}


//MARK: - Helper Methods.

extension AppCoordinator {
    
    private func dismissAnyPresentedFlowCoordinators() {
        childFlowCoordinators.forEach { dismiss($0) }
    }
    
    private func dismiss(_ flowCoordinator: FlowCoordinator, animated: Bool = true) {
        
        flowCoordinator.navigationController.dismiss(animated: animated) {
            self.childFlowCoordinators.removeAll { $0 === flowCoordinator }
        }
    }
}
