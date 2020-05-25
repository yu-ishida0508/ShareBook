//
//  NewsData.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/25.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase

class NewsData: NSObject {
    var id: String
    var name: String?
    var theme: String? //テーマ
    var news: String? //ニュース
    var date: Date?

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        self.name = postDic["name"] as? String
        
        self.theme = postDic["theme"] as? String//テーマ

        self.news = postDic["news"] as? String //コメント
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()

        }
    }

