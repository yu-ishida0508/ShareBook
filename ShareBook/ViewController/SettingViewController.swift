//
//  SettingViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var resetMailAddressTextField: UITextField!
    
//MARK: - ユーザ名変更
    @IBAction func handleChangeButton(_ sender: Any) {
 
        if let displayName = displayNameTextField.text {
                // ユーザ名が入力されていない時はHUDを出して何もしない
                if displayName.isEmpty {
                    SVProgressHUD.showInfo(withStatus: "ユーザ名を入力して下さい")
                    //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        SVProgressHUD.dismiss()
                    }
                    return
                }
            
            // HUDで処理中を表示
            SVProgressHUD.show()

                // ユーザ名を変更する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            SVProgressHUD.showError(withStatus: "ユーザ名の変更に失敗しました。")
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             SVProgressHUD.dismiss()
                            }
                            return
                        }
                        
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

                        // HUDで完了を知らせる
                        SVProgressHUD.showSuccess(withStatus: "ユーザ名を変更しました")
                        // HUDを消す
                        //DispatchQueue.main.asyncAfter記述後の処理は1.0秒後に実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         SVProgressHUD.dismiss()
                        }
                    }
                }
            }
            // キーボードを閉じる
            self.view.endEditing(true)
        }
//MARK: -ログアウト
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()

        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)

        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        tabBarController?.selectedIndex = 0
    }
//MARK: - パスワード変更「送信する」ボタン(ResetPassVCと同じ内容のため、修正時は要確認)
    @IBAction func sendButton(_ sender: Any) {
                if let address = resetMailAddressTextField.text {
                    // アドレスが入力されていない時は何もしない
                    if address.isEmpty {
                        print("DEBUG_PRINT: アドレスが未入力です。")
                        
                        SVProgressHUD.showError(withStatus: "アドレスを入力してください。")
                        //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         SVProgressHUD.dismiss()
                        }
                        
                        return
                    }
                    
        //TODO:-    メールの日本語化(Auth.auth().languageCode = "jp")
                    
                    // HUDで処理中を表示
                    SVProgressHUD.show()
                    // 送信先のメールアドレスを取得
                    let address = resetMailAddressTextField.text!
                       // 取得したメールアドレスを引数に渡す
                    Auth.auth().sendPasswordReset(withEmail: address) { (error) in
                           if error == nil {
                            // エラーが無ければ、パスワード再設定用のメールが指定したメールアドレスまで送信される。
                            // 届いたメールからパスワード再設定後、新しいパスワードでログインする事が出来る。
                            SVProgressHUD.showSuccess(withStatus: "メールを送信しました。")
                           

                            //DispatchQueue.main.asyncAfter記述後の処理は1.0秒後に実行
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             SVProgressHUD.dismiss() // HUDを消す
                                //loginVCへ画面切替え
                                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                                self.present(loginViewController!, animated: true, completion: nil) //画面切り替え
                            }
                            
                           }else{
                               print("エラー：\(String(describing: error?.localizedDescription))")
                            
                                SVProgressHUD.showError(withStatus: "メールの送信に失敗しました。")
                                //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                 SVProgressHUD.dismiss()
                                }
                           }
                       }
            }
        
        
    }
//MARK: - アカウント削除
    @IBAction func deleteUserAccountButton(_ sender: Any) {
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alert: UIAlertController = UIAlertController(title: "最終確認", message: "アカウントを削除してもいいですか？", preferredStyle:  .alert)

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
                    
                    let user = Auth.auth().currentUser //ログインユーザ情報取得
                    user?.delete { error in
                      if let error = error {
                        SVProgressHUD.showError(withStatus: "アカウント削除に失敗しました。")
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             SVProgressHUD.dismiss()
                            }
                            return
                        } else {
                        print("DEBUG_PRINT: アカウント削除に成功しました。")
                        SVProgressHUD.showSuccess(withStatus: "アカウント削除に成功")
                        //DispatchQueue.main.asyncAfter記述後の処理は1.0秒後に実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         SVProgressHUD.dismiss() // HUDを消す
                            //loginVCへ画面切替え
                            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                            self.present(loginViewController!, animated: true, completion: nil) //画面切り替え
                        }
                        
                      }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }
}
