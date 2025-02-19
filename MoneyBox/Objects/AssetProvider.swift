//
//  AssetProvider.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 11/09/2023.
//

import UIKit

final class AssetProvider {
    
}

//MARK: - AssetProviderProtocol.

extension AssetProvider: AssetProviderProtocol {
    
    func imageResource(named name: String) -> UIImage? {
        UIImage(named: name)
    }
    
    func localizedString(forKey key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}

