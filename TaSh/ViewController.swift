//
//  ViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2020/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    
//    @IBOutlet weak var logInButton: UIButton!
//    @IBOutlet weak var signUpButton: UIButton!
    
//    @IBAction func gotoLoginPage(_ sender: Any) {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "loginPage")
//        nextVC?.modalTransitionStyle = .flipHorizontal
//        present(nextVC!, animated: true, completion: nil)
//    }
    
//    @IBAction func gotoSignupPage(_ sender: Any) {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "signupPage")
//        nextVC?.modalTransitionStyle = .flipHorizontal
//        present(nextVC!, animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイトルとログインボタンのビュー配置
        let StartView = UIView()
        StartView.backgroundColor = UIColor.cyan
        StartView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height-120)
        
        let Width = StartView.bounds.width;
        let Height = StartView.bounds.height;
        
        //タイトルとログインボタンをビュー上に配置
        //タイトルラベル
        let titleLabel =  UILabel()
//        titleLabel.frame = CGRect(x: 68, y: 86, width: 240, height: 120)
        titleLabel.frame = CGRect(x: self.view.bounds.width * (68/375), y: self.view.bounds.height * (86/667), width: self.view.bounds.width * (240/375), height: self.view.bounds.height * (120/667))
        titleLabel.text = "TaSh"
        titleLabel.font =  UIFont(name: "Avenir-LightOblique", size: 115 )
        titleLabel.adjustsFontSizeToFitWidth = true
        
        let messageLabel = UILabel()
        messageLabel.frame = CGRect(x: self.view.bounds.width * (101/375), y: self.view.bounds.height * (560/667), width: self.view.bounds.width * (173/375), height: self.view.bounds.height * (41/667))
        messageLabel.text = "アカウントを\n登録していませんか"
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "ArialMT", size: 40)
        messageLabel.adjustsFontSizeToFitWidth = true
        
        
        //ログインボタン
        let loginButton = UIButton()
//        loginButton.frame = CGRect(x: 134, y: 400, width: 106, height: 44)
        loginButton.frame = CGRect(x: Width * (134/375), y: Height * (400/667), width: Width * (106/375) , height: Height * (44/667))
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.setTitleColor( UIColor.blue, for: .normal )
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        loginButton.backgroundColor = UIColor.green
        loginButton.layer.cornerRadius = 20.0
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.addTarget(self,action: #selector(self.didTapGoToLoginPage(_ :)),for: .touchUpInside)
        
        //アカウント登録用ボタン配置
        let signUpButton = UIButton()
//        signUpButton.frame = CGRect(x: 134, y: 609, width: 106, height: 44)
        signUpButton.frame = CGRect(x: view.bounds.width * (134/375), y: view.bounds.height * (609/667), width: view.bounds.width * (106/375), height: view.bounds.height * (44/667));
        signUpButton.setTitle("サインイン", for: .normal)
        signUpButton.setTitleColor( UIColor.white, for: .normal )
        signUpButton.backgroundColor = UIColor.red
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        signUpButton.layer.cornerRadius = 20.0
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButton.addTarget(self,action: #selector(self.didTapGoToSigninPage(_ :)),for: .touchUpInside)
        
        self.view.addSubview(StartView)
        StartView.addSubview(titleLabel)
        StartView.addSubview(loginButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(signUpButton)

    }
    
    //ログイン画面へ遷移
    @objc func didTapGoToLoginPage(_ sender: UIButton){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "loginPage")
        nextVC?.modalTransitionStyle = .flipHorizontal
        present(nextVC!, animated: true, completion: nil)
    }
    
    //アカウント登録画面へ遷移
    @objc func didTapGoToSigninPage(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "signupPage")
        nextVC?.modalTransitionStyle = .flipHorizontal
        present(nextVC!, animated: true, completion: nil)
    }
}

