//
//  AccountViewController.swift
//  MoneyBox
//
//  Created by Thecafremo on 19/09/2023.
//

import UIKit

final class AccountViewController: UIViewController {
    
    //MARK: - Properites.
    
    @IBOutlet private weak var planValueLabel: UILabel!
    @IBOutlet private weak var moneyBoxLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var button: UIButton!
    
    var presenter: AccountPresenter?
    var assetProvider: AssetProviderProtocol! //TODO: Get these into an `init` method.
    var theme: Theme!
    
    //MARK: - Life Cycle.

    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureView()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}

//MARK: – IBActions.

extension AccountViewController {
    
    @IBAction private func buttonHandler() {
        presenter?.viewDidPressButton()
    }
}

//MARK: - AccountDisplayable.

extension AccountViewController: AccountDisplayable {
    
    func populate(with viewModel: AccountViewModel) {
        
        planValueLabel.text = String.from(viewModel.planValueTextSource, assetProvider: assetProvider)
        moneyBoxLabel.text = String.from(viewModel.moneyboxTextSource, assetProvider: assetProvider)
        
        button.setTextFrom(viewModel.buttonTextSource, assetProvider: assetProvider)

        activityIndicator.style = .medium
        activityIndicator.color = .white

        button.isEnabled = viewModel.isButtonEnabled
        button.alpha = viewModel.buttonAlpha
        
        activityIndicator.isHidden = viewModel.isActivityIndicatorHidden
    }
}

//MARK: - Private Methods.

extension AccountViewController {
    
    private func configureView() {
        
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = .black //TODO: All of these should be set through the `Theme`, to adapt to a change in mode (dark / light).
        
        planValueLabel.font = .preferredFont(forTextStyle: .body)
        planValueLabel.textColor = .white
        
        moneyBoxLabel.font = .preferredFont(forTextStyle: .body)
        moneyBoxLabel.textColor = .white
        
        button.applyPrimaryStyle(with: theme)
    }
}

//MARK: - Definitions.

protocol AccountDisplayable: AnyObject {
    
    func populate(with viewModel: AccountViewModel)
}
