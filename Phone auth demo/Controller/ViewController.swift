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

class ViewController: UIViewController, AKFViewControllerDelegate {

    private let accountKit = AKFAccountKit(responseType: .accessToken)
    
    private let stackView = UIStackView()
    private let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAccountKit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = accountKit.currentAccessToken {
            displayAlert(title: "Token exists!",
                         message: "Should navigate to the main screen. \(token.tokenString)")
        } else {
            //todo:- show login
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    //MARK:- private setup
    
    private func setupView() {
        view.backgroundColor = .midnightBlue
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        stackView.addArrangedSubview(loginButton)
        
        loginButton.setTitle("Login via Phone number", for: .normal)
        loginButton.backgroundColor = .peterRiver
        loginButton.titleLabel?.font = .avenirNext(.medium, size: 16.0)
        loginButton.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(0.6)
            $0.height.equalTo(50.0)
        }
    }

    private func setupAccountKit() {
        
    }
    
    //MARK:- account kit delegate
    
}

extension UIViewController {
    
    func displayAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}
