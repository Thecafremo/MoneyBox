//
//  UIImage+Additions.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

extension UIImage {

    static func from(_ imageSource: ImageSource, assetProvider: AssetProviderProtocol?) -> UIImage? {
        
        switch imageSource {
        case .assets(_):
            fatalError("setImage:from:assetProvider not implemented")

        case .systemSymbol(let string):
            return UIImage(systemName: string)
            
        case .url(_):
            fatalError("setImage:from:assetProvider not implemented")
            
        case .none:
            return nil
        }
    }
}
