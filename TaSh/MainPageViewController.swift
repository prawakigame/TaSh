//
//  MainPageViewController.swift
//  Pods
//
//  Created by katsuma saito on 2020/12/04.
//

// タスクの個人ごとの数を設定する機能は後でやる

//メイン画面

import UIKit
import Firebase
import FirebaseDatabase

//作成できるタスクの工数
let taskLimit : Int = 10

//サーバから受け取ったタスクのデータを格納用クラス
class taskData : NSObject{
    var taskID : String?
    var taskName : String?
    var creator : String?
    var plan : String?
    var status : String?
    var prime : String?
    var type : String?
    
    init(document: QueryDocumentSnapshot) {
        self.taskID = document.documentID
        let Dic = document.data()
        self.taskName = Dic["taskName"] as? String
        self.creator = Dic["creator"] as? String
        self.plan = Dic["plan"] as? String
        self.status = Dic["status"] as? String
        self.prime = Dic["prime"] as? String
        self.type = Dic["type"] as? String
    }
}

//サーバから受け取った小タスクのデータ格納用クラス
class smallTaskData : NSObject{
    var taskName : [String] = []
    var status : Bool?
    
    init(document: QueryDocumentSnapshot) {
        let Dic = document.data()
        
        var index = 0
        while Dic["smalltask" + String(index)] != nil {
            self.taskName.append(Dic["smalltask" + String(index)] as! String)
            index = index + 1
        }
    }
}

class MainPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //データベースの参照先を取得
    let db = Firestore.firestore()
    
    //ログインしているユーザ名
    var userName : String?
    
    //タスクの生成個数　⇨　初期値は０
    var taskNum : Int = 0
    
    //タスクのデータ格納先
    var taskDataArray : [taskData]  = []
    
    //小タスクのデータ格納先
    var sTaskDataArray : [smallTaskData] = []
    
    //menue１に送るタスクデータ
    var giveTaskData : taskData!
    var giveSmallTaskData : smallTaskData!
    
    //タスクの更新か判断
    var updateTaskEnable : Bool = false
    
    //タイマー用のインスタンス。繰り返し実行用
    var timer = Timer()
    
    var taskIDKey : Int = 0
    
    //タスクの一番後ろに付く識別用番号
    var taskIsExist  = Array(repeating: false, count: taskLimit)
    
    //タスクの番号
    var TASKKEY : Int = 0
    
    let updateTaskButton = UIButton()
    let makeTaskButton = UIButton()
    let signoutButton = UIButton()
    let logoutButton = UIButton()
    
    
    
    //警告画面表示
    var alertController : UIAlertController!
    
    //collection view 宣言
    @IBOutlet weak var collectionView: UICollectionView!
    
    //各 button 宣言
//    @IBOutlet weak var updateInfoButton: UIButton!
//    @IBOutlet weak var logoutButton: UIButton!
//    @IBOutlet weak var makeTaskButton: UIButton!
//    @IBOutlet weak var signoutButton: UIButton!
    
    //警告画面を出力
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    /*------ collection View ---------------------------------------*/
    //コレクションビューのセル数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.taskDataArray.count
    }
    
    //コレクションビューのセルのレイアウトを設定
    //タスク消去時の設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        let cellImage = UIImage(named: "task.png")
        imageView.image = cellImage
        
        //工数を満たしたタスクを削除する
        if self.taskDataArray[indexPath.row].plan == self.taskDataArray[indexPath.row].status {
            
            //削除直前タスクの色を青色にする
            cell.backgroundColor = .blue
            
            //削除されるタスクの番号を保持
            let deleteTaskName = self.taskDataArray[indexPath.row].taskID!
            let deleteTaskKEY =  Int(deleteTaskName.suffix(1))
            //サーバからタスクを削除
            db.collection("tasks").document(deleteTaskName).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("main task successfully removed!")
                    //サーバから小タスクを削除
                    self.db.collection("smalltasks").document(deleteTaskName).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("small task successfully removed!")
                            print("smallTask deleted : " + String(indexPath.row))
                            
                            //タスクを削除時、該当する番号にタスクないこと記憶
                            self.taskIsExist[deleteTaskKEY!] = false
                        }
                    }
                }
            }
            
        } else {
            cell.backgroundColor = .white
//            if self.updateTaskEnable == false {
//                if taskDataArray[indexPath.row].taskID?.prefix(taskIDKey + 10)  !=  self.userName! + Auth.auth().currentUser!.uid.prefix(10) {
//                    cell.backgroundColor = .lightGray
//                }
//            } else {
//                cell.backgroundColor = .white
//            }
        }
        cell.taskName.text = self.taskDataArray[indexPath.row].taskName
        cell.statusLabel.text = self.taskDataArray[indexPath.row].status! + " / " + self.taskDataArray[indexPath.row].plan! + " H"
        cell.statusLabel.textColor = .white
        return cell
    }
    
    //コレクションビューのセルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    //コレクションビューのセルが選択時に呼ばれる関数
    //画面遷移先に渡すデータをここで格納する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //debug
        print("選択したタスクのID" + self.taskDataArray[indexPath.row].taskID!)
        
        //コレクションビュー中の正しい位置のデータを格納
        let upDateTaskINDEX = Int((self.taskDataArray[indexPath.row].taskID?.suffix(1))!)
        print(upDateTaskINDEX!)
        
        
        giveTaskData = taskDataArray[indexPath.row]
        giveSmallTaskData = sTaskDataArray[indexPath.row]
        
        //タスクの識別子の文字列に利用
        taskIDKey = (self.userName?.utf8.count)!
        
        //タスクのデータ表示
        if updateTaskEnable == false {
            performSegue(withIdentifier: "toMenue1ViewController", sender: nil)
            
        //タスクのデータ更新
        } else if updateTaskEnable == true{
            //自分のタスクだったら編集可能
            if giveTaskData.taskID?.prefix(taskIDKey + 10)  ==  self.userName! + Auth.auth().currentUser!.uid.prefix(10) {
                performSegue(withIdentifier: "toInputTaskInfoViewController", sender: nil)
            } else {
            //他人のタスクだったら編集不可
                let dialog = UIAlertController(title: "編集不可", message: "タスク作成者以外の人は編集できません", preferredStyle: .alert)
                //ボタンのタイトル
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //実際に表示させる
                self.present(dialog, animated: true, completion: nil)
            }
        }
    }
    
    // タスク作成用の画面へ遷移
    @objc func didTapMakeTaskButton(_ sender: Any) {
        
        var taskCount : Int = 0
        
        //自分が作成したタスクを調べる
        for item in self.taskDataArray {
            //自分が作成したタスクがあれば番号だけ記憶
            if item.taskID?.prefix((self.userName?.utf8.count)! + 10) == self.userName! + Auth.auth().currentUser!.uid.prefix(10) {
                let subStr = String(item.taskID!.suffix(1))
                taskIsExist[Int(subStr)!] = true
            }
        }
        
        for item in self.taskIsExist {
            if item == true {
                taskCount = taskCount + 1
            }
        }
        
        //タスクの個数制限内なら作成する
        if taskCount != taskLimit {
            //自分が作成していない最小のタスク番号を見つける
            for (index, existTask) in taskIsExist.enumerated() {
                if existTask == false {
                    //他のページに渡す番号をセット
                    self.TASKKEY = index
                    
                    //画面遷移実行
                    performSegue(withIdentifier: "toMenue2ViewController", sender: nil)
                    break;
                }
            }
        } else {
            alert(title: "タスク制限",
                  message: "タスクを作りすぎです、どれか消してください")
        }
                
        print("mainpage maketask index:" + String(self.TASKKEY))
        print("---------------------------------------")
        print("0" + String(self.taskIsExist[0]))
        print("1" + String(self.taskIsExist[1]))
        print("2" + String(self.taskIsExist[2]))
        print("3" + String(self.taskIsExist[3]))
        print("4" + String(self.taskIsExist[4]))
        print("5" + String(self.taskIsExist[5]))
        print("6" + String(self.taskIsExist[6]))
        print("7" + String(self.taskIsExist[7]))
        print("8" + String(self.taskIsExist[8]))
        print("9" + String(self.taskIsExist[9]))
        print("---------------------------------------")
        print("taskCount" + String(taskCount))
        
    }
    
    //タスク更新用のボタンを押した時の動作
    @objc func didTapUpdateTaskInfoButton(_ sender: Any) {
        if(self.updateTaskEnable == true){
            self.updateTaskEnable = false
            updateTaskButton.setTitle("更新", for: .normal)
            makeTaskButton.isEnabled = true
            logoutButton.isEnabled = true
            signoutButton.isEnabled = true
            makeTaskButton.alpha = 1
            signoutButton.alpha = 1
            logoutButton.alpha = 1
            
        } else if (self.updateTaskEnable == false){
            self.updateTaskEnable = true
            updateTaskButton.setTitle("中止", for: .normal)
            makeTaskButton.isEnabled = false
            logoutButton.isEnabled = false
            signoutButton.isEnabled = false
            makeTaskButton.alpha = 0.3
            signoutButton.alpha = 0.3
            logoutButton.alpha = 0.3
        }
        print(collectionView.bounds.height)
        
    }
    
    
    //ログアウト画面への遷移
    @objc func didTapLogoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error siging out: %@", signOutError)
        }
    }
    
    //アカウント退会用のボタン
    @objc private func didTapSignOutButton(_ sender : Any) {
        let alert : UIAlertController = UIAlertController(title: "サインアウト許可確認", message: "TaShの会員から退会しますか？", preferredStyle: UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            for item in self.taskDataArray {
                if item.taskID?.prefix((self.userName?.utf8.count)! + 10) == self.userName! + Auth.auth().currentUser!.uid.prefix(10) {
                    
                    let deleteTaskKEY = Int(item.taskID!.suffix(1))
                    
                    self.db.collection("tasks").document(item.taskID!).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("task successfully removed!")
//                            print("smallTask deleted : " + String(indexPath.row))
                        }
                    }
                    
                    self.db.collection("smalltasks").document(item.taskID!).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("small task successfully removed!")
//                            print("smallTask deleted : " + String(indexPath.row))
                            
                            //タスクを削除時、該当する番号にタスクないこと記憶
                            self.taskIsExist[deleteTaskKEY!] = false
                            
                        }
                    }
                }
            }

            
            // ログイン中のユーザーアカウントを削除する。
            Auth.auth().currentUser?.delete{ error in
                // エラーが無ければ、ログイン画面へ戻る
                if error == nil{
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    self.showErrorIfNeeded(error)
                }
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //segueで遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //segueのIDを確認してから特定のsegueのみに実行
        
        if segue.identifier == "toMenue2ViewController" {
            let next = segue.destination as? secondmenueViewController
            next?.taskAuthor = self.userName!
            next?.taskKEY = self.TASKKEY
        } else if segue.identifier == "toMenue1ViewController" {
            let next = segue.destination as? firstmenueViewController
            //タスクの詳細情報のインデックスを受け取る
            next?.taskAuthor = giveTaskData.creator
            next?.taskName = giveTaskData.taskName
            next?.taskPlan = giveTaskData.plan
            next?.taskStatus = giveTaskData.status
            next?.smallTaskArray = giveSmallTaskData.taskName
            next?.taskPrime = giveTaskData.prime
            next?.taskType = giveTaskData.type
        } else if segue.identifier == "toInputTaskInfoViewController" {
            let next = segue.destination as? inputTaskInfoPageViewController
            next?.taskAuthor = giveTaskData.creator
            next?.taskName = giveTaskData.taskName
            next?.taskPlan = giveTaskData.plan
            next?.taskStatus = giveTaskData.status
            next?.taskID = giveTaskData.taskID
            next?.taskPrime = giveTaskData.prime
            next?.smallTaskArray = giveSmallTaskData.taskName
            next?.memoryTaskArray = giveSmallTaskData.taskName
            next?.taskKEY = self.TASKKEY
        }
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
    
    //データを読み取る
    func getData() {
        //データがあるコレクションを指定
        let Ref = db.collection("tasks")
        //getDocumentsでデータを取得
        Ref.getDocuments() { [self] (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            } else {
                //querySnapshotにドキュメントデータが配列になって入っている
                self.taskDataArray = querySnapshot!.documents.map { document in
                    let data = taskData(document: document)
                    return data
                }
            }
            self.collectionView.reloadData()
        }
        
        let sRef = db.collection("smalltasks")
        sRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            } else {
                self.sTaskDataArray = querySnapshot!.documents.map { document in
                    let data = smallTaskData(document: document)
                    return data
                }
            }
        }
    }
    
    /// 画面再表示 (segue遷移先から戻ってきた時に実行)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        //adjust layout size
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor.cyan
        
        let mainWidth = view.bounds.width / 20
//        let h = self.view.bounds.height - collectionView.bounds.height
//        makeTaskButton.frame = CGRect(x: mainWidth * 11, y: collectionView.bounds.height + (3/20) * (self.view.bounds.height - collectionView.bounds.height), width: mainWidth * 6, height: 40)
        makeTaskButton.frame = CGRect(x: mainWidth * 11.5, y: (580/667) * self.view.bounds.height, width: mainWidth * 6, height: (40/667) * self.view.bounds.height)
//        makeTaskButton.frame = CGRect(x: mainWidth * 11.5, y: collectionView.frame.height  , width: mainWidth * 6, height: (40/667) * self.view.bounds.height)
//        print(collectionView.bounds.height)
        makeTaskButton.setTitle("タスク作成", for: .normal)
        makeTaskButton.backgroundColor = UIColor.cyan
        self.view.addSubview(makeTaskButton)
        makeTaskButton.setTitleColor(UIColor.blue, for: .normal)
        makeTaskButton.layer.cornerRadius = 20
        makeTaskButton.addTarget(self,action: #selector(self.didTapMakeTaskButton(_ :)),for: .touchUpInside)
        
//        updateTaskButton.frame = CGRect(x: mainWidth * 3, y: collectionView.bounds.height + 10, width: mainWidth * 6, height: 40)
        
        updateTaskButton.frame = CGRect(x: mainWidth * 2.5, y: (580/667) * self.view.bounds.height, width: mainWidth * 6, height: (40/667) * self.view.bounds.height)
        updateTaskButton.backgroundColor = UIColor.yellow
        updateTaskButton.setTitle("タスク更新", for: .normal)
        view.addSubview(updateTaskButton)
        updateTaskButton.setTitleColor( UIColor.black, for: .normal )
        updateTaskButton.layer.cornerRadius = 20
        updateTaskButton.addTarget(self,action: #selector(self.didTapUpdateTaskInfoButton(_ :)),for: .touchUpInside)
        
        logoutButton.frame = CGRect(x: 0, y: view.bounds.height - 30, width: mainWidth * 6, height:30)
        logoutButton.backgroundColor = UIColor.systemRed
        logoutButton.setTitle("ログアウト", for: .normal)
        logoutButton.addTarget(self,action: #selector(self.didTapLogoutButton(_ :)),for: .touchUpInside)
        view.addSubview(logoutButton)
        
        signoutButton.frame = CGRect(x: view.bounds.width - mainWidth*3, y: view.bounds.height - 30, width: mainWidth * 3, height: 30)
        signoutButton.backgroundColor = UIColor.brown
        signoutButton.setTitle("退会", for: .normal)
        view.addSubview(signoutButton)
        signoutButton.addTarget(self,action: #selector(self.didTapSignOutButton(_ :)),for: .touchUpInside)
        
        
        //could not dequeue a view of kind: ~~というエラーが出た時の対処方法
        UINib(nibName: "UICollectionElementKindCell", bundle:nil)
        
        //認証状態をリッスンする
        let hundle = Auth.auth().addStateDidChangeListener{(auth, user) in
            //ログインしているユーザ名を持ってくる
            let username = user?.displayName
            self.userName = username
        }
        
        updateTaskButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.getData()
            self.collectionView.reloadData()
        })
    }
}
