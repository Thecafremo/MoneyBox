//
//  UITextField+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

extension UITextField {
    
    func applyPrimaryStyle(with theme: Theme) {
     
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = theme.accentColor.cgColor
        self.layer.cornerRadius = 5
        self.backgroundColor = theme.surfaceFillColor
        self.textColor = .white
    }
}
