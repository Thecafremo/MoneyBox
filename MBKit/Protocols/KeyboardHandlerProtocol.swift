//
//  KeyboardHandlerProtocol.swift
//  BudKit
//
//  Created by Axel Lundback on 02/04/2019.
//

import UIKit

public protocol KeyboardHandlerProtocol: AnyObject {
    
    // MARK: - Properties.
    
    /**
     The constraint that should be updated when the keyboard will show / hide.
     */
    var keyboardDependantConstraint: NSLayoutConstraint! { get }
    
    /**
     Top margin between the keyboard and the ui element constrained by the `keyboardDependantConstraint`.
     */
    var topMargin: CGFloat { get }
    
    /**
     Initial top margin between the keyboard and the ui element constrained by the `keyboardDependantConstraint`.
     */
    var initialTopMargin: CGFloat { get }
    
    /**
     property to reference target scrollView and offset amount to perform auto scrolling
     */
    var autoScroll: AutoScroll? { get }
    
    // MARK: - Methods.
    
    func addKeyboardObservers()
    func removeKeyboardObservers()
}

public extension KeyboardHandlerProtocol {
    var initialTopMargin: CGFloat {
        return topMargin
    }
}

public struct AutoScroll {
    let scrollView: UIScrollView
    let offset: CGFloat
    
    public init(scrollView: UIScrollView, offset: CGFloat) {
        self.scrollView = scrollView
        self.offset = offset
    }
}

extension KeyboardHandlerProtocol where Self: UIViewController {
    
    public var autoScroll: AutoScroll? {
        return nil
    }
    
    // MARK: - Default Implementations.
    
    public func addKeyboardObservers() {
        
        let handlerClosure = { [weak self] (notification: Notification) in
            self?.keyboardNotificationsHandler(notification) ?? ()
        }
         
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: handlerClosure)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: handlerClosure)
    }
    
    public func removeKeyboardObservers() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardNotificationsHandler(_ notification: Notification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let keyboardBeginFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardEndFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            keyboardBeginFrame != keyboardEndFrame else {
                return
        }
        
        let heightOffset = notification.name == UIResponder.keyboardWillShowNotification ? keyboardEndFrame.height + topMargin - view.safeAreaInsets.bottom : initialTopMargin
        
        UIView.animate(withDuration: duration.doubleValue,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve.uintValue << 16),
                       animations: { () in
                        self.keyboardDependantConstraint.constant = heightOffset
                        if let autoScroll = self.autoScroll {
                            autoScroll.scrollView.contentOffset.y = autoScroll.offset
                        }
                        self.view.layoutIfNeeded()
        })
    }
}
