//
//  GenericError.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Foundation

enum GenericError: LocalizedError {

    // MARK: - Cases.

    case withMessage(String)

    // MARK: - Overrides.

    var errorDescription: String? {

        switch self {
        case let .withMessage(message):
            return message
        }
    }
}
