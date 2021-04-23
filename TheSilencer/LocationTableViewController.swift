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

    // Variables to fetch info from LocationController swift file
    var dataSource: [NSManagedObject] = []
    var appDelegate: AppDelegate?
    var entity: NSEntityDescription?
    var context: NSManagedObjectContext?
    var nameTextField: UITextField?
    var addressTextField: UITextField?
    var items:[Locations]?
    private let locationNotificationScheduler = LocationNotificationScheduler()
    
    
    // Fetch data
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationNotificationScheduler.delegate = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Locations", in: context!)
        
        fetchLocationData()
 
    }
    
    // Fetch data
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
  
    // Check if the data can be stored into Location Table view
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

    // Checks if the data can be loaded and filters navigation bar and tool bar
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
    
    
    // store longitude and location name data into cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "My Cell", for: indexPath)

        cell.textLabel?.text = dataSource[indexPath.row].value(forKey: "name") as? String
        cell.detailTextLabel?.text = dataSource[indexPath.row].value(forKey: "address") as? String
        return cell
    }
    
    // Allows the user to swipe left to delete a cell
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
    
     //Allows the user to tap a cell to update its title and subtitle
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Selected locationName
            let locationName = self.dataSource[indexPath.row]
            let subTitle = self.dataSource[indexPath.row]

            


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

                self.tableView.reloadData()
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
    
    
    // Location merge attempt
//     override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//         let notificationInfo = LocationNotificationInfo(notificationId: "home_notification_id",
//                                                                locationId: "Home",
//                                                                radius: 500.0,
//                                                                latitude: 36.040070,
//                                                                longitude: -95.903610,
//                                                                title: "Silence Your Phone",
//                                                                body: "You Are At Home",
//                                                                data: ["location": "Home"])
//                // Could add more location/notification info here.
//                let notificationInfo2 = LocationNotificationInfo(notificationId: "home_notification_id",
//                                                                locationId: "School",
//                                                                radius: 500.0,
//                                                                latitude: 36.163399,
//                                                                longitude: -95.987617,
//                                                                title: "Silence Your Phone",
//                                                                body: "You Are At School",
//                                                                data: ["location": "Home"])
//                locationNotificationScheduler.requestNotification(with: notificationInfo)
//                locationNotificationScheduler.requestNotification(with: notificationInfo2)
//            }
//        }
//
//        extension LocationTableViewController: LocationNotificationSchedulerDelegate {
//
//            func locationPermissionDenied() {
//                let message = "The location permission was not authorized. Please enable it in Settings to continue."
//                presentSettingsAlert(message: message)
//            }
//
//            func notificationPermissionDenied() {
//                let message = "The notification permission was not authorized. Please enable it in Settings to continue."
//                presentSettingsAlert(message: message)
//            }
//
//            func notificationScheduled(error: Error?) {
//                if let error = error {
//                    let alertController = UIAlertController(title: "Notification Schedule Error",
//                                                            message: error.localizedDescription,
//                                                            preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    present(alertController, animated: true)
//                } else {
//                    let alertController = UIAlertController(title: "Notification Scheduled!",
//                                                            message: "You will be notified when you are near the location!",
//                                                            preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    present(alertController, animated: true)
//                }
//            }
//
//        //    func userNotificationCenter(_ center: UNUserNotificationCenter,
//        //                                didReceive response: UNNotificationResponse,
//        //                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        //        if response.notification.request.identifier == "home_notification_id" {
//        //            let notificationData = response.notification.request.content.userInfo
//        //            let message = "You have reached \(notificationData["location"] ?? "your location!")"
//        //
//        //            let alertController = UIAlertController(title: "Welcome!",
//        //                                                    message: message,
//        //                                                    preferredStyle: .alert)
//        //            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        //            present(alertController, animated: true)
//        //        }
//        //        completionHandler()
//        //    }
//
//            private func presentSettingsAlert(message: String) {
//                let alertController = UIAlertController(title: "Permissions Denied!",
//                                                        message: message,
//                                                        preferredStyle: .alert)
//
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
//                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//                        UIApplication.shared.open(appSettings)
//                    }
//                }
//
//                alertController.addAction(cancelAction)
//                alertController.addAction(settingsAction)
//
//                present(alertController, animated: true)
//            }
//
//
//
//        return UISwipeActionsConfiguration(alertController)
//    }
//
//}
    

   

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
