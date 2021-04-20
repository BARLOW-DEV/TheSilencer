//
//  ZonesTableTableViewController.swift
//  TheSilencer
//
//  Created by Aaron Barlow on 4/11/21.
//  Copyright © 2021 Aaron Barlow. All rights reserved.
//

import UIKit
import CoreData

class LocationTableViewController: UITableViewController {

    var dataSource: [NSManagedObject] = []
    var appDelegate: AppDelegate?
    var entity: NSEntityDescription?
    var context: NSManagedObjectContext?
    var nameTextField: UITextField?
    var addressTextField: UITextField?
    var items:[Locations]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Locations", in: context!)
        
        fetchLocationData()
 
    }
    func fetchLocationData(){
        do{
            self.items = try context?.fetch(Locations.fetchRequest())
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
    }
        catch{
            
        }
    }
  
    @IBAction func unwindFromSave(segue: UIStoryboardSegue) {
        guard let source = segue.source as? AddLocationController else {
            print("Cannot get segue source.")
            return
        }
        
        if let entity = self.entity {
            let location = NSManagedObject(entity: entity, insertInto: context)
            location.setValue(source.locationNameResult, forKey: "name")
            location.setValue(source.completeAddress, forKey: "address")
        
        
            do {
                try context?.save()
                dataSource.append(location)
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Cannot save data: \(error)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Locations")
        
        do {
            dataSource = try context?.fetch(fetchRequest) ?? []
        } catch let error as NSError {
            print("Cannot load data: \(error)")
        }
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(false, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "My Cell", for: indexPath)

        cell.textLabel?.text = dataSource[indexPath.row].value(forKey: "name") as? String
        cell.detailTextLabel?.text = dataSource[indexPath.row].value(forKey: "address") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, comletionHandler) in
            
            let locationToRemove = self.dataSource[indexPath[1]]
            self.context?.delete(locationToRemove)
            self.dataSource.remove(at: indexPath.row)
        
            
            do {
                try self.context?.save()
                self.tableView.reloadData()
            }
            catch let error as NSError {
            print("Cannot delete data: \(error)")
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Edit Location", message: "Edit name?", preferredStyle: .alert)
//        alert.addTextField()
//        if let entity = self.entity {
//            let location = NSManagedObject(entity: entity, insertInto: context)
//            let textfield = alert.textFields![0]
//            textfield.text = location.value(forKey: "Locations") as? String
//
//        }
//
//    }

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Selected locationName
            let locationName = self.items![indexPath.row]
            let subTitle = self.items![indexPath.row]
            
           
            
            let alertController = UIAlertController(title: "Edit info", message: "Edit location name and/or address?", preferredStyle: .alert)
            alertController.addTextField()
            alertController.addTextField()
            
            let textfield = alertController.textFields![0]
            textfield.text = locationName.name
            let subTextField = alertController.textFields![1]
            subTextField.text = subTitle.address
            // Configure the button handler
            let okAction = UIAlertAction(title: "Update", style: .default) { action in

                // Get the textfield for the alert
                let textfield = alertController.textFields![0]
                let subTextField = alertController.textFields![1]
              
                // Edit name property of locationName object
               locationName.name = textfield.text
               subTitle.address = subTextField.text
               
    
            // Save the data
                do {
                    try self.context?.save()
                   
                }
                catch {
                }
                
                self.fetchLocationData()
               
               
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in

                //Do something when cancel is tapped
            }

            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            
            // show alert view
            present(alertController, animated: true) {
                //Do something when alert view is presented
            }

    }
    
    

   

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

