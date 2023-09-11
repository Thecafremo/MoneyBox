//
//  main.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 11/09/2023.
//

import UIKit

// MARK: - Private Methods.

private func delegateClassName() -> String? {
    
    if NSClassFromString("XCTestCase") != nil {
        return nil
    }
    
    return NSStringFromClass(AppDelegate.self)
}

// MARK: - UIApplicationMain.

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName())



