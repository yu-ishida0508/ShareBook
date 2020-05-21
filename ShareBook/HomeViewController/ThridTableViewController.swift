//
//  ThridViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/20.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ThirdTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellThree", for: indexPath) as! TableViewCellThree

        return cell
    }

}
extension ThirdTableViewController : IndicatorInfoProvider {
    //サブタイトル
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: " ACCOUNT", image: UIImage(named: "profile"))
        return IndicatorInfo(image: UIImage(named: "profile"))
    }

}
