//
//  AppDelegate.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 11/09/2023.
//

import UIKit

class AppDelegate: UIResponder {
    
    //MARK: – Properties.
        
    private var appCoordinator: AppCoordinator!
}

//MARK: - UIApplicationDelegate.

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator = AppCoordinator(forScreen: UIScreen.main)
        appCoordinator.start()
        
        return true
    }
}
