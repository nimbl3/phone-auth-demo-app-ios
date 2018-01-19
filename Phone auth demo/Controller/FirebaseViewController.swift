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
    case sent(verificationId: String)
    case confirmed(user: User)
}

class FirebaseViewController: UIViewController, UITextFieldDelegate, AuthUIDelegate {
    
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
        setupBinding()
        setupCurrentStatus()
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
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.layer.cornerRadius = 6.0
        closeButton.backgroundColor = .alizarin
        closeButton.titleLabel?.font = .avenirNext(.demiBold, size: 16.0)
    }
    
    private func setupBinding() {
        statusLabel.reactive.text <~ status.map {
            switch $0 {
            case .idle:                     return "Please fill in your mobile no. and wait for a SMS to confirm your OTP."
            case .sent(let id):             return "We have sent you an OTP via SMS. Please check and fill in the code (verification id: \(id))"
            case .confirmed(let user):      return "Welcome \(user.displayName ?? user.uid)! You're logged in!"
            }
        }
        
        textField.reactive.isHidden <~ status.map {
            switch $0 {
            case .confirmed:        return true
            default:                return false
            }
        }
        
        loginButton.reactive.controlEvents(.touchUpInside)
            .take(during: reactive.lifetime)
            .observeValues { [unowned self] _ in
                switch self.status.value {
                case .idle:             self.requestOtp()
                case .sent(let id):     self.confirmOtp(with: id)
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
        
        closeButton.reactive.controlEvents(.touchUpInside)
            .take(during: reactive.lifetime)
            .observeValues { [unowned self] _ in self.dismiss(animated: true, completion: nil) }
    }
    
    private func setupCurrentStatus() {
        if let user = Auth.auth().currentUser {
            status.value = .confirmed(user: user)
        } else {
            status.value = .idle
        }
    }
    
    //MARK:- network handling
    
    private func requestOtp() {
        guard let phoneNumber = textField.text else {
            displayAlert(title: "Sorry!", message: "Please fill in your mobile number first.")
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: self) { [weak self] (verificationId, error) in
            switch (verificationId, error) {
            case (_, .some(let error)):
                self?.displayAlert(title: "Sorry!", message: error.localizedDescription)
            case (.some(let verificationId), _):
                self?.textField.text = nil
                self?.status.value = .sent(verificationId: verificationId)
            default:
                self?.displayAlert(title: "Sorry!", message: "It seems something went wrong. Please try again")
            }
        }
    }
    
    private func confirmOtp(with verificationId: String) {
        guard let code = textField.text, code.count == 6 else {
            displayAlert(title: "Sorry!", message: "Code must contains 6 numbers. Please try again.")
            return
        }
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        Auth.auth().signIn(with: credentials) { [weak self] (user, error) in
            switch (user, error) {
            case (_, .some(let error)):         self?.displayAlert(title: "Sorry!", message: error.localizedDescription)
            case (.some(let user), _):          self?.status.value = .confirmed(user: user)
            default:                            self?.displayAlert(title: "Sorry!", message: "It seems something went wrong. Please try again")
            }
            
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            status.value = .idle
        } catch(let error) {
            displayAlert(title: "Sorry!", message: error.localizedDescription)
        }
    }
    
}
