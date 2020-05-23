//
//  PostViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    //作者名
    @IBOutlet weak var textField: UITextField!
    //読んで欲しい人へ
    @IBOutlet weak var textView: UITextView!
    
//MARK:- 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        
        print("DEBUG_PRINT: 投稿ボタンを押下しました")
            //テキスト未入力時には何も返さない
            guard let addComment = textView.text else{
                   return //textView.text nilならここ
            }
            if addComment.isEmpty{
                   SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                   //呼び出しクラスに何もないことを返却(return)する
                // HUDを消す
                //DispatchQueue.main.asyncAfter記述後の処理は1.0秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
                }
                   return
               }
        
        // 画像をJPEG形式に変換する
        let imageData = image.jpegData(compressionQuality: 0.75)
        // 画像と投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
                }
                return
            }
            // FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let uid = Auth.auth().currentUser?.uid
            let email = Auth.auth().currentUser?.email
            let postDic = [
                "name": name!,                       //投稿者名
                "writer": self.textField.text!,     //作者名
                "feelings": self.textView.text!,     //コメント
                "date": FieldValue.serverTimestamp(),
                "uid": uid!,//ユーザID
                "e-mail": email!,//ユーザe-mail
                ] as [String : Any]
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
           UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
             SVProgressHUD.dismiss()
            }
        }
    }
//MARK:- キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
 
    }

    //MARK: -　画面外をタップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
//MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        
        //それぞれViewの角を丸く
        imageView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        
    }
}
