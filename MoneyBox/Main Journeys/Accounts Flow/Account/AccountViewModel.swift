//
//  AccountViewModel.swift
//  MoneyBox
//
//  Created by Thecafremo on 19/09/2023.
//

import Foundation
import Networking

struct AccountViewModel {
    
    let planValueTextSource: TextSource
    let moneyboxTextSource: TextSource
    
    let buttonTextSource: TextSource
        
    let isButtonEnabled: Bool
    let buttonAlpha: Double
    
    let isActivityIndicatorHidden: Bool
}

//MARK: - Builders.

extension AccountViewModel {
    
    static func buildFor(productResponse: ProductResponse,
                         updatedMoneyBox: Double?,
                         numberFormatter: NumberFormatter,
                         isLoading: Bool) -> AccountViewModel {
        
        let planValueString = numberFormatter.currencyString(for: productResponse.planValue)
        let moneyboxString = numberFormatter.currencyString(for: updatedMoneyBox ?? productResponse.moneybox)
        
        let buttonTextSource: TextSource = isLoading ? .literal(" ") : .localized(key: "Add £10") // TODO: Change to a proper key and add a Localizable file. The String "£10" should be formatted, too.
        
        //TODO: This should be moved to a subclass of `UIButton` to handle it automatically.
        
        let isButtonEnabled = isLoading == false
        let buttonAlpha = isButtonEnabled ? 1 : 0.7
        let isActivityIndicatorHidden = isLoading == false
        
        return .init(planValueTextSource: .literal("Plan value: " + planValueString), //TODO: These should be localised.
                     moneyboxTextSource: .literal("Moneybox: " + moneyboxString),
                     buttonTextSource: buttonTextSource,
                     isButtonEnabled: isButtonEnabled,
                     buttonAlpha: buttonAlpha,
                     isActivityIndicatorHidden: isActivityIndicatorHidden)
    }
}
