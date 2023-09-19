//
//  NumberFormatter+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 19/09/2023.
//

import Foundation

extension NumberFormatter {
    
    func currencyString(for value: Double?) -> String {
        
        guard let value else {
            return " – "
        }
        
        return self.string(from: NSNumber(value: value)) ?? " – "
    }
}
