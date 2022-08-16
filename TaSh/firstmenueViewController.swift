//
//  firstmenueViewController.swift
//  TaSh
//
//  Created by katsuma saito on 2020/12/15.
//

import UIKit

class firstmenueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentsView: UIView!
    
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

    //タスク作成者 ⇨ MainPageから受け取る
    var taskAuthor : String?
    
    //タスク名
    var taskName : String?
    
    //タスクの工数
    var taskPlan : String?
    
    //タスクの実績
    var taskStatus : String?
    
    //タスクの優先度
    var taskPrime : String?
    
    //タスクの種類
    var taskType : String?
    
    //小タスクの格納用データ
    var smallTaskArray : [String] = []
    
    //pickerViewの中身を定義
    let arrayDetail = [" 設計 "," 開発 "," 学習 "," 料理 "," 掃除 "]
    let arrayPrime = [" 高優先 "," 中優先 "," 低優先 "]
    
    var compo_row1 : Int = 0
    var compo_row2 : Int = 0
    
    @objc func didTapGoToMainPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.smallTaskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "smallTask")
        let cellData = smallTaskArray[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = String(cellData.dropLast())
        
        if cellData.suffix(1) == "1" {
            cell.accessoryType = .checkmark
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "やること"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //contentsViewの幅を取得
        let contentsViewWidth = Float(self.contentsView.bounds.size.width)
        
        contentsView.backgroundColor = UIColor.cyan
        
        let taskInfoLabelHeight : Int = 30
        
        //メインメニューへ戻るボタン
        let backButton = UIButton()
        backButton.frame = CGRect(x:contentsView.bounds.width *  (280/375), y:contentsView.bounds.height * (22/880), width:contentsView.bounds.width *  (78/375) , height:contentsView.bounds.height * (30/880))
        backButton.setTitle("戻る", for: .normal)
        backButton.backgroundColor = UIColor.blue
        backButton.setTitleColor(UIColor.yellow, for:.normal)
        backButton.layer.cornerRadius = 10.0
        contentsView.addSubview(backButton)
        backButton.addTarget(self,action: #selector(self.didTapGoToMainPage(_ :)),for: .touchUpInside)
        
        //タスクの優先度ラベル
        taskPrimeLabel.frame = CGRect(x : CGFloat(Int((contentsViewWidth - Float(80))/2)) , y: contentsView.bounds.height * (40/880), width: contentsView.bounds.width *  (80/375), height: contentsView.bounds.height * (40/880))
        taskPrimeLabel.text = self.taskPrime
        taskPrimeLabel.font = UIFont.systemFont(ofSize: 40)
        taskPrimeLabel.textColor = UIColor.black
        taskPrimeLabel.adjustsFontSizeToFitWidth = true
        self.contentsView.addSubview(taskPrimeLabel)
        
        //タスクの名前ラベル
        taskNameLabel.frame =
            CGRect(x : CGFloat(Int((contentsViewWidth - Float(300))/2)) , y: contentsView.bounds.height * (70/880), width: contentsView.bounds.width *  (300/375), height: contentsView.bounds.height * (120/880))
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
        
        //テーブルビュー (小タスクがなかったら表示しない)
        if self.smallTaskArray[0] != "No_Small_Task0" {
            tableView.frame = CGRect(x: 0, y: 450, width: self.contentsView.bounds.width , height: 330)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "smalltask")
            contentsView.addSubview(tableView)
        }
        
        let scrollFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.frame = scrollFrame
        
        let contentRect = contentsView.bounds
        scrollView.contentSize = CGSize(width: contentRect.width, height: contentRect.height)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
