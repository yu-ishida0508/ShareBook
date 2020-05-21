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
        self.settings.style.buttonBarBackgroundColor = .red
        self.settings.style.buttonBarItemBackgroundColor = .clear
        self.settings.style.selectedBarBackgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        self.settings.style.selectedBarHeight = 10.0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.buttonBarItemTitleColor = .black
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
                oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
                newCell?.label.textColor = UIColor.white
                    
                
                
            }
        
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
    }
//MARK: - 謎メソッド無くても動く
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            let child = viewControllers[toIndex] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
            UIView.performWithoutAnimation({ [weak self] () -> Void in
                guard let me = self else { return }
                me.navigationItem.leftBarButtonItem?.title =  child.indicatorInfo(for: me).title
            })
        }
    }
//MARK: -


    }

