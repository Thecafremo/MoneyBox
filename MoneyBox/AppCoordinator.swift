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
    
    private func displayMainJourney(on window: UIWindow) {
        
//        let itemAPI = ItemAPI(requester: requester, baseURL: baseURL)
//        let userAPI = UserAPI(requester: requester, baseURL: baseURL)
//        
//        let dependencies = FileNavigationFlowCoordinator.Dependencies(itemAPI: itemAPI,
//                                                                      userAPI: userAPI,
//                                                                      assetProvider: assetProvider)
//        
//        let fileNavigationFlowCoordinator = FileNavigationFlowCoordinator(dependencies: dependencies, delegate: self)
//        
//        window.rootViewController = fileNavigationFlowCoordinator.navigationController
//        childFlowCoordinators.append(fileNavigationFlowCoordinator)
    }
}


//MARK: – LoginFlowCoordinatorDelegate.

extension AppCoordinator: LoginFlowCoordinatorDelegate {
    
    func loginFlowCoordinator(_ flowCoordinator: LoginFlowCoordinator, didFinishWithLoginResponse loginResponse: LoginResponse) {
        
        Authentication.token = loginResponse.session.bearerToken
        
    }
}
