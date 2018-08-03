//
//  EquipamentosTableView.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 27/07/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class EquipamentosTableView: UITableViewController {
    
    var equipList = [Equipamentos]()
    var selectedEquip: Equipamentos?
    var refHandle: DatabaseHandle?
    let ref = Database.database().reference()
    
    override func viewWillAppear(_ animated: Bool) {
        self.equipList.removeAll()
        retrieveUsuarios()
    }
    override func viewDidLoad() {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source-------**
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.equipList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipCell", for: indexPath) as! EquipamentosTableViewCell
        
        // Configure the cell...
        let index = indexPath.row
        cell.deviceLabel.text = self.equipList[index].modelo as String?
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedEquip = self.equipList[indexPath.row]
        performSegue(withIdentifier: "seguePresentEquip", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "seguePresentEquip"{
            let profileVC = segue.destination as! AcademyEquipsViewController
            profileVC.academyEquip = self.selectedEquip!
            
            
        }
        // Pass the selected object to the new view controller.
    }
    
    func retrieveUsuarios(){
        var codeChecker = false
        
        refHandle = ref.child("Equipamentos").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : String]? {
                
                let equip = Equipamentos()
                for (key, value) in dictionary! {
                    if key.elementsEqual("User"){
                        codeChecker = false
                        if value.elementsEqual("Academy"){
                            codeChecker = true
                            print(value)
                        }
                    }
                }
                for (key, value) in dictionary! {
                    if key.elementsEqual("Barcode") && codeChecker{
                        equip.barcode = value
                        print("Bob")
                        print(value)
                    }
                    if key.elementsEqual("Modelo") && codeChecker{
                        equip.modelo = value
                        print("Model")
                        print(value)
                        print(equip.modelo as Any)
                    }
                    if key.elementsEqual("Status") && codeChecker{
                        equip.status = value
                        print("Status")
                        print(value)
                    }
                }
                self.equipList.append(equip)
                print(equip.modelo as Any)
                if codeChecker{
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                

                
            }
            
        })
    }
}
