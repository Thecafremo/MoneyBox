//
//  ImageSource.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Foundation

public enum ImageSource {
    
    case assets(String)
    case systemSymbol(String)
    case url(URL)
    case none
}
