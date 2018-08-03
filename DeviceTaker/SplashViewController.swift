//
//  SplashViewController.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 30/07/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit

var initalTag: Int = 1

class SplashViewController: UIViewController {


    override func viewWillAppear(_ animated: Bool) {

        
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        perform(#selector(showTabController), with: nil, afterDelay: 2)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showTabController()  {
        let tabVC = (storyboard?.instantiateViewController(withIdentifier: "TabBarsVC"))! as! TabViewController
        tabVC.setSendertag(num: 1)
        
        performSegue(withIdentifier: "splash_tab", sender: self)
    }
}

