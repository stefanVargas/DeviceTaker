//
//  MyEquipsViewController.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 02/08/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class MyEquipsViewController: UIViewController {
    
    @IBOutlet weak var equipImage: UIImageView!
    @IBOutlet weak var equipModelo: UILabel!
    
    @IBOutlet weak var equipStatus: UILabel!
    
    @IBOutlet weak var equipBarcode: UILabel!
    
    var myEquip = Equipamentos()
    
    var refHandle: DatabaseHandle?
    let ref = Database.database().reference()
    
    override func viewWillAppear(_ animated: Bool) {
        
        equipModelo.text = myEquip.modelo
        equipStatus.text = myEquip.status
        equipBarcode.text = myEquip.barcode
        setImage(modelo: myEquip.modelo!)
        
        
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
        if modelo.elementsEqual("iPad"){
            equipImage.image = UIImage(named: "ipad")
        }
        
    }
    
    @IBAction func devolverPressed(_ sender: UIButton) {
        var codeChecker = true
        self.refHandle = self.ref.child("Equipamentos").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : String]? {
                print(dictionary as Any)
                
                for (key, value) in dictionary! {
                    if key.elementsEqual("Barcode"){
                        codeChecker = false
                        if value.elementsEqual(self.myEquip.barcode!) {
                            
                            codeChecker = true
                        } else {
                            print("ERROR!!")

                        }
                    }
                    if key.elementsEqual("User") && codeChecker{
                        if let barcode = self.myEquip.barcode{
                            self.ref.child("Equipamentos/\(barcode)/User").setValue("Academy")
                        }
                    }
                    if key.elementsEqual("Status") && codeChecker{
                        
                    
                    }
                }
            }
        })
    }
    
    
    
}
