//
//  UIButton+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

extension UIButton {
    
    func applyPrimaryStyle(with theme: Theme) {
     
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = theme.accentColor
        self.layer.cornerRadius = 5
    }
}
