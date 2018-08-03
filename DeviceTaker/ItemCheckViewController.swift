//
//  ItemCheckViewController.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 30/07/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ItemCheckViewController: UIViewController {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var checkModel: UILabel!
    @IBOutlet weak var checkStatus: UILabel!
    @IBOutlet weak var checkBarcode: UILabel!
    
    var checkMyEquip = Equipamentos()
    
    var refHandle: DatabaseHandle?
    let ref = Database.database().reference()
    
    var profileVC: ProfileTableView!
    
     var selectedTag: Int = 2
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkModel.text = checkMyEquip.modelo
        checkStatus.text = checkMyEquip.status
        checkBarcode.text = checkMyEquip.barcode
        setImage(modelo: checkMyEquip.modelo!)
        
        
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
            checkImage.image = UIImage(named: "5c")
        }
        if modelo.elementsEqual("iPad"){
            checkImage.image = UIImage(named: "ipad")
        }
        
    }
    
    
    
    @IBAction func pegarPressed(_ sender: UIButton) {
        var codeChecker = true
        self.refHandle = self.ref.child("Equipamentos").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : String]? {
                print(dictionary as Any)
            
                for (key, value) in dictionary! {
                    if key.elementsEqual("Barcode"){
                        codeChecker = false
                        if value.elementsEqual(self.checkMyEquip.barcode!) {
                            
                            codeChecker = true
                        } else {
                             self.performSegue(withIdentifier: "cancel_segue", sender: self)
                        }
                    }
                    if key.elementsEqual("User") && codeChecker{
                        if let barcode = self.checkMyEquip.barcode{
                        self.ref.child("Equipamentos/\(barcode)/User").setValue("Stefan")
                        }
                    }
                    if key.elementsEqual("Status") && codeChecker{
                       
                        
                    }
                }
                initalTag = 2
            }
        })
    }
}
