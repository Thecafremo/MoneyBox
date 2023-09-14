//
//  UITableView+LoadablePodResource.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 12/09/2023.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell & Identifiable>(_ cellType: T.Type) {
        
        let name = String(describing: cellType)
        
        self.register(UINib(nibName: name, bundle: nil),
                      forCellReuseIdentifier: cellType.identifier)
    }
}
