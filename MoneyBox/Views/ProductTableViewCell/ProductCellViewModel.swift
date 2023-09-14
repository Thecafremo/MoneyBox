//
//  ProductCellViewModel.swift
//  MoneyBox
//
//  Created by Thecafremo on 12/09/2023.
//

import Networking
import Foundation

struct ProductCellViewModel {
    
    //MARK: - Properties.
    
    let titleTextSource: TextSource
    let planValueTextSource: TextSource
    let moneyboxTextSource: TextSource
    
    let accessoryImageSource = ImageSource.systemSymbol("greaterthan")
    
    let colorHex: String? //TODO: Ideally the colour wouldn't be sent from the BE, and in here we would just be providing a cell with a `Style`, and it would know which colour to use.
}

//MARK: - Builders.

extension ProductCellViewModel {
    
    static func buildForProduct(_ productResponse: ProductResponse, numberFormatter: NumberFormatter) -> ProductCellViewModel {
        
        let title = productResponse.product?.friendlyName //TODO: This should not be optional.
        let planValueString = numberFormatter.currencyString(for: productResponse.planValue)
        let moneyboxString = numberFormatter.currencyString(for: productResponse.moneybox)
        
        return .init(titleTextSource: .literal(title), 
                     planValueTextSource: .literal("Plan value: " + planValueString), //TODO: These should be localised.
                     moneyboxTextSource: .literal("Moneybox: " + moneyboxString),
                     colorHex: productResponse.product?.productHexCode)
    }
}

//MARK: - Helper Methods.

extension NumberFormatter {
    
    fileprivate func currencyString(for value: Double?) -> String {
        
        guard let value else {
            return " – "
        }
        
        return self.string(from: NSNumber(value: value)) ?? " – "
    }
}
