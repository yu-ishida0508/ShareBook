//
//  TableViewCellThree.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/20.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import FirebaseUI

class TableViewCellThree: UITableViewCell {

    //投稿画像
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var feelingTextView: UITextView! //感想
    
    @IBOutlet weak var writerLable: UILabel!       //著者
    @IBOutlet weak var dateLabel: UILabel!       //日付
    @IBOutlet weak var likeLabel: UILabel!       //いいね数
    @IBOutlet weak var likeButton: UIButton!    //いいねボタンはouteletで繋ぐ
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            //ImageViewのを丸くする。長さの半分を設定値にする
            postImageView!.layer.cornerRadius = 35
            feelingTextView.layer.cornerRadius = 10
            backgroundColor = .clear //背景色(透明)
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        

        
    //MARK: - PostDataの内容をセルに表示
        func setPostData(_ postData: PostData) {
            // 画像の表示
            postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
            postImageView.sd_setImage(with: imageRef)

            // 感想の表示
            self.feelingTextView.text = "\(postData.feelings!)"
            
            // 作者の表示
            self.writerLable.text = "\(postData.writer!)"
            
            // 日時の表示
            self.dateLabel.text = ""
            if let date = postData.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = formatter.string(from: date)
                self.dateLabel.text = dateString
            }

            // いいね数の表示
            let likeNumber = postData.likes.count
            likeLabel.text = "\(likeNumber)"

            // いいねボタンの表示
            if postData.isLiked {
                let buttonImage = UIImage(named: "StarYellow")
                self.likeButton.setImage(buttonImage, for: .normal)
            } else {
                let buttonImage = UIImage(named: "StarBorder")
                self.likeButton.setImage(buttonImage, for: .normal)
            }
            
        }

    }

