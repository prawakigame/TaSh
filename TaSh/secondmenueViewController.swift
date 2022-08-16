//
//  secondmenueViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2020/12/15.
//

//タスク作成画面

import UIKit
import Firebase
import FirebaseFirestoreSwift


extension String {
    
    func remove(characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
    // 半角数字の判定
    func isAlphanumeric() -> Bool {
        return self.range(of: "[^0-9]+", options: .regularExpression) == nil && self != ""
    }
}

/*------小タスクのデータ---------------------------------------------*/
class smallTask {
    var staskName : String
    
    init(name: String) {
        self.staskName = name
    }
}

class secondmenueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    /*-------変数、定数宣言-----------------------------------------*/
    //警告用のインスタンスを持ってくる
    var alertController: UIAlertController!
    
    //データベースのインスタンスを持ってくる
    let db = Firestore.firestore()
    
    //タスク作成者 ⇨ MainPageから受け取る
    var taskAuthor : String?
    
    //pickerViewの中身を定義
    let compos = [[" 高優先 "," 中優先 "," 低優先 "],[" 設計 "," 開発 "," 学習 "," 料理 "," 掃除 "]]
    
    //タスクの優先度と種類識別番号
    var compo_row1 : Int = 0
    var compo_row2 : Int = 0
    
    //小タスクの個数
    var smallTaskNum : Int = 3
    
    //小タスクの格納用変数
    var smallTaskArray: [smallTask] = []
    
    var taskType : String = ""
    var taskPrime : String = "優先度未設定"
    
    var taskKEY : Int = 0
    
    
    /*----------アシスタントエディタ宣言----------------------------*/
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    
    let mainView = UIView()
    let titleLabel = UILabel()
    let taskNameTextField = UITextField()
    let taskCreatorTextField = UITextField()
    let taskPlanTextField = UITextField()
    let message1Label = UILabel()
    let message2Label = UILabel()
    let message3Label = UILabel()
    let infoLabel = UILabel()
    let makeSmallTaskButton = UIButton()
    
    let tableView = UITableView()
    let makeTaskButton = UIButton()
    let cancelButton = UIButton()
    
    let taskPickerView = UIPickerView()
    
    
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*----------tableView-------------------------------------*/
    //セルが選択されたら実行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = self.tableView(tableView, cellForRowAt: indexPath)
        
    }
    
    //1セクションの行数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smallTaskArray.count
    }
    
    //セルのレイアウトを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallTask", for: indexPath)
        let item = smallTaskArray[indexPath.row]
        ///        cell.textLabel?.text = self.smallTaskArray[indexPath.row].staskName
        ///        cell.accessoryType = item.done ? .checkmark : .none
        cell.textLabel?.text = item.staskName
        return cell
    }
    
    //セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "やること"
    }
    
    //セルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // アイテム削除処理
        self.smallTaskArray.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    /*--------------------pickerView---------------------------------*/
    //pickeViewが選択された時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        let item = compos[component][row]
        
        let row1 = pickerView.selectedRow(inComponent: 0)
        let row2 = pickerView.selectedRow(inComponent: 1)
        
        self.compo_row1 = row1
        self.compo_row2 = row2
        
        let item1 = self.pickerView(pickerView, titleForRow: row1, forComponent: 0)
        let item2 = self.pickerView(pickerView, titleForRow: row2, forComponent: 1)
        
        self.taskPrime = item1!
        self.taskType = item2!
    }
    
    //pickerViewのコンポーネントの数を返す
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return compos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = compos[component][row]
        return item
    }
    
    //pickerViewの各コンポーネントの行数を返す
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let compo = compos[component]
        return compo.count
    }
    
    //pickerViewのレイアウトを設定
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 60
        } else {
            return 200
        }
    }
    
    //pickerViewのクエスチョンマークが出るのを改善するための無理矢理コード
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,forComponent component: Int, reusing view: UIView?) -> UIView{
        let label = UILabel()
        label.text = compos[component][row]
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    //アラートのフォーマット作成
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    //タスク作成する
    @objc func didTapMakeTaskButton(_ sender: Any) {
        //cloud firestoreにデータを送る
        let taskName = taskNameTextField.text ?? ""
        let creator = taskCreatorTextField.text ?? ""
        let plan = taskPlanTextField.text ?? ""
        
        //工数欄が 半角数字 かつ 1日以内 の時にタスク作成
        if plan.isAlphanumeric() {
            if Int(plan)! <= 24  && Int(plan)! >= 1 {
                if taskName.remove(characterSet: .whitespaces) != "" && creator.remove(characterSet: .whitespaces) != "" && plan.remove(characterSet: .whitespaces) != "" {
                    //小タスクが作成されていない時、無理矢理作る
                    if smallTaskArray.isEmpty{
                        let showNoTask: smallTask = smallTask(name: "No_Small_Task")
                        self.smallTaskArray.append(showNoTask)
                    }
                    
                    //smalltaskの個数
                    var index = 0
                    
                    //送るタスクのデータを生成
                    let data: [String: Any] = ["taskName": taskName, "creator" : creator, "plan" : plan, "status" : "0", "type" : taskType, "prime" : taskPrime]
                    
                    //タスクデータコレクションを生成
                    db.collection("tasks").document(taskAuthor! + String(Auth.auth().currentUser!.uid.prefix(10))+String(taskKEY)).setData(data, merge: true)
                    
                    //コレクション名を退避
                    let docName : String = taskAuthor! + String(Auth.auth().currentUser!.uid.prefix(10))+String(taskKEY)
                    
                    //小タスクコレクションを生成
                    for item in self.smallTaskArray {
                        db.collection("smalltasks").document(docName).setData(["smalltask\(index)":item.staskName + String(0)], merge: true)
                        index = index + 1
                    }
                    taskKEY = 0
                    self.dismiss(animated: true, completion: nil)
                } else {
                    alert(title: "入力エラー", message: "タスク名、作者、工数は必ず入力してください")
                }
            } else {
                alert(title: "工数設定エラー", message: "設定できる工数は24以内です")
            }
        } else {
            alert(title: "工数入力エラー", message: "半角数字以外を入力しないでください")
        }
    }
    
    //小タスク追加用ボタン
    @objc func addSmallTaskButton(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しい小タスクを追加", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let decideAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            let staskName = String(textField.text!)
            if staskName.remove(characterSet: .whitespaces) != "" {
                // アイテム追加処理
                let newSmallTask: smallTask = smallTask(name: staskName)
                self.smallTaskArray.append(newSmallTask)
                self.tableView.reloadData()
                
            }
            
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "小タスク"
            textField = alertTextField
        }
        
        alert.addAction(cancelAction)
        alert.addAction(decideAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //描画
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentsView.backgroundColor = UIColor.systemPurple
        
        let scrollFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.frame = scrollFrame
        
        let contentRect = contentsView.bounds
        scrollView.contentSize = CGSize(width: contentRect.width, height: contentRect.height)
        
        taskPickerView.delegate = self
        taskPickerView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        mainView.frame = CGRect(x: 0, y: 0, width: self.contentsView.bounds.width, height: self.contentsView.bounds.height - 120)
        mainView.backgroundColor = UIColor.init(red: 0.2, green: 1, blue: 0.1, alpha: 0.6)
        self.view.addSubview(mainView)
        self.scrollView.addSubview(mainView)
        
        contentsView.addSubview(mainView)
        
        titleLabel.frame = CGRect(x: (mainView.bounds.width/16) * 4 , y: 38, width: 8 * (mainView.bounds.width/16 ), height: mainView.bounds.height/6 )
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "タスク作成"
        mainView.addSubview(titleLabel)
        
        infoLabel.frame = CGRect(x: mainView.bounds.width/8 , y: 120, width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/12 )
        infoLabel.text = "タスクの情報を入力してください"
        infoLabel.textAlignment
            = NSTextAlignment.center
        infoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        infoLabel.numberOfLines = 2
        infoLabel.adjustsFontSizeToFitWidth = true
        mainView.addSubview(infoLabel)
        
        message1Label.frame = CGRect(x: mainView.bounds.width/8 , y: 160, width: mainView.bounds.width/2, height: mainView.bounds.height/8 )
        message1Label.text = "タスク名"
        mainView.addSubview(message1Label)
        
        taskNameTextField.frame = CGRect(x: mainView.bounds.width/8, y: 235 , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/18)
        taskNameTextField.placeholder = "Task Name"
        taskNameTextField.backgroundColor = UIColor.white
        taskNameTextField.layer.cornerRadius = 10
        mainView.addSubview(taskNameTextField)
        
        message2Label.frame = CGRect(x: mainView.bounds.width/8 , y: 245, width: mainView.bounds.width/2, height: mainView.bounds.height/8 )
        message2Label.text = "タスクの作成者"
        mainView.addSubview(message2Label)
        
        taskCreatorTextField.frame = CGRect(x: mainView.bounds.width/8, y: 320 , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/18)
        taskCreatorTextField.backgroundColor = UIColor.white
        taskCreatorTextField.layer.cornerRadius = 10
        taskCreatorTextField.placeholder = "Task Creator"
        mainView.addSubview(taskCreatorTextField)
        
        message3Label.frame = CGRect(x: mainView.bounds.width/8 , y: 330, width: mainView.bounds.width/2, height: mainView.bounds.height/8 )
        message3Label.text = "タスクの工数"
        mainView.addSubview(message3Label)
        
        taskPlanTextField.frame = CGRect(x: mainView.bounds.width/8, y: 405 , width: 6 * (mainView.bounds.width/8 ), height: mainView.bounds.height/18)
        taskPlanTextField.backgroundColor = UIColor.white
        taskPlanTextField.layer.cornerRadius = 10
        taskPlanTextField.placeholder = "Task Plan"
        mainView.addSubview(taskPlanTextField)
        
        taskPickerView.frame = CGRect(x: 0, y: 500, width: mainView.bounds.width, height: mainView.bounds.height/11)
        mainView.addSubview(taskPickerView)
        
        tableView.frame = CGRect(x: 0, y: 700, width: self.contentsView.bounds.width , height: 280)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "smallTask")
        contentsView.addSubview(tableView)
        
        
        makeSmallTaskButton.frame = CGRect(x: (contentsView.bounds.width / 20 ) * 16, y: 703, width: (contentsView.bounds.width / 20 ) * 3, height: 18)
        makeSmallTaskButton.setTitle("追加", for: .normal)
        makeSmallTaskButton.setTitleColor(UIColor.white , for: .normal)
        makeSmallTaskButton.backgroundColor = UIColor.blue
        makeSmallTaskButton.addTarget(self,action: #selector(self.addSmallTaskButton(_ :)),for: .touchUpInside)
        //        makeSmallTaskButton.titleLabel?.font = UIFont(name: "追加", size: 8)
        contentsView.addSubview(makeSmallTaskButton)
        
        makeTaskButton.frame = CGRect(x: (mainView.bounds.width / 16) * 9, y: contentsView.bounds.height - 100, width: (mainView.bounds.width / 16 ) * 5, height: 44)
        makeTaskButton.setTitle("タスク作成", for: .normal)
        makeTaskButton.setTitleColor( UIColor.white, for: .normal )
        makeTaskButton.backgroundColor = UIColor.red
        makeTaskButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        makeTaskButton.layer.cornerRadius = 20.0
        makeTaskButton.titleLabel?.adjustsFontSizeToFitWidth = true
        makeTaskButton.addTarget(self,action: #selector(self.didTapMakeTaskButton(_ :)),for: .touchUpInside)
        contentsView.addSubview(makeTaskButton)
        
        cancelButton.frame = CGRect(x: (mainView.bounds.width / 16) * 2, y: contentsView.bounds.height - 100, width: (mainView.bounds.width / 16 ) * 5, height: 44)
        cancelButton.setTitle("ホームへ", for: .normal)
        cancelButton.setTitleColor( UIColor.white, for: .normal )
        cancelButton.backgroundColor = UIColor.red
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        cancelButton.layer.cornerRadius = 20.0
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.addTarget(self,action: #selector(self.didTapCancelButton(_ :)),for: .touchUpInside)
        contentsView.addSubview(cancelButton)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
}
