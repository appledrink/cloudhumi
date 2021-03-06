//
//  ViewController.swift
//  ListApp
//
//  Created by MacbookUNI on 19.11.17.
//  Copyright © 2017 MacbookUNI. All rights reserved.
//

import UIKit
import CoreData

protocol CellDelegate : class {
  func sendIP(_ sender: ZelleTableViewCell)
    
}


class tableViewController: UITableViewController, UpdateDataDelegate {
    
    
    
    var listItems = [NSManagedObject]()
    
    let SensorData = sensorData()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            listItems = results as![NSManagedObject]
        } catch  {
            print("error")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SensorData.delegate = self
    }
    
   
    
    @IBAction func Add(_ sender: Any) {
        addItem()
    }
    
    func addItem() {
        let alertController = UIAlertController(title: "Add your IP", message: "Type", preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
              
                self.saveItem(itemToSave: field.text!)
                self.tableView.reloadData()
            }
        }
        ))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addTextField (configurationHandler: {
            (textField) in
            textField.placeholder = "Type something!"
            
        })
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func saveItem(itemToSave : String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(itemToSave, forKey: "item")
        
        do {
            try managedContext.save()
            
            listItems.append(item)
        } catch  {
            print("error")
        }
        
    }


//--------------------------------------------------------------------------------------------------------------------------------------

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }

//--------------------------------------------------------------------------------------------------------------------------------------


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! ZelleTableViewCell
    
        let item = listItems[indexPath.row]
        
        cell.textLabel?.text = item.value(forKey: "item") as? String
    
    
    //let cell = tableView.cellForRow(at: indexPath) as! ZelleTableViewCell
    cell.TempLabel?.text = ("\(MyVariables.Temperatur)  C°")
    cell.HumLabel?.text = ("\(MyVariables.Humi)  %")
   
    return cell 
    }

//--------------------------------------------------------------------------------------------------------------------------------------

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        
        let selectedName = listItems[indexPath.row]
        let name = selectedName.value(forKey: "item") as? String
        
        //let cell = tableView.cellForRow(at: indexPath) as! ZelleTableViewCell
        //cell.TempLabel?.text = ("\(MyVariables.Temperatur)  C°")
        //cell.HumLabel?.text = ("\(MyVariables.Humi)  %")
        
        
        
        print("Kommt IndexPathRow")
        print(indexPath.row)
        print("Kommt IndexPath")
        print(indexPath)
        print("Kommt SelectedName")
        print(selectedName)
        print("Kommt Name")
        print(name!)
        
        MyVariables.IPAdress = name as! String
        MyVariables.IndexPathItem = indexPath.item
        MyVariables.IndexSection = indexPath.section

    
        print(MyVariables.IPAdress)
        
        SensorData.Humidity()
        
    

        

    }

//--------------------------------------------------------------------------------------------------------------------------------------
    
    //Delete Cell on Tap
    
    /*  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
     tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
     
     managedContext.delete(listItems[indexPath.row])
     listItems.remove(at: indexPath.row)
     self.tableView.reloadData()
     
     
     }
     
     */
    //END of Delete Cell on Tap
    
//--------------------------------------------------------------------------------------------------------------------------------------
    
//Delete Cell on Swipe
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
            
            managedContext.delete(listItems[indexPath.row])
            listItems.remove(at: indexPath.row)
            self.tableView.reloadData()
        } else {
        }
    }
    
//END of Delete on Swipe
    
//--------------------------------------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------
 
    
    
    func didFinishUpdate(_ sender:sensorData) {
        print("Aktualisiere TableView")
       //tableView.reloadData()
       //let indexPath = IndexPath(item: 0, section: 0)
        let indexPath = IndexPath(item: MyVariables.IndexPathItem, section: MyVariables.IndexSection )
        self.tableView.reloadRows(at: [indexPath], with: .right)
    }
}
