//
//  FirstViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/20.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class FirstTableViewController: UITableViewController{
    
    @IBOutlet var firstTableView: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    // Firestoreのリスナー
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstTableView.delegate = self
        firstTableView.dataSource = self
        firstTableView.backgroundColor = .rgb(red: 240, green: 240, blue: 240)
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
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
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
        
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOne", for: indexPath) as! TableViewCellOne
        cell.setPostData(postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
//MARK:- 行間の幅
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //最低の行の高さ
        firstTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension //自動的に高さ設定
    }
    
//MARK: - セルをタップした時の処理(画面切り替え)...画像とコメントを表示する
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
        
        //FirstChildVCのインスタンス取得
        let firstTableChildViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableOneChild") as! FirstChildViewController
    
//MARK: - 子ビューへの引き渡し
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath.row]
        
        //遷移先のプロパティ(postData)に情報セット
        firstTableChildViewController.postData = postData
        
        //データ引き渡しと画面切り替え
        self.present(firstTableChildViewController, animated: true, completion: nil) //画面切り替え
        

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
    }
//MARK: -

}
extension FirstTableViewController : IndicatorInfoProvider {
    //TabBarサブタイトル
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {//        return IndicatorInfo(title: " HOME", image: UIImage(named: "home"))
        return IndicatorInfo(image: UIImage(named: "home"))
        
    }
}
