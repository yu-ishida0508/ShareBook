//
//  TabBarController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }

        // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if viewController is ImageSelectViewController {
                // ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
                let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
                present(imageSelectViewController, animated: true)
                return false
            }
            else if viewController is FavoriteViewController {
                // FavoriteViewControllerは、タブ切り替えではなくモーダル画面遷移する
                let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "Favorite")
                present(imageSelectViewController, animated: true)
                return false
            }
            else if viewController is NewsViewController {
                // NewsViewControllerは、タブ切り替えではなくモーダル画面遷移する
                let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "News")
                present(imageSelectViewController, animated: true)
                return false
            }
            else {
                // その他（設定）のViewControllerは通常のタブ切り替えを実施
                return true
            }
        }
}
