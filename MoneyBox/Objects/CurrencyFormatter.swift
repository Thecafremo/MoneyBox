//
//  CurrencyFormatter.swift
//  Bud
//
//  Created by Thecafremo on 11/09/2023.
//
//

import Foundation

public final class CurrencyFormatter { //TODO: Add protocol?
    
    // MARK: - Constants.
    
    public static let maximumFractionDigits: Int = 2

    // MARK: - Properties.
    
    private lazy var numberFormattersDictionary = {
        return [String: NumberFormatter]()
    }()
    
    private var locale: Locale
    
    // MARK: - Life Cycle.
    
    public init(locale: Locale = Locale.autoupdatingCurrent) {
        self.locale = locale
    }
}

// MARK: - Public Methods.

extension CurrencyFormatter {
    
    /**
     - Parameters:
       - amount: The amount value
       - currencyCode: The amount's currency code as defined in ISO 4217.
       - maximumFractionDigits: Maximum number of decimal digits to be shown by the resulting string
       - hideMantissaIfNotNeeded: If the number has no decimal values, no decimal digits will be shown in the resulting string. E.g. value 1200 -> "£1200" (instead of "£1200.00"), but value 1240.50 -> "£1240.50"
       - useGroupingSeparator: Determines whether the receiver displays the group separator. For example, the grouping separator used in the United States is the comma (“10,000”) whereas in France it is the space (“10 000”).
     
     - Returns: A presentation ready `String`, based on the provided parameters.
    */
    
    public func format(amount: Decimal,
                       with currencyCode: String,
                       maximumFractionDigits: Int = CurrencyFormatter.maximumFractionDigits,
                       hideMantissaIfNotNeeded: Bool = false,
                       useGroupingSeparator: Bool = true) -> String? {
        
        let number = Double(truncating: amount as NSNumber)
        var maximumDecimals = maximumFractionDigits

        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 && hideMantissaIfNotNeeded {
            maximumDecimals = 0
        }
        
        let numberFormatter = appropriateNumberFormatter(for: currencyCode, maximumFractionDigits: maximumDecimals)
        numberFormatter.usesGroupingSeparator = useGroupingSeparator
        return numberFormatter.string(from: amount as NSDecimalNumber)
    }
    
//    public func formatForBalance(amount: Decimal, currencyString: String, isCredit: Bool) -> String? {
//        
//        let multiplier: Decimal = isCredit ? 1 : -1
//        let signedValue = abs(amount) * multiplier
//        
//        return self.format(amount: signedValue,
//                           with: currencyString,
//                           hideMantissaIfNotNeeded: false)
//    }
//    
//    public func formatForTransaction(amount: Decimal, currencyString: String, isCredit: Bool) -> String? {
//        
//        guard let formatted = self.format(amount: abs(amount), with: currencyString, hideMantissaIfNotNeeded: false) else {
//            return nil
//        }
//        
//        let sign = isCredit && (amount != 0) ? "+" : ""
//        return sign + formatted
//    }
}

// MARK: - Helpers.

extension CurrencyFormatter {
    
    private func appropriateNumberFormatter(for currencyCode: String, maximumFractionDigits: Int) -> NumberFormatter {

        let key = CurrencyFormatter.key(from: currencyCode, maximumFractionDigits: maximumFractionDigits)

        if let numberFormatter = self.numberFormattersDictionary[key] {
            return numberFormatter
        }

        let numberFormatter = NumberFormatter(with: currencyCode, maximumFractionDigits: maximumFractionDigits)
        numberFormatter.locale = locale
        numberFormattersDictionary[currencyCode] = numberFormatter

        return numberFormatter
    }

    private class func key(from currencyCode: String, maximumFractionDigits: Int) -> String {
        return currencyCode + String(maximumFractionDigits)
    }
}

// MARK: - Helper extensions.

private extension NumberFormatter {

    // MARK: - Life Cycle.

    convenience init(with currencyCode: String, maximumFractionDigits: Int) {

        self.init()

        self.numberStyle = .currency
        self.maximumFractionDigits = maximumFractionDigits
        self.minimumFractionDigits = maximumFractionDigits
        self.currencyCode = currencyCode
    }
}

