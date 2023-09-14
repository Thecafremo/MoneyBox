//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Thecafremo on 11/09/2023.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: - Properties.
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var primaryTextField: UITextField!
    @IBOutlet private weak var secondaryTextField: UITextField!
    
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var promptLabel: UILabel! //TODO: Errors should be handled with a better mechanism.
    @IBOutlet private weak var promptContainerView: UIView!
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    var presenter: LoginPresenter?
    var assetProvider: AssetProviderProtocol! //TODO: Get these into an `init` method.
    var theme: Theme!
    
    //MARK: – Life Cycle.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureView()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        addKeyboardObservers()
        presenter?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
}

//MARK: - IBActions.

extension LoginViewController {
    
    @IBAction private func primaryTextFieldDidChange(_ textField: UITextField) {
        presenter?.viewDidChangePrimaryTextFieldText(textField.text)
    }
    
    @IBAction private func secondaryTextFieldDidChange(_ textField: UITextField) {
        presenter?.viewDidChangeSecondaryTextFieldText(textField.text)
    }
    
    @IBAction private func primaryButtonHandler() {
        presenter?.viewDidPressPrimaryButton()
    }
}

//MARK: - LoginDisplayable.

extension LoginViewController: LoginDisplayable {
    
    func populate(with viewModel: LoginViewModel) {
        
        imageView.image = UIImage.from(viewModel.imageViewImageSource, assetProvider: assetProvider)
        
        primaryTextField.attributedPlaceholder = NSAttributedString.init(textSource: viewModel.primaryTextFieldPlaceholderTextSource, assetProvider: assetProvider, color: theme.accentColor)
        secondaryTextField.attributedPlaceholder = NSAttributedString.init(textSource: viewModel.secondaryTextFieldPlaceholderTextSource, assetProvider: assetProvider, color: theme.accentColor)

        button.setTextFrom(viewModel.primaryButtonTextSource, assetProvider: assetProvider)
        
//        button.isEnabled = viewModel.isPrimaryButtonEnabled
        button.alpha = viewModel.primaryButtonAlpha
        
        activityIndicator.isHidden = viewModel.isActivityIndicatorHidden
        
        promptLabel.text = String.from(viewModel.promptLabelTextSource, assetProvider: assetProvider)
        promptContainerView.isHidden = viewModel.isPromptContainerViewHidden
    }
}

//MARK: - Private Methods.

extension LoginViewController {
    
    private func configureView() {
        
        primaryTextField.applyPrimaryStyle(with: theme)
        secondaryTextField.applyPrimaryStyle(with: theme)
        
        secondaryTextField.isSecureTextEntry = true
        
        promptLabel.textColor = .white
        promptLabel.font = .preferredFont(forTextStyle: .footnote)
        promptContainerView.backgroundColor = .red.withAlphaComponent(0.8)
        
        activityIndicator.style = .medium
        activityIndicator.color = .white
        
        button.applyPrimaryStyle(with: theme)
        
        view.backgroundColor = theme.surfaceFillColor
    }
}

// MARK: - KeyboardHandler.

extension LoginViewController: KeyboardHandlerProtocol {

    var keyboardDependantConstraint: NSLayoutConstraint! {
        return buttonBottomConstraint
    }

    var topMargin: CGFloat {
        return 15 //TODO: Add it as part of the `Theme`.
    }
}

//MARK: – Definitions.

protocol LoginDisplayable: AnyObject {
    
    func populate(with viewModel: LoginViewModel)
}
