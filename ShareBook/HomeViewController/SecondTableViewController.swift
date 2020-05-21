//
//  SecondViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/20.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SecondTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTwo", for: indexPath) as! TableViewCellTwo

        return cell
    }

}
extension SecondTableViewController : IndicatorInfoProvider {
    //サブタイトル
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: " TRENDING", image: UIImage(named: "trending"))
        return IndicatorInfo(image: UIImage(named: "trending"))
        
    }
}

