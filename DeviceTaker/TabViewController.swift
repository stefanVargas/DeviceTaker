//
//  TabViewController.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 18/07/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit


class TabViewController: UIViewController {
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var tabButtons: [UIButton]!
    
    var scanViewController: UIViewController!
    var equipsViewController: UIViewController!
    var accountViewController: UIViewController!
    
    var viewControllers: [UIViewController]!
    
    var selectedTag: Int = initalTag
    
    override func viewDidLoad() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        scanViewController = storyboard.instantiateViewController(withIdentifier: "scanVC")
        equipsViewController = storyboard.instantiateViewController(withIdentifier: "navEquipVC")
        accountViewController = storyboard.instantiateViewController(withIdentifier: "navProfVC")
        
        viewControllers = [equipsViewController, scanViewController, accountViewController]
        
        tabButtons[selectedTag].isSelected = true
        didTabPressed(tabButtons[selectedTag])

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func didTabPressed(_ sender: UIButton) {
        
        let previousIndex = selectedTag
        
        selectedTag = sender.tag
        
        selectedTabButtonColor(sendertag: selectedTag)
        
        tabButtons[previousIndex].isSelected = false
        
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedTag]
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)


        vc.didMove(toParentViewController: self)

    }
    
    func selectedTabButtonColor(sendertag: Int) {
        
        if sendertag == 0 {
            tabButtons[sendertag].setImage( UIImage.init(named: "devicesO"), for: .selected)
        }
        if sendertag == 1 {
            tabButtons[sendertag].setImage( UIImage.init(named: "barcodeO"), for: .selected)
        }
        if sendertag == 2 {
            tabButtons[sendertag].setImage( UIImage.init(named: "avatarO"), for: .selected)
        }
        
    }
    
    func setSendertag(num: Int) {
        self.selectedTag = num
    }
    
    
}
