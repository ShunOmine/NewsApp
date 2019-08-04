//
//  ThirdViewController.swift
//  SummerCampNewsApp
//
//  Created by 大嶺舜 on 2019/08/04.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class ThirdViewController: UIViewController, IndicatorInfoProvider {
    var infoItem: IndicatorInfo = "Google"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return infoItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
