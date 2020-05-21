//
//  ChatListViewController.swift
//  ChatAppWithFirebase
//
//  Created by 石田悠 on 2020/05/13.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController{
    
    private let cellId = "cellId"
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        //navigationカラーの背景色を変える
        navigationController?.navigationBar.barTintColor = .rgb(red:39  ,green:49,blue:69)
        
        //タイトル
        navigationItem.title = "トーク"
        //タイトル（トーク）背景色
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]

    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ChatListViewController:UITableViewDelegate,UITableViewDataSource{
    //行間の幅
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    //クリックした後反応するメソッド(チャットビュー)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        //ChatRoomViewControllerはstoryboradID
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}

class ChatListTabelViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //nib内のすべてのオブジェクトが完全にロードされた後にnib内のすべてのオブジェクトに送信されるメッセージ
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //ImageViewのを丸くする。長さの半分を設定値にする
        userImageView.layer.cornerRadius = 35
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
