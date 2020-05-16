//
//  ResetPassViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/17.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase

class ResetPassViewController: UIViewController {
    
    @IBOutlet weak var resetMailAddressTextField: UITextField!
    
    //パスワード失念時のメール送信
    @IBAction func sendButton(_ sender: Any) {
        
        if let address = resetMailAddressTextField.text {
            // パスワードが入力されていない時は何もしない
            if address.isEmpty {
                print("DEBUG_PRINT: アドレスが未入力です。")
                return
            }
            
            
            
            
        }
        
            // 送信先のメールアドレスを取得
            let address = resetMailAddressTextField.text!
               // 取得したメールアドレスを引数に渡す
            Auth.auth().sendPasswordReset(withEmail: address) { (error) in
                   if error == nil {
                    // エラーが無ければ、パスワード再設定用のメールが指定したメールアドレスまで送信される。
                    // 届いたメールからパスワード再設定後、新しいパスワードでログインする事が出来る。
                       self.performSegue(withIdentifier: "GoToLoginScreen", sender: nil)
                   }else{
                       print("エラー：\(String(describing: error?.localizedDescription))")
                   }
               }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
