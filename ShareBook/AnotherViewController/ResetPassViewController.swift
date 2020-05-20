//
//  ResetPassViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/17.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ResetPassViewController: UIViewController {
    
    @IBOutlet weak var resetMailAddressTextField: UITextField!
    
//MARK: - パスワード失念時のメール送信(SettingVCと同じ内容のため、修正時は要確認)
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
//MARK: -　画面外をタップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
