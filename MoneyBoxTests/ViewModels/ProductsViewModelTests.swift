//
//  ProductViewModel.swift
//  MoneyBoxTests
//
//  Created by Thecafremo on 14/09/2023.
//

@testable import MoneyBox
import Networking
import XCTest

final class ProductsViewModelTests: XCTestCase {
    
    //MARK: - Properties.
    
    private lazy var numberFormatter: NumberFormatter = {
       
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.autoupdatingCurrent
        formatter.currencyCode = "GBP"
        
        return formatter
    }()
    

    //MARK: - Tests.
    
    func test_buildForData_forFirstLoad() {
        
        let productsViewModel = ProductsViewModel.buildForData(productResponses: nil, username: nil, numberFormatter: numberFormatter, isLoading: true)
        
        XCTAssert(productsViewModel.cellViewModels.count == 0)
        XCTAssert(productsViewModel.titleTextSource == .literal("Hello."))
        XCTAssert(productsViewModel.subtitleTextSource == .literal("Just one second, we're fetching your data."))
        XCTAssert(productsViewModel.isActivityIndicatorHidden == false)
    }
    
    func test_buildForData() {
        
        //TODO: It would be simpler if we could just initialise the Model objects we need.
        
        StubData.read(file: "Accounts") { (result: Result<AccountResponse, Error>) in
            
            guard case .success(let accountResponse) = result else {
                XCTFail()
                return
            }

            let productsViewModel = ProductsViewModel.buildForData(productResponses: accountResponse.productResponses,
                                                                   username: "Bill",
                                                                   numberFormatter: self.numberFormatter,
                                                                   isLoading: false)
            
            XCTAssert(productsViewModel.cellViewModels.count == 2) //TODO: The `CellViewModels` would have their own test, and thus, there's no need to test here, too.
            XCTAssert(productsViewModel.titleTextSource == .literal("Hey, Bill!"))
            
            //TODO: This would fail with the testing device is with a different `Locale`.
            //      `TextSource` should be tested through a mock`AssetProvider`, instead.
            
            XCTAssert(productsViewModel.subtitleTextSource == .literal("Your total plan value is of £15,707.08"))
            XCTAssert(productsViewModel.isActivityIndicatorHidden == true)
        }
    }
    
    
    func test_buildForError() {
        //TODO: `buildForError` was not proplery implemented.
    }
}


//MARK: - Helper Methods.

extension TextSource: Equatable {
    
    public static func == (lhs: TextSource, rhs: TextSource) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.literal(let lhsString), .literal(let rhsString)):
            return lhsString == rhsString
            
        case (.localized(key: let lhsString), .localized(key: let rhsString)):
            return lhsString == rhsString
        
        default:
            return false
        }
    }
}
