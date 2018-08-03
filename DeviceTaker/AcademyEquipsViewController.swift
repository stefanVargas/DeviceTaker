//
//  AcademyEquipsViewController.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 01/08/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class AcademyEquipsViewController: UIViewController {
    
    @IBOutlet weak var equipImage: UIImageView!
    @IBOutlet weak var equipModelo: UILabel!
    
    @IBOutlet weak var equipStatus: UILabel!
    
    @IBOutlet weak var equipBarcode: UILabel!
    
    var academyEquip = Equipamentos()
    
    override func viewWillAppear(_ animated: Bool) {
        
        equipModelo.text = academyEquip.modelo
        equipStatus.text = academyEquip.status
        equipBarcode.text = academyEquip.barcode
        setImage(modelo: academyEquip.modelo!)
        
        
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImage(modelo: String) {
        
        if modelo.elementsEqual("iPhone5C"){
            equipImage.image = UIImage(named: "5c")
        }
        else if modelo.elementsEqual("iPad"){
            equipImage.image = UIImage(named: "ipad")
        }
        else {
            equipImage.image = UIImage(named: "test")
        }
        
    }
    
    
    
}
