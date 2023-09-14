//
//  AssetProvider.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

public protocol AssetProviderProtocol {
    
    func imageResource(named name: String) -> UIImage?
    func localizedString(forKey key: String) -> String
}
