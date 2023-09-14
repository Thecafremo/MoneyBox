//
//  AccountTableViewCell.swift
//  MoneyBox
//
//  Created by Jorge Pardo on 12/09/2023.
//

import UIKit

final class ProductTableViewCell: UITableViewCell, Identifiable {
    
    //MARK: - Properties.
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var planValueLabel: UILabel!
    @IBOutlet private weak var moneyboxLabel: UILabel!
    
    @IBOutlet private weak var accessoryImageView: UIImageView!
    
    @IBOutlet private weak var containerView: UIView!
}

//MARK: – Public Methods.

extension ProductTableViewCell {
    
    func populate(with viewModel: ProductCellViewModel, assetProvider: AssetProviderProtocol, theme: Theme) {
        
        titleLabel.text = String.from(viewModel.titleTextSource, assetProvider: assetProvider)
        planValueLabel.text = String.from(viewModel.planValueTextSource, assetProvider: assetProvider)
        moneyboxLabel.text = String.from(viewModel.moneyboxTextSource, assetProvider: assetProvider)
        
        accessoryImageView.image = UIImage.from(viewModel.accessoryImageSource, assetProvider: assetProvider)
        
        apply(theme, colorHex: viewModel.colorHex)
    }
}

//MARK: – Private Methods.

extension ProductTableViewCell {
    
    func apply(_ theme: Theme, colorHex: String?) {
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17) //TODO: This should be done without hardcoding a value, and to handle dynamic text.
        titleLabel.textColor = .white
        
        planValueLabel.font = .preferredFont(forTextStyle: .body)
        planValueLabel.textColor = .white
        
        moneyboxLabel.font = .preferredFont(forTextStyle: .body)
        moneyboxLabel.textColor = .white
        
        accessoryImageView.tintColor = .white
        
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .black // Didn't use the colorHex, in the end, because it didn't look all that good.
        
        backgroundColor = .clear
        selectionStyle = .none
    }
}
