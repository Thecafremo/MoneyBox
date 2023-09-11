//
//  String+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Foundation

extension String {
    
    static func from(_ textSource: TextSource?, assetProvider: AssetProviderProtocol) -> String? {
        
        guard let textSource = textSource else {
            return nil
        }

        switch textSource {
        case .literal(let text):
            return text
            
        case .localized(let key):
            return assetProvider.localizedString(forKey: key)
        }
    }
}
