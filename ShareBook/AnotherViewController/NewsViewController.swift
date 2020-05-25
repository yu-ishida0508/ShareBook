//
//  NewsViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var newsTableView: UITableView!
    
    // 投稿データを格納する配列
        var newsArray: [NewsData] = []
        
        // Firestoreのリスナー
        var listener: ListenerRegistration!

        override func viewDidLoad() {
            super.viewDidLoad()
            newsTableView.delegate = self
            newsTableView.dataSource = self
            newsTableView.backgroundColor = .rgb(red: 240, green: 240, blue: 240)
        }
    //MARK:-表示データの読み込み(日付順)
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("DEBUG_PRINT: viewWillAppear")

            if Auth.auth().currentUser != nil {
                // ログイン済み
                if listener == nil {
                    // listener未登録なら、登録してスナップショットを受信する
                    let newsRef = Firestore.firestore().collection(Const.NewsPostPath).order(by: "date", descending: true)
                    listener = newsRef.addSnapshotListener() { (querySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、newsArrayの配列にする。
                        self.newsArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let newsData = NewsData(document: document)
                            return newsData
                        }
                        
                        // TableViewの表示を更新する
                        self.newsTableView.reloadData()

                    }
                }
            } else {
                // ログイン未(またはログアウト済み)
                if listener != nil {
                    // listener登録済みなら削除してpostArrayをクリアする
                    listener.remove()
                    listener = nil
                    newsArray = []
                    self.newsTableView.reloadData()
                }
            }
        }

        // MARK: - Table view data source

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 10
            return newsArray.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellNews", for: indexPath) as! TableViewCellNews
            cell.setNewsData(newsArray[indexPath.row])

            return cell
        }
    //MARK:- 行間の幅
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            //最低の行の高さ
            newsTableView.estimatedRowHeight = 10
            return UITableView.automaticDimension //自動的に高さ設定

        }
        
    //MARK: - セルをタップした時の処理(画面切り替え)...画像とコメントを表示する
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            print("test")
// 
//
//            //FirstChildVCのインスタンス取得
//            let childViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableOneChild") as! ChildViewController
        
    //MARK: - 子ビューへの引き渡し
            // 配列からタップされたインデックスのデータを取り出す
//            let postData = postArray[indexPath.row]
//
//            //遷移先のプロパティ(postData)に情報セット
//            childViewController.postData = postData
//
//            //データ引き渡しと画面切り替え
//            self.present(childViewController, animated: true, completion: nil) //画面切り替え
//
//            //選択状態を削除
//            tableView.deselectRow(at: indexPath, animated: true)
//

//        }
    //MARK: -

    }
