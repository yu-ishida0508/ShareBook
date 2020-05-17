//
//  LoginViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
//MARK: - ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {

            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
                }
                return
            }

            // HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗")
                    //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        SVProgressHUD.dismiss()
                    }
                    
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                // HUDを消す
                //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
                }

                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
//MARK: - アカウント作成ボタンをタップ時に呼ばれるメソッド
//MARK:  E-mail:「@」必要、Pass:6文字以上
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {

            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
                }
                return
            }
            
            // パスワードが6桁未満であれば何もしない
            if password.count < 6 {
                print("DEBUG_PRINT: パスワード６桁未満")
                SVProgressHUD.showInfo(withStatus:"パスワードは６桁以上を入力して下さい")
                //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
                }
                return
            }
            
            
            // HUDで処理中を表示
            SVProgressHUD.show()

            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                     SVProgressHUD.dismiss()
                    }
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")

//MARK: 表示名を設定
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            //DispatchQueue.main.asyncAfter記述後の処理は1.5秒後に実行
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             SVProgressHUD.dismiss()
                            }
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        // HUDを消す
                        //DispatchQueue.main.asyncAfter記述後の処理は1.0秒後に実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         SVProgressHUD.dismiss()
                        }

                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
//MARK: - パスワード再設定（遷移先→遷移元用）
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
//MARK: - パスワード再設定先(ResetPassViewController)へ遷移
//MARK:  TODO:パスワード再設定先(ResetPassViewController)へデータ渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueから遷移先のResetPassViewControllerを取得する
//        let resetPassView:ResetPassViewController = segue.destination as! ResetPassViewController
        
        // 遷移先のResetPassViewControllerで宣言しているaddressに値を代入して渡す
//        resetPassView.resetMailAddressTextField.text = self.mailAddressTextField.text!
//        resetPassView.resetMailAddressTextField.text = "1234"
    }
//MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
