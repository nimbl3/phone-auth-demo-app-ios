//
//  FirebaseViewController.swift
//  Phone auth demo
//
//  Created by Pirush Prechathavanich on 1/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import FirebaseAuth

enum OTPStatus {
    case idle
    case sent
    case confirmed
}

class FirebaseViewController: UIViewController, UITextFieldDelegate {
    
    private let stackView = UIStackView()
    private let statusLabel = UILabel()
    private let textField = UITextField()
    private let loginButton = UIButton()
    private let closeButton = UIButton()
    
    private let status = MutableProperty<OTPStatus>(.idle)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK:- private setup
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(textField)
        
        stackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(0.6)
            $0.height.equalTo(50.0)
        }
        
        stackView.addArrangedSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(0.6)
            $0.height.equalTo(50.0)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 25.0
        stackView.distribution = .fill
        
        statusLabel.textColor = .midnightBlue
        statusLabel.font = .avenirNext(.medium, size: 16.0)
        statusLabel.numberOfLines = 10
        statusLabel.reactive.text <~ status.map {
            switch $0 {
            case .idle:             return "Please fill in your mobile no. and wait for a SMS to confirm your OTP."
            case .sent:             return "We have sent you an OTP via SMS. Please check and fill in the code"
            case .confirmed:        return "You're logged in!"
            }
        }
        
        textField.font = .avenirNext(.medium, size: 18.0)
        textField.keyboardType = .phonePad
        textField.textAlignment = .center
        textField.textColor = .midnightBlue
        textField.tintColor = .midnightBlue
        textField.delegate = self
        textField.layer.cornerRadius = 6.0
        textField.layer.borderColor = UIColor.midnightBlue.cgColor
        textField.layer.borderWidth = 2.0
        textField.snp.makeConstraints {
            $0.height.equalTo(50.0)
        }
        
        loginButton.layer.cornerRadius = 6.0
        loginButton.titleLabel?.font = .avenirNext(.demiBold, size: 16.0)
        loginButton.reactive.controlEvents(.touchUpInside)
            .take(during: reactive.lifetime)
            .observeValues { [unowned self] _ in
                switch self.status.value {
                case .idle:             self.requestOtp()
                case .sent:             self.confirmOtp()
                case .confirmed:        self.logout()
                }
        }
        
        loginButton.reactive.title <~ status.map {
            switch $0 {
            case .idle:             return "Sent me OTP!"
            case .sent:             return "Confirm"
            case .confirmed:        return "Logout"
            }
        }
        
        loginButton.reactive.backgroundColor <~ status.map {
            switch $0 {
            case .confirmed:        return UIColor.alizarin
            default:                return UIColor.peterRiver
            }
        }
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.layer.cornerRadius = 6.0
        closeButton.backgroundColor = .alizarin
        closeButton.titleLabel?.font = .avenirNext(.demiBold, size: 16.0)
        closeButton.reactive.controlEvents(.touchUpInside)
            .take(during: reactive.lifetime)
            .observeValues { [unowned self] _ in self.dismiss(animated: true, completion: nil) }
    }
    
    private func requestOtp() {
        
    }
    
    private func confirmOtp() {
        
    }
    
    private func logout() {
        
    }
    
}
