//
//  HomeViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import XLPagerTabStrip //追加

//修正
class HomeViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        self.loadDesign()
        super.viewDidLoad()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier: "TableOne")
        let child_2 = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier: "TableTwo")
        let child_3 = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier: "TableThree")
        return [child_1,child_2,child_3]
    }
    
    func loadDesign(){
        self.settings.style.selectedBarHeight = 0
        self.settings.style.selectedBarBackgroundColor = UIColor.black
        self.settings.style.buttonBarBackgroundColor = .black
        self.settings.style.buttonBarItemBackgroundColor = .black
        self.settings.style.selectedBarBackgroundColor = .white
        self.settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 13)
        self.settings.style.selectedBarHeight = 10.0
        self.settings.style.buttonBarMinimumLineSpacing = 5
        self.settings.style.buttonBarItemTitleColor = .white
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = UIColor.white
        }
            
        
        
    }
}
