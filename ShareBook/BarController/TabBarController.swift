//
//  TabBarController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController,UITabBarControllerDelegate {
    
//MARK:-　バッチアイテムで使用
    let dt = Date()
    var dayInterval:Int = 0
   
    
//MARK:- 表示データの読み込み(日付順) -目的：バッチアイテム出力「new」のためにnewsArrayの日付取得
    // 投稿データを格納する配列
    var newsArray: [NewsData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    var dateString = ""
    var dateStringNow = ""

    
//MARK: - ログイン有無の確認 -目的：バッチアイテム出力「new」のためにnewsArrayの日付取得
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil) //画面切り替え
            self.present(loginViewController!, animated: true, completion: {() -> Void in print("処理完了")})
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
        
        

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
                    print("DEBUG_PRINT: ニュース投稿最新日付\(self.newsArray[2].date!)")
                    print("DEBUG_PRINT: 現時点の日付 \(self.dt)")
                    
                    //２つの日付(現時点と投稿資料の最新日付)を比較して差を整数で取得
                    let dayInterval = (Calendar.current.dateComponents([.day], from: self.newsArray[0].date!, to: self.dt)).day
                    
                    print("DEBUG_PRINT: インターバル整数\(dayInterval!)")
                    
                    //インターバルが3日未満の情報であれば「new」をつける
                    if dayInterval! < 3 {
                        //ニュースに「new」バッチアイテム
                        self.tabBar.items![2].badgeValue = "new"
                    }
                }
            }
        } else {
            // ログイン未(またはログアウト済み)
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                newsArray = []
            }
        }
        

        
    }

//MARK:-  タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if viewController is ImageSelectViewController {
                // ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
                let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
                present(imageSelectViewController, animated: true)
                return false
            }
            else if viewController is NewsViewController {
                // NewsViewControllerは、タブ切り替えではなくモーダル画面遷移する
                let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "News")
                present(imageSelectViewController, animated: true)
                return false
            }
            else {
                // その他（設定）のViewControllerは通常のタブ切り替えを実施
                return true
            }
        }
    
    //ボタン押下時の呼び出しメソッド
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
           //バッチを消す。
           item.badgeValue = nil
       }
}
