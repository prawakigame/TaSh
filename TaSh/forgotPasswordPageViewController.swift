//
//  ForgotPasswordPageViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2021/01/18.
//

import UIKit
import FirebaseAuth

class forgotPasswordPageViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailForm: UITextField!
    
    //パスワード再設定用のメールを送る
    @IBAction func didTapForgotPasswordButton(_ sender: Any) {
        let email = emailForm.text!
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
//                // エラーが無ければタイトル画面へ
//                let message = "指定したメールアドレスにパスワード再設定用のメールを送りました。メールを開いてパスワードの変更をしてください。"
//                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                // エラーが無ければタイトル画面へ
//                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                // エラーが無ければタイトル画面へ
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            self.showErrorIfNeeded(error)
        }
    }
    
    //パスワード再設定を中止するß
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //エラー警告出力
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard errorOrNil != nil else { return }
        
        let message = "エラーが起きました"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
