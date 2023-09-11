//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Foundation

struct LoginViewModel {
    
    //MARK: - Properties.
    
    let primaryTextFieldPlaceholderTextSource: TextSource
    let secondaryTextFieldPlaceholderTextSource: TextSource
    
    let primaryButtonTextSource: TextSource
    
    let isPrimaryButtonEnabled: Bool
    let primaryButtonAlpha: Double
    
    let isPrimaryButtonHidden: Bool
    let isActivityIndicatorHidden: Bool
    
    let promptLabelTextSource: TextSource
    let isPromptContainerViewHidden: Bool
}

//MARK: - Builders.

extension LoginViewModel {
    
    static func buildForData(email: String?,
                             password: String?,
                             isLoading: Bool,
                             error: Error?) -> LoginViewModel {
        
        let primaryButtonTextSource: TextSource = isLoading ? .literal(" ") : .localized(key: "Log in") // TODO: Change to a proper key and add a Localizable file.
                
        let isPrimaryButtonEnabled = isLoading == false && (email != nil && password != nil)
        let primaryButtonAlpha = isPrimaryButtonEnabled ? 1 : 0.7
        
        let isPrimaryButtonHidden = isLoading
        let isActivityIndicatorHidden = isLoading == false
        
        let promptLabelTextSource: TextSource = (error != nil) ? .literal(error!.localizedDescription) : .literal("")
        
        return .init(primaryTextFieldPlaceholderTextSource: .localized(key: "Email"),
                     secondaryTextFieldPlaceholderTextSource: .localized(key: "Password"),
                     primaryButtonTextSource: primaryButtonTextSource,
                     isPrimaryButtonEnabled: isPrimaryButtonEnabled,
                     primaryButtonAlpha: primaryButtonAlpha,
                     isPrimaryButtonHidden: isPrimaryButtonHidden,
                     isActivityIndicatorHidden: isActivityIndicatorHidden,
                     promptLabelTextSource: promptLabelTextSource,
                     isPromptContainerViewHidden: (error == nil))
    }
}
