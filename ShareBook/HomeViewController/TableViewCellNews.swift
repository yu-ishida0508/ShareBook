//
//  TableViewCellNews.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/25.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import FirebaseUI

class TableViewCellNews: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView! //ニュース画像
    @IBOutlet weak var themeLabel: UILabel! //テーマ
    @IBOutlet weak var newsTextView: UITextView!//メッセージ
    


//    @IBOutlet weak var postImageView: UIImageView! //投稿画像
//    @IBOutlet weak var feelingTextView: UITextView!//感想
//    @IBOutlet weak var writerLable: UILabel!       //著者
    @IBOutlet weak var dateLabel: UILabel!       //日付
//    @IBOutlet weak var likeLabel: UILabel!       //いいね数
//    @IBOutlet weak var likeButton: UIButton!    //いいねボタンはouteletで繋ぐ
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //ImageViewのを丸くする。長さの半分を設定値にする
        newsImageView.layer.cornerRadius = 10
        newsTextView.layer.cornerRadius = 10
        backgroundColor = .clear //背景色(透明)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
//MARK: - PostDataの内容をセルに表示
    func setNewsData(_ newsData: NewsData) {
        // 画像の表示
        newsImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.NewsImagePath).child(newsData.id + ".jpg")
        newsImageView.sd_setImage(with: imageRef)

        // ニュースの表示
        self.newsTextView.text = "\(newsData.news!)"
        
        // テーマの表示
        self.themeLabel.text = "\(newsData.theme!)"
        
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = newsData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
    }

}
