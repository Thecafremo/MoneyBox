//
//  ProductsViewModel.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 12/09/2023.
//

import Networking
import UIKit

struct ProductsViewModel {
    
    //MARK: - Properties.
    
    let titleTextSource: TextSource
    let subtitleTextSource: TextSource
    
    let isActivityIndicatorHidden: Bool
    
    let cellViewModels: [ProductCellViewModel]
}

//MARK: – Builders.

extension ProductsViewModel {
    
    static func buildForData(productResponses: [ProductResponse]?, username: String?, numberFormatter: NumberFormatter, isLoading: Bool) -> ProductsViewModel {
        
        var cellViewModels = [ProductCellViewModel]()
        var planValues = [Double]()
        
        productResponses?.forEach { productResponse in
            
            cellViewModels.append(ProductCellViewModel.buildForProduct(productResponse, numberFormatter: numberFormatter))
            
            if let planValue = productResponse.planValue { //JP: This shouldn't be optional.
                planValues.append(planValue)
            }
        }
        
        if cellViewModels.isEmpty && isLoading == false {
            return buildForEmpty(with: username)
        }
        
        let totalPlanValue = planValues.reduce(0, +)
        let totalPlanValueString = numberFormatter.string(from: NSNumber(value: totalPlanValue)) ?? " – "
        
        //TODO: These should be localised.
        let subtitleTextSource: TextSource = (cellViewModels.isEmpty && isLoading) ? .literal("Just one second, we're fetching your data.") : .literal("Your total plan value is of " + totalPlanValueString)
        
        return .init(titleTextSource: titleTextSource(with: username),
                     subtitleTextSource: subtitleTextSource,
                     isActivityIndicatorHidden: isLoading == false,
                     cellViewModels: cellViewModels)
        
    }
    
    static func buildForError(_ error: Error, username: String?) -> ProductsViewModel {
        return buildForEmpty(with: username) //TODO: This is, obviously, wrong. Implement proper error handling and display.
    }
}

//MARK: – Private Methods.

extension ProductsViewModel {
    
    static func buildForEmpty(with username: String?) -> ProductsViewModel {
                
        return .init(titleTextSource: titleTextSource(with: username),
                     subtitleTextSource: .literal("It looks like you need to get some products!"), //TODO: This should be localised.
                     isActivityIndicatorHidden: false,
                     cellViewModels: [ProductCellViewModel]())
    }
}

//MARK: - Helper Methods.

extension ProductsViewModel {
    
    static func titleTextSource(with username: String?) -> TextSource {
        
        //TODO: These should be localised.

        if let username {
            return .literal("Hey, " + username + "!")
            
        } else {
            return .literal("Hello.")
        }
    }
}
