//
//  SignupPageViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2020/12/03.
//

import UIKit
import Firebase

class SignupPageViewController: UIViewController {
    
    let titleLabel = UILabel()
    let mainView = UIView()
    let infoLabel = UILabel()
    let message1Label = UILabel()
    let message2Label = UILabel()
    let cancelButton = UIButton()
    let message3Label = UILabel()
    let changePasswordButton = UIButton()
    let userNameTextfield = UITextField()
    let emailTextfield = UITextField()
    let passwordTextfield = UITextField()
    let loginButton = UIButton()
    let forgetPasswordButton = UIButton()

    
    
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard errorOrNil != nil else { return }
        
        let message = "エラーが起きました" // ここは後述しますが、とりあえず固定文字列
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextfield.isSecureTextEntry = true
        
//        mainView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 120)
        mainView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - self.view.bounds.height * (120/667))
        mainView.backgroundColor = UIColor.systemTeal
        self.view.addSubview(mainView)
        
        let Height = self.view.bounds.height;
        let Width = self.view.bounds.width;
        
//        titleLabel.frame = CGRect(x: (mainView.bounds.width/16) * 4 , y: 60, width: 8 * (mainView.bounds.width/16 ), height: mainView.bounds.height/6 )
        titleLabel.frame = CGRect(x: (mainView.bounds.width/16) * 4 , y: Height * (60/667), width: 8 * (mainView.bounds.width/16 ), height: mainView.bounds.height/6 )
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "アカウント作成"
        mainView.addSubview(titleLabel)
        
//        infoLabel.frame = CGRect(x: mainView.bounds.width/8 , y: 120, width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/6 )
        infoLabel.frame = CGRect(x: mainView.bounds.width/8 , y: Height * (120/667), width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/6 )
        infoLabel.text = "アカウントの情報を入力してください"
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        infoLabel.numberOfLines = 2
        infoLabel.adjustsFontSizeToFitWidth = true
        mainView.addSubview(infoLabel)
        
//        message1Label.frame = CGRect(x: mainView.bounds.width/8 , y: 160, width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message1Label.frame = CGRect(x: mainView.bounds.width/8 , y: Height * (160/667), width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message1Label.text = "アカウント名"
        mainView.addSubview(message1Label)
        
//        userNameTextfield.frame = CGRect(x: mainView.bounds.width/8, y: 220 , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        userNameTextfield.frame = CGRect(x: mainView.bounds.width/8, y: Height * (220/667) , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        userNameTextfield.placeholder = "User Name"
        userNameTextfield.backgroundColor = UIColor.white
        userNameTextfield.layer.cornerRadius = 10
        userNameTextfield.autocorrectionType = .no
        mainView.addSubview(userNameTextfield)
        
//        message2Label.frame = CGRect(x: mainView.bounds.width/8 , y: 245, width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message2Label.frame = CGRect(x: mainView.bounds.width/8 , y: Height * (245/667), width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message2Label.text = "メールアドレス"
        mainView.addSubview(message2Label)
        
//        emailTextfield.frame = CGRect(x: mainView.bounds.width/8, y: 305 , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        emailTextfield.frame = CGRect(x: mainView.bounds.width/8, y: Height * (305/667) , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        emailTextfield.backgroundColor = UIColor.white
        emailTextfield.layer.cornerRadius = 10
        emailTextfield.placeholder = "example@email.com"
        emailTextfield.autocorrectionType = .no
        emailTextfield.keyboardType = UIKeyboardType.emailAddress
        mainView.addSubview(emailTextfield)
        
//        message3Label.frame = CGRect(x: mainView.bounds.width/8 , y: 330, width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
//        message3Label.text = "パスワード"
//        mainView.addSubview(message3Label)
        message3Label.frame = CGRect(x: mainView.bounds.width/8 , y: Height * (330/667), width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message3Label.text = "パスワード"
        mainView.addSubview(message3Label)
        
//        passwordTextfield.frame = CGRect(x: mainView.bounds.width/8, y: 390 , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
//        passwordTextfield.backgroundColor = UIColor.white
//        passwordTextfield.layer.cornerRadius = 10
//        passwordTextfield.placeholder = "password"
//        mainView.addSubview(passwordTextfield)
        
        passwordTextfield.frame = CGRect(x: mainView.bounds.width/8, y: Height * (390/667) , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        passwordTextfield.backgroundColor = UIColor.white
        passwordTextfield.layer.cornerRadius = 10
        passwordTextfield.placeholder = "password"
        passwordTextfield.autocorrectionType = .no
        mainView.addSubview(passwordTextfield)
        
        
//        loginButton.frame = CGRect(x: mainView.center.x + 50, y: 609, width: 106, height: 44)
        loginButton.frame = CGRect(x: mainView.center.x + 50 * (Width/375), y: Height * (609/667), width: Width * (106/375), height: Height * (44/667))
        loginButton.setTitle("アカウント作成", for: .normal)
        loginButton.setTitleColor( UIColor.white, for: .normal )
        loginButton.backgroundColor = UIColor.red
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        loginButton.layer.cornerRadius = 20.0
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.addTarget(self,action: #selector(self.didTapMakeAccountButton(_ :)),for: .touchUpInside)
        view.addSubview(loginButton)
        
//        cancelButton.frame = CGRect(x: mainView.center.x - 156, y: 609, width: 106, height: 44)
        cancelButton.frame = CGRect(x: mainView.center.x - 156 * (Width/375), y: Height * (609/667), width: Width * (106/375), height: Height * (44/667))
        cancelButton.setTitle("タイトルへ", for: .normal)
        cancelButton.setTitleColor( UIColor.white, for: .normal )
        cancelButton.backgroundColor = UIColor.red
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        cancelButton.layer.cornerRadius = 20.0
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.addTarget(self,action: #selector(self.didTapCancelButton(_ :)),for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    @objc func didTapMakeAccountButton(_ sender : Any ) {
        let email = emailTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        let name = userNameTextfield.text ?? ""
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] result, error in guard let self = self else {return}
            if let user = result?.user {
                let req = user.createProfileChangeRequest()
                req.displayName = name
                req.commitChanges() { [weak self] error in
                    guard let self = self else { return }
                    if error == nil {
                        user.sendEmailVerification() { [weak self] error in guard let self = self else {return}
                            if error == nil
                            {
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.showErrorIfNeeded(error)
                        }
                    }
                    self.showErrorIfNeeded(error)
                }
            }
            self.showErrorIfNeeded(error)
        }
    }
    
    @objc func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
