//
//  NSAttributedString+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

extension NSAttributedString {
    
    convenience init(textSource: TextSource, assetProvider: AssetProviderProtocol, color: UIColor) {
        
        let string = String.from(textSource, assetProvider: assetProvider)
        
        self.init(string: (string != nil) ? string! : "",
                  attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
