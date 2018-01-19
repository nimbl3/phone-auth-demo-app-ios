//
//  ViewController.swift
//  Phone auth demo
//
//  Created by Pirush Prechathavanich on 1/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import UIKit
import AccountKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

enum AuthorizationStatus {
    case authorized(token: String)
    case unauthorized
}

class ViewController: UIViewController, AKFViewControllerDelegate {

    private let accountKit = AKFAccountKit(responseType: .accessToken)
    
    private let stackView = UIStackView()
    private let statusLabel = UILabel()
    private let loginButton = UIButton()
    private let firebaseButton = UIButton()
    
    private let status = MutableProperty<AuthorizationStatus>(.unauthorized)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAccountKit()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    //MARK:- private setup
    
    private func setupView() {
        view.backgroundColor = .midnightBlue
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        stackView.addArrangedSubview(statusLabel)
        
        stackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(0.6)
            $0.height.equalTo(50.0)
        }
        
        stackView.addArrangedSubview(firebaseButton)
        firebaseButton.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(0.6)
            $0.height.equalTo(50.0)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 40.0
        stackView.distribution = .fill
        
        statusLabel.textColor = .white
        statusLabel.font = .avenirNext(.medium, size: 16.0)
        statusLabel.numberOfLines = 10
        statusLabel.reactive.text <~ status.map {
            switch $0 {
            case .authorized(let token):    return "Logged in with token: \(token)"
            case .unauthorized:             return "Seems like you haven't logged in yet."
            }
        }
        
        loginButton.setTitle("Login via Phone number", for: .normal)
        loginButton.layer.cornerRadius = 6.0
        loginButton.backgroundColor = .peterRiver
        loginButton.titleLabel?.font = .avenirNext(.demiBold, size: 16.0)
        loginButton.reactive.controlEvents(.touchUpInside)
            .take(during: reactive.lifetime)
            .observeValues { [unowned self] _ in
                switch self.status.value {
                case .authorized:           self.logout()
                case .unauthorized:         self.presentLogin()
                }
        }
        
        loginButton.reactive.title <~ status.map {
            switch $0 {
            case .authorized:               return "Logout"
            case .unauthorized:             return "Login via Phone number"
            }
        }
        
        loginButton.reactive.backgroundColor <~ status.map {
            switch $0 {
            case .authorized:               return UIColor.alizarin
            case .unauthorized:             return UIColor.peterRiver
            }
        }
        
        firebaseButton.setTitle("Open Firebase auth", for: .normal)
        firebaseButton.layer.cornerRadius = 6.0
        firebaseButton.backgroundColor = .carrot
        firebaseButton.titleLabel?.font = .avenirNext(.demiBold, size: 16.0)
        firebaseButton.reactive.controlEvents(.touchUpInside)
            .take(during: reactive.lifetime)
            .observeValues { [unowned self] _ in self.presentFirebaseAuth() }
    }

    private func setupAccountKit() {
        
    }
    
    private func presentFirebaseAuth() {
        
    }
    
    //MARK:- account kit handling
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        status.value = .authorized(token: accessToken.tokenString)
    }
    
    private func presentLogin() {
        let viewController = accountKit.viewControllerForPhoneLogin()
        viewController.delegate = self
        viewController.enableSendToFacebook = true
        viewController.enableGetACall = true
        viewController.uiManager = DemoUIManager()
        
        present(viewController, animated: true, completion: nil)
    }
        
    private func logout() {
        accountKit.logOut { [unowned self] (_, error) in
            if let error = error {
                self.displayAlert(title: "Sorry!", message: error.localizedDescription)
                return
            }
            UIView.animate(withDuration: 0.3) {
                self.status.value = .unauthorized
            }
        }
    }
    
}

extension UIViewController {
    
    func displayAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}
