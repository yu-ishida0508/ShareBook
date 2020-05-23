//
//  FirstChildViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/22.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import FirebaseUI

class FirstChildViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!//画像
    @IBOutlet weak var writerLabel: UILabel!  //作者名
    @IBOutlet weak var nameLabel: UILabel!   //投稿者
    @IBOutlet weak var feelingTextView: UITextView! //感想
    
    var postData:PostData!
   
//Firebaseに登録している画像表示
func setPostData(_ postData: PostData) {
    // 画像の表示
    imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
    imageView.sd_setImage(with: imageRef)
    
    }
//

    override func viewDidLoad() {
        super.viewDidLoad()
        setPostData(postData) //画像表示
        writerLabel.text = postData.writer //作者名
        nameLabel.text = postData.name //投稿者名
        feelingTextView.text = postData.feelings //感想
        
        //それぞれのViewの角を丸くする
        imageView.layer.cornerRadius = 10
        feelingTextView.layer.cornerRadius = 10
        
 


    }
    //戻るボタン
    @IBAction func backButton(_ sender: Any) {
        // 画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
