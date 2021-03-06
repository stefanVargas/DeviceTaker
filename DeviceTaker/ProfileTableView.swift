//
//  ProfileTableView.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 08/07/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ProfileTableView: UITableViewController {
    
    public var myEquipList = [Equipamentos]()
    var selectedMyEquip: Equipamentos?
    var refHandle: DatabaseHandle?
    let ref = Database.database().reference()
    
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveUsuarios()
    }
    
    override func viewDidLoad() {
        
        
        print(myEquipList.count)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromDevolver(_ sender: UIStoryboardSegue){
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.myEquipList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDevicesCell", for: indexPath) as! ProfileTableViewCell
        
        // Configure the cell...
        let index = indexPath.row
        cell.deviceLabel.text = self.myEquipList[index].modelo as String?
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMyEquip = self.myEquipList[indexPath.row]
        performSegue(withIdentifier: "seguePresentMyEquip", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "seguePresentMyEquip"{
            let profileVC = segue.destination as! MyEquipsViewController
            profileVC.myEquip = self.selectedMyEquip!
            
            
        }
        // Pass the selected object to the new view controller.
    }
    
    func retrieveUsuarios(){
         var codeChecker = false
        self.myEquipList.removeAll()
        refHandle = ref.child("Equipamentos").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : String]? {
                
                let equip = Equipamentos()
                for (key, value) in dictionary! {
                    if key.elementsEqual("User"){
                        codeChecker = false
                        if value.elementsEqual("Stefan"){
                            codeChecker = true
                            print(value)
                        }
                    }
                }
                 for (key, value) in dictionary! {
                    if key.elementsEqual("Barcode") && codeChecker{
                        equip.barcode = value
                        print("BAR")
                        print(value)
                    }
                    if key.elementsEqual("Modelo") && codeChecker{
                         print("Model")
                        print(value)
                        equip.modelo = value
                    }
                    if key.elementsEqual("Status") && codeChecker{
                         print("Status")
                        print(value)
                        equip.status = value
                    }
                }
                print(equip.modelo as Any)
                if codeChecker{
                    self.myEquipList.append(equip)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
            
        })
    }
    
}
