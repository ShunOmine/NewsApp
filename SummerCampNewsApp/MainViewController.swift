//
//  ViewController.swift
//  SummerCampNewsApp
//
//  Created by 大嶺舜 on 2019/08/04.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class MainViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second")
        let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Third")
        let fourthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Fourth")
        let fifthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Fifth")
        let childViewControllers:[UIViewController] = [firstVC]
        return childViewControllers
    }


}

