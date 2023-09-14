//
//  Identifiable.swift
//  MoneyBox
//
//  Created by Thecafremo on 12/09/2023.
//

import UIKit

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
}
