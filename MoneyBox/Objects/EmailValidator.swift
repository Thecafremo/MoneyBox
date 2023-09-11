//
//  EmailValidator.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import Foundation
    
public struct EmailValidator {
    
    // MARK: - Life Cycle.
    
    public init() {}
}

// MARK: - Public Methods.

extension EmailValidator: EmailValidatorProtocol {
    
    public func isValidEmail(_ text: String?) -> Bool { 
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return validate(regex: regex, text: text)
    }
}

// MARK: - Private Methods.

extension EmailValidator {
    
    private func validate(regex: String, text: String?) -> Bool {
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
}

//MARK: – Definitions.

public protocol EmailValidatorProtocol {
    func isValidEmail(_ text: String?) -> Bool
}
