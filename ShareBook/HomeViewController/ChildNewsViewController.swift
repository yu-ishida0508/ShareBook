//
//  ChildNewsViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/26.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import FirebaseUI

class ChildNewsViewController: UIViewController {
    @IBOutlet weak var newsImageView: UIImageView!//画像
    @IBOutlet weak var themeLabel: UILabel!  //テーマ
    @IBOutlet weak var dateLabel: UILabel!   //時間
    @IBOutlet weak var newsTextView: UITextView! //ニュース
    
    @IBAction func backButton(_ sender: Any) { //戻る
        // 前画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    var newsData:NewsData! //
    
//Firebaseに登録している画像表示
func setNewsData(_ newsData: NewsData) {
    // 画像の表示
    newsImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    let imageRef = Storage.storage().reference().child(Const.NewsImagePath).child(newsData.id + ".jpg")
    newsImageView.sd_setImage(with: imageRef)
    
    }
//

    override func viewDidLoad() {
        super.viewDidLoad()
        setNewsData(newsData) //画像表示
        themeLabel.text = newsData.theme //テーマ
//        dateLabel.text = newsData.date //時間
        newsTextView.text = newsData.news //ニュース
        // 日時の表示
        self.dateLabel.text = ""
        if let date = newsData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        
        //それぞれのViewの角を丸くする
        newsImageView.layer.cornerRadius = 10
        newsTextView.layer.cornerRadius = 10
        
 


    }
    
}
