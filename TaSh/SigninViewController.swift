//
//  SigninViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2020/12/03.
//

import UIKit
import Firebase

class SigninViewController: UIViewController {
        
    let mainView = UIView()
    let infoLabel = UILabel()
    let message1Label = UILabel()
    let message2Label = UILabel()
    let cancelButton = UIButton()
    let message3Label = UILabel()
    let changePasswordButton = UIButton()
    let emailTextfield = UITextField()
    let passwordTextfield = UITextField()
    let loginButton = UIButton()
    let forgetPasswordButton = UIButton()
    
    //Errorメッセージ表示
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
        
        let message = errorMessage(of: error) // エラーメッセージを取得
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //Errorメッセージ生成
    private func errorMessage(of error: Error) -> String {
        var message = "エラーが発生しました"
        guard let errcd = AuthErrorCode(rawValue: (error as NSError).code) else {
            return message
        }
        
        switch errcd {
        case .networkError: message = "ネットワークに接続できません"
        case .userNotFound: message = "ユーザが見つかりません"
        case .invalidEmail: message = "不正なメールアドレスです"
        case .emailAlreadyInUse: message = "このメールアドレスは既に使われています"
        case .wrongPassword: message = "入力した認証情報でサインインできません"
        case .userDisabled: message = "このアカウントは無効です"
        case .weakPassword: message = "パスワードが脆弱すぎます"
        // これは一例です。必要に応じて増減させてください
        default: break
        }
        return message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextfield.isSecureTextEntry = true
        
        mainView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - self.view.bounds.height * (120/667))
        mainView.backgroundColor = UIColor.cyan
        self.view.addSubview(mainView)
        
        infoLabel.frame = CGRect(x: mainView.bounds.width/8 , y: self.view.bounds.height * (60/667), width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/6 )
        infoLabel.text = "ログインするアカウントの\n情報を入力してください"
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont.boldSystemFont(ofSize: 18)
        infoLabel.backgroundColor = UIColor.white
        infoLabel.numberOfLines = 2
        infoLabel.adjustsFontSizeToFitWidth = true
        //        infoLabel.layer.cornerRadius = 10
        infoLabel.layer.borderWidth = 2
        infoLabel.layer.borderColor = UIColor.blue.cgColor
        mainView.addSubview(infoLabel)
        
        message1Label.frame = CGRect(x: mainView.bounds.width/8 , y: self.view.bounds.height * (140/667), width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message1Label.text = "メールアドレス"
        mainView.addSubview(message1Label)
        
        emailTextfield.frame = CGRect(x: mainView.bounds.width/8, y: self.view.bounds.height * (200/667) , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        emailTextfield.placeholder = "example@email.com"
        emailTextfield.backgroundColor = UIColor.white
        emailTextfield.layer.cornerRadius = 10
        emailTextfield.autocorrectionType = .no
        mainView.addSubview(emailTextfield)
        
        message2Label.frame = CGRect(x: mainView.bounds.width/8 , y: self.view.bounds.height * (225/667), width: mainView.bounds.width/2, height: mainView.bounds.height/6 )
        message2Label.text = "パスワード"
        mainView.addSubview(message2Label)
        
        passwordTextfield.frame = CGRect(x: mainView.bounds.width/8, y: self.view.bounds.height * (285/667) , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/11)
        passwordTextfield.backgroundColor = UIColor.white
        passwordTextfield.layer.cornerRadius = 10
        passwordTextfield.placeholder = "password"
        passwordTextfield.autocorrectionType = .no
        mainView.addSubview(passwordTextfield)
        
        message3Label.frame = CGRect(x: (mainView.bounds.width/8) * 2 , y: self.view.bounds.height * (380/667), width: (mainView.bounds.width/8) * 4, height: mainView.bounds.height/16 )
        message3Label.text = "パスワードを忘れましたか？"
        message3Label.adjustsFontSizeToFitWidth = true
        message3Label.textAlignment = NSTextAlignment.center
        message3Label.font = UIFont.boldSystemFont(ofSize: 20)
        message3Label.textColor = UIColor.black
        mainView.addSubview(message3Label)
        
        forgetPasswordButton.frame = CGRect(x: (mainView.bounds.width/16) * 4 , y: self.view.bounds.height * (405/667), width: (mainView.bounds.width/16) * 8 , height: mainView.bounds.height/11 )
        forgetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        let AttributedString = NSAttributedString(string: "パスワードを変更する", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        forgetPasswordButton.setAttributedTitle(AttributedString, for: .normal)
        forgetPasswordButton.addTarget(self,action: #selector(self.didTapGoToChangePasswordPageButton(_ :)),for: .touchUpInside)
        view.addSubview(loginButton)
        mainView.addSubview(forgetPasswordButton)
        
        
        loginButton.frame = CGRect(x: mainView.center.x + 50 * (self.view.bounds.width/375), y: self.view.bounds.height * (609/667), width: 106 * (self.view.bounds.width/375), height: 44 * (self.view.bounds.height/667))
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.setTitleColor( UIColor.white, for: .normal )
        loginButton.backgroundColor = UIColor.red
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        loginButton.layer.cornerRadius = 20.0
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.addTarget(self,action: #selector(self.didTapGoToMainPageButton(_ :)),for: .touchUpInside)
        view.addSubview(loginButton)
        
        cancelButton.frame = CGRect(x: mainView.center.x - 156 * (self.view.bounds.width/375), y: self.view.bounds.height * (609/667), width: 106 * (self.view.bounds.width/375), height: self.view.bounds.height * (44/667))
        cancelButton.setTitle("タイトルへ", for: .normal)
        cancelButton.setTitleColor( UIColor.white, for: .normal )
        cancelButton.backgroundColor = UIColor.red
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        cancelButton.layer.cornerRadius = 20.0
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.addTarget(self,action: #selector(self.didTapCancelButton(_ :)),for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    //ログインボタンタッチ　⇨ 条件が真ならメイン画面へ
    @objc func didTapGoToMainPageButton(_ sender: UIButton) {
        let email = emailTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if (result?.user) != nil {
                // サインイン後の画面へ
                let nextVC = self.storyboard?.instantiateViewController(identifier: "mainPage")
                nextVC?.modalTransitionStyle = .flipHorizontal
                self.present(nextVC!, animated: true, completion: nil)
            }
            self.showErrorIfNeeded(error)
        }
    }
    
    //Cancelボタンがタッチ　⇨ タイトル画面へ
    @objc func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapGoToChangePasswordPageButton(_ sender: Any) {
        // サインイン後の画面へ
        let nextVC = self.storyboard?.instantiateViewController(identifier: "selectTaskView")
        nextVC?.modalTransitionStyle = .flipHorizontal
        self.present(nextVC!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextfield.text = ""
        passwordTextfield.text = ""
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        forgetPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        reloadInputViews()
    }
    
    
    
}
