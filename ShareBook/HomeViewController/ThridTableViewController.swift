//
//  ThridViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/20.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import SVProgressHUD

class ThirdTableViewController: UITableViewController {
    @IBOutlet var thirdTableView: UITableView!
    
    
        // 投稿(isLikedのみ)データを格納する配列
        var postArray: [PostData] = []
        // 投稿全データを格納する配列
        var postArrayAll: [PostData] = []
        var num:Int = 0
        
    // Firestoreのリスナー
        var listener: ListenerRegistration!

        override func viewDidLoad() {
            super.viewDidLoad()
            thirdTableView.delegate = self
            thirdTableView.dataSource = self
            thirdTableView.backgroundColor = .rgb(red: 240, green: 240, blue: 240)

        }
    //MARK:-表示データの読み込み
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("DEBUG_PRINT: viewWillAppear")

            if Auth.auth().currentUser != nil {
                // ログイン済み
                if listener == nil {
                    
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                    listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArrayAll = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document) //(引数名：型)
                            
//                            print("DEBUG_PRINT: \(postData.isLiked)")
//                            print("DEBUG_PRINT: \(postData.name)")
//                            print("DEBUG_PRINT: \(postData.date)")

                            return postData
                        }
//MARK:- postArrayAllからisLiked = trueのみ抽出して「postArray」
                        // 配列の初期化
                        self.postArray = []
                        print("DEBUG_PRINT:postArrayAll数\(self.postArrayAll.count)")
                        for count in 0...(self.postArrayAll.count - 1){
                            print("DEBUG_PRINT:count\(count)")
                                if self.postArrayAll[count].isLiked == true {
                                    print("DEBUG_PRINT:isLiked判定")
                                    self.postArray.append(self.postArrayAll[count])
                                    self.num += 1

                            }
                        }
//MARK:-
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                    }
                }
            } else {
                // ログイン未(またはログアウト済み)
                if listener != nil {
                    // listener登録済みなら削除してpostArrayをクリアする
                    listener.remove()
                    listener = nil
                    postArray = []
                    tableView.reloadData()
                }
            }
        }

        // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 10
            
            return postArray.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
//        if  postArray[indexPath.row].isLiked == true {
            
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellThree", for: indexPath) as! TableViewCellThree
            cell.setPostData(postArray[indexPath.row])
           
            // セル内のボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)

            return cell
            }
//        else{
////            let cell = tableView.dequeueReusableCell(withIdentifier: "CellThree", for: indexPath) as! TableViewCellThree
//
//            return
            
            
//            }
            
//        }
    //MARK:- 行間の幅
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            //最低の行の高さ
            thirdTableView.estimatedRowHeight = 20
            return UITableView.automaticDimension //自動的に高さ設定
        }
        
    //MARK: - セルをタップした時の処理(画面切り替え)...画像とコメントを表示する
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("test")
            
            //FirstChildVCのインスタンス取得
            let childViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableOneChild") as! ChildViewController
        
    //MARK: - 子ビューへの引き渡し
            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath.row]
            
            //遷移先のプロパティ(postData)に情報セット
            childViewController.postData = postData
            
            //データ引き渡しと画面切り替え
            self.present(childViewController, animated: true, completion: nil) //画面切り替え
            
            //選択状態を削除
            tableView.deselectRow(at: indexPath, animated: true)

        }
        
    //MARK:- セル内のボタンがタップされた時に呼ばれるメソッド
        @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
            print("DEBUG_PRINT: likeボタンがタップされました。")
            
            // タップされたセルのインデックスを求める
              let touch = event.allTouches?.first
              let point = touch!.location(in: self.tableView)
              let indexPath = tableView.indexPathForRow(at: point)

              // 配列からタップされたインデックスのデータを取り出す
              let postData = postArray[indexPath!.row]
            
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            
                let alert: UIAlertController = UIAlertController(title: "確認", message: "お気に入りから削除してもいいですか？", preferredStyle:  .alert)

                    // ② Actionの設定
                    // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                    // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                    // OKボタン
            
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style:.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("DEBUG_PRINT: OK")
                        // HUDで処理中を表示
                        SVProgressHUD.show()
                        
//MARK:- likes更新
                        // likesを更新する
                        if let myid = Auth.auth().currentUser?.uid {
                            // 更新データを作成する
                            var updateValue: FieldValue
                            if postData.isLiked {
                                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                                updateValue = FieldValue.arrayRemove([myid])
                            } else {
                                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                                updateValue = FieldValue.arrayUnion([myid])
                            }
                            // likesに更新データを書き込む
                            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                            postRef.updateData(["likes": updateValue])
                        }
                        //DispatchQueue.main.asyncAfter記述後の処理は1.0秒後に実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                         SVProgressHUD.dismiss() // HUDを消す
                        }
                        
            })
                // キャンセルボタン
                        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                            print("DEBUG_PRINT: Cancel")
                        })
            // ③ UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)

            // ④ Alertを表示
                present(alert, animated: true, completion: nil)
            
            
            
        }
    //MARK: -

    }
extension ThirdTableViewController : IndicatorInfoProvider {
    //サブタイトル
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: " ACCOUNT", image: UIImage(named: "profile"))
        return IndicatorInfo(image: UIImage(named: "profile"))
    }

}
