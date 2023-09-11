//
//  UIButton+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

extension UIButton {
    
    func setTextFrom(_ textSource: TextSource?, assetProvider: AssetProviderProtocol) { //TODO: Handle other Button States. 
        
        self.setTitle(String.from(textSource, assetProvider: assetProvider),
                      for: .normal)
    }
}
