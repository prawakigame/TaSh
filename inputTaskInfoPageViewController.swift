//
//  inputTaskInfoPageViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2021/01/11.
//

//タスク更新画面

import UIKit
import Firebase
import FirebaseFirestoreSwift

class inputTaskInfoPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //データベースの参照先を定義
    let db = Firestore.firestore()
    
    //タスクのID
    var taskID : String?
    
    //タスク作成者 ⇨ MainPageから受け取る
    var taskAuthor : String?
    
    //タスク名
    var taskName : String?
    
    //タスクの工数
    var taskPlan : String?
    
    //タスクの進捗状況
    var taskStatus : String?
    
    //小タスクの進捗状況
    var smallTaskArray : [String] = []
    var memoryTaskArray : [String] = []
    
    var taskPrime : String?
    
    var taskKEY : Int?
    
    //警告表示用変数
    var alertController: UIAlertController!
    
//    @IBOutlet weak var taskAuthorLabel: UILabel!
    //    @IBOutlet weak var taskNameLabrel: UILabel!
//    @IBOutlet weak var taskStatusInputTextField: UITextField!
    //    @IBOutlet weak var taskPlanLabel: UILabel!
//    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
//    @IBOutlet weak var tableView: UITableView!
    
    let ScrollView = UIScrollView()
    let tableView = UITableView()
    
    let taskPrimeLabel = UILabel()
    let taskNameLabel = UILabel()
    let taskPlanLabel = UILabel()
    let taskCreatorLabel = UILabel()
    let taskStatusLabel = UILabel()
    let taskUpdateTextField = UITextField()
    let taskUpdateView = UIView()
    let messageLabel = UILabel()
    
    let updateTaskButton = UIButton()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.smallTaskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "smallTask")
        let cellData = smallTaskArray[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = String(cellData.dropLast())
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if self.memoryTaskArray[indexPath.row].suffix(1) == "1" {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "やること"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if self.memoryTaskArray[indexPath.row].suffix(1) == "0" {
            if cell?.accessoryType == .checkmark{
                cell?.accessoryType = .none
                let subStr = self.smallTaskArray[indexPath.row]
                self.smallTaskArray[indexPath.row] = String(subStr.dropLast()) + "0"
            } else {
                cell?.accessoryType = .checkmark
                let subStr = self.smallTaskArray[indexPath.row]
                self.smallTaskArray[indexPath.row] = String(subStr.dropLast()) + "1"
            }
            
        }
    }
    //
    //    //タスク更新をキャンセル　⇨ 元の画面に戻る
    //    @IBAction func didTapCancelButton(_ sender: Any) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
    
    //タスクの情報を更新　⇨ firebaseのデータベースを更新
//    @IBAction func didTapUpdateButton(_ sender: Any) {
//        let taskStatus = taskStatusInputTextField.text
//
//        if taskStatus!.isAlphanumeric() {
//            if Int(taskStatus!)! + Int(self.taskStatus!)! <= Int(self.taskPlan!)! {
//                db.collection("tasks").document(taskID!).updateData([
//                    "status" : String(Int(taskStatus!)! + Int(self.taskStatus!)! )
//                ]) { err in
//                    if let err = err {
//                        print("Error updating document: \(err)")
//                    } else {
//                        print()
//                        print("Document successfully updated")
//                    }
//                }
//
//                var index = 0
//                for item in self.smallTaskArray {
//                    db.collection("smalltasks").document(taskID!).setData(["smalltask\(index)":item], merge: true)
//                    index = index + 1
//                }
//                self.dismiss(animated: true, completion: nil)
//            }
//            alert(title: "工数入力エラー", message: "工数を過ぎてしまいます")
//        } else {
//            alert(title: "工数入力エラー", message: "工数には半角数字を入力してください")
//        }
//    }
    
    //警告表示
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //スクロールビューの高さ
//        let tableViewHeight = self.tableView.bounds.height
        
        //contentsViewの幅を取得
        let contentsViewWidth = Float(self.contentsView.bounds.size.width)
        
        contentsView.backgroundColor = UIColor.cyan
        
        let taskInfoLabelHeight : Int = 30
        
        //メインメニューへ戻るボタン
        let backButton = UIButton()
        backButton.frame = CGRect(x:280, y:22, width:78 , height:30)
        backButton.setTitle("戻る", for: .normal)
        backButton.backgroundColor = UIColor.blue
        backButton.setTitleColor(UIColor.yellow, for:.normal)
        backButton.layer.cornerRadius = 10.0
        contentsView.addSubview(backButton)
        backButton.addTarget(self,action: #selector(self.didTapGoToMainPage(_ :)),for: .touchUpInside)
        
        //タスクの優先度ラベル
        taskPrimeLabel.frame = CGRect(x : Int((contentsViewWidth - Float(80))/2) , y: 40, width: 80, height: 40)
        taskPrimeLabel.text = self.taskPrime
        taskPrimeLabel.font = UIFont.systemFont(ofSize: 40)
        taskPrimeLabel.textColor = UIColor.black
        taskPrimeLabel.adjustsFontSizeToFitWidth = true
        self.contentsView.addSubview(taskPrimeLabel)
        
        //タスクの名前ラベル
        taskNameLabel.frame =
            CGRect(x : Int((contentsViewWidth - Float(300))/2) , y: 70, width: 300, height: 120)
        taskNameLabel.text = self.taskName
        taskNameLabel.font = UIFont.systemFont(ofSize: 100.0)
        taskNameLabel.textAlignment = NSTextAlignment.center
        taskNameLabel.textColor = UIColor.systemBlue
        taskNameLabel.adjustsFontSizeToFitWidth = true
        taskNameLabel.layer.cornerRadius = 10.0
        self.contentsView.addSubview(taskNameLabel)
        
        //タスクの作成者ラベル
        taskCreatorLabel.frame = CGRect(x: 60, y: 210, width: Int(self.contentsView.bounds.width) - 60*2 , height: taskInfoLabelHeight)
        taskCreatorLabel.text = String("作成者: ")+self.taskAuthor!
        taskCreatorLabel.font = UIFont.systemFont(ofSize: 29.0)
        taskCreatorLabel.textColor = UIColor.systemBlue
        taskCreatorLabel.layer.borderColor = UIColor.red.cgColor
        taskCreatorLabel.layer.borderWidth = 2
        taskCreatorLabel.textAlignment = NSTextAlignment.center
        taskCreatorLabel.adjustsFontSizeToFitWidth = true
        taskCreatorLabel.layer.cornerRadius = 10.0
        self.contentsView.addSubview(taskCreatorLabel)
        
        //タスクの工数ラベル
        taskPlanLabel.frame = CGRect(x: 60, y: 240 + 5, width: Int(self.contentsView.bounds.width) - 60*2 , height: taskInfoLabelHeight)
        taskPlanLabel.text = String("タスクの工数: ") + self.taskPlan!
        taskPlanLabel.font = UIFont.systemFont(ofSize: 29.0)
        taskPlanLabel.textColor = UIColor.black
        taskPlanLabel.layer.borderColor = UIColor.red.cgColor
        taskPlanLabel.textAlignment = NSTextAlignment.center
        taskPlanLabel.layer.borderWidth = 2
        taskPlanLabel.adjustsFontSizeToFitWidth = true
        taskPlanLabel.layer.cornerRadius = 10.0
        self.contentsView.addSubview(taskPlanLabel)
        
        //現在の工数ラベル
        taskStatusLabel.frame = CGRect(x: 60, y: 275 + 5 , width: Int(self.contentsView.bounds.width) - 60*2 , height: taskInfoLabelHeight)
        taskStatusLabel.text = String("現在の工数: ") + self.taskStatus!
        taskStatusLabel.font = UIFont.systemFont(ofSize: 29.0)
        taskStatusLabel.textColor = UIColor.black
        taskStatusLabel.layer.borderColor = UIColor.red.cgColor
        taskStatusLabel.layer.borderWidth = 2
        taskStatusLabel.layer.cornerRadius = 10.0
        taskStatusLabel.textAlignment = NSTextAlignment.center
        taskStatusLabel.adjustsFontSizeToFitWidth = true
        self.contentsView.addSubview(taskStatusLabel)
        
        //タスク更新用ビュー
        taskUpdateView.frame = CGRect(x: 60, y: 310 + 5 , width: Int(self.contentsView.bounds.width) - 60*2 , height: 100)
        taskUpdateView.backgroundColor = UIColor.systemPink
        taskUpdateView.layer.cornerRadius = 20.0
        taskUpdateView.layer.borderColor = UIColor.black.cgColor
        taskUpdateView.layer.borderWidth = 2.5
        self.contentsView.addSubview(taskUpdateView)
        
        //タスク更新入力を指示するラベル
        messageLabel.frame = CGRect(x: 15, y: 10 , width: Int(self.taskUpdateView.bounds.width) - 15*2 , height: 50)
        messageLabel.numberOfLines = 2
        messageLabel.text = "追加する工数を\n入力していください"
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.textColor = UIColor.white
        taskUpdateView.addSubview(taskUpdateTextField)
        
        //タスク更新用テキストフィールド
        taskUpdateTextField.frame = CGRect(x: 15, y: 60 , width: Int(self.taskUpdateView.bounds.width) - 40*2 , height: 30)
        taskUpdateTextField.attributedPlaceholder = NSAttributedString(string: "工数", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        taskUpdateTextField.borderStyle = .roundedRect
        taskUpdateTextField.keyboardType = .numberPad
        taskUpdateTextField.clearButtonMode = .always
        taskUpdateTextField.delegate = self
        taskUpdateView.addSubview(messageLabel)
        
        //タスク更新用テキストフィールドの横に設置するラベル
        let wordH = UILabel()
        wordH.frame = CGRect(x: 210, y: 70, width: 20, height: 20)
        wordH.text = "H"
        wordH.font = UIFont.boldSystemFont(ofSize: 18)
        wordH.textColor = UIColor.white
        taskUpdateView.addSubview(wordH)
        
        //テーブルビュー (小タスクがなかったら表示しない)
        if self.smallTaskArray[0] != "No_Small_Task0" {
            tableView.frame = CGRect(x: 0, y: 450, width: self.contentsView.bounds.width , height: 330)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "smalltask")
            contentsView.addSubview(tableView)
        }
        
        //更新ボタン
        updateTaskButton.frame = CGRect(x:contentsView.bounds.width/2 -  contentsView.bounds.width/8 , y:800,width:contentsView.bounds.width/4, height:35)
        updateTaskButton.layer.borderWidth = 2
        updateTaskButton.backgroundColor = UIColor.init(
            red:0.9, green: 0.9, blue: 0.9, alpha: 1)
        updateTaskButton.setTitleColor(UIColor.red , for: .normal)
        updateTaskButton.setTitle("更新", for: .normal)
        updateTaskButton.layer.cornerRadius = 10.0
        updateTaskButton.addTarget(self,action: #selector(self.didTapUpdateButton(_ :)),for: .touchUpInside)
        contentsView.addSubview(updateTaskButton)
    
        
        let scrollFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.frame = scrollFrame
        
        let contentRect = contentsView.bounds
        scrollView.contentSize = CGSize(width: contentRect.width, height: contentRect.height)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.allowsMultipleSelection = true
        
    }
    
    //ホーム画面へ遷移
    @objc func didTapGoToMainPage(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapUpdateButton(_ sender: Any) {
        let taskStatus = taskUpdateTextField.text
        if taskStatus!.isAlphanumeric() {
            if Int(taskStatus!)! + Int(self.taskStatus!)! <= Int(self.taskPlan!)! {
                db.collection("tasks").document(taskID!).updateData([
                    "status" : String(Int(taskStatus!)! + Int(self.taskStatus!)! )
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print()
                        print("Document successfully updated")
                    }
                }
                var index = 0
                for item in self.smallTaskArray {
                    db.collection("smalltasks").document(taskID!).setData(["smalltask\(index)":item], merge: true)
                    index = index + 1
                }
                self.dismiss(animated: true, completion: nil)
            }
            alert(title: "工数入力エラー", message: "工数を過ぎてしまいます")
        } else {
            alert(title: "工数入力エラー", message: "工数には半角数字を入力してください")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
}
