//
//  LoginViewController.swift
//  shustagram
//
//  Created by 徐乾智 on 7/21/21.
//

import LBTATools
import Alamofire
import JGProgressHUD

class LoginViewController: LBTAFormController {
    
    // MARK: UI Elements
    
    var homeController: HomeViewController?
    
//    let logoImageView = UIImageView(image: UIImage(named: "shustagram"), contentMode: .scaleAspectFit)
    let logoLabel: UILabel = {
        let label = UILabel(text: "Shustagram", font: .systemFont(ofSize: 25, weight: .heavy), textColor: .black, numberOfLines: 0)
//        label.font =
        return label
    }()
    
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25)
    lazy var loginButton = UIButton(title: "Login", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleLogin))
    
    let errorLabel = UILabel(text: "Your login credentials were incorrect, please try again.", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
    
    lazy var goToRegisterButton = UIButton(title: "Need an account? Go to register.", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
    
    @objc fileprivate func goToRegister() {
        let vc = RegisterViewController(alignment: .center)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging in"
        hud.show(in: view)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        errorLabel.isHidden = true
        
        Service.shared.login(email: email, password: password) { (res) in
            hud.dismiss()
            
            switch res {
            case .failure:
                print("login failed")
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Your credentials are not correct, please try again."
            case .success:
                print("login successful")
                if let vc = self.homeController {
                    vc.fetchPosts()
                }
                self.dismiss(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 25
        navigationController?.navigationBar.isHidden = true
        errorLabel.isHidden = true
        
        let formView = UIView()
        formView.stack(
            formView.stack(formView.hstack(logoLabel.withWidth(160), spacing: 16, alignment: .center).padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            loginButton.withHeight(50),
            errorLabel,
            goToRegisterButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(formView)
    }
}
