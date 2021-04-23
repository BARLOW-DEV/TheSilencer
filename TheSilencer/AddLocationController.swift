//
//  AddLocationController.swift
//  TheSilencer
//
//  Created by Aaron Barlow on 4/11/21.
//  Copyright © 2021 Aaron Barlow. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AddLocationController: UIViewController {
    
  // Label outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var getLocationButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var isUpdatingLocation = false
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var isPerformingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    var locationNameResult = ""
    
    
    
//    let states = [ "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Conneticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming" ]
    
    //var pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.delegate = self
        updateUI()
        //pickerView.delegate = self
        //pickerView.dataSource = self
        //state.inputView = pickerView
//        state.delegate = self
//        zip.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
           if let location = location {
               // TODO: populate the location labels with coordinate info
                latitude.text = String(format: "%.8f", location.coordinate.latitude)
                longitude.text = String(format: "%.8f", location.coordinate.longitude)
                statusLabel.text = "New Location Detected!"
            
                if let placemark = placemark {
                    address.text = getAddress(from: placemark)
                } else if isPerformingReverseGeocoding {
                    address.text = "Searching for address.."
                } else if lastGeocodingError != nil {
                    address.text = "Error finding a valid address."
                } else {
                    address.text = "address Not Found"
                }
            
           } else {
                statusLabel.text = "Tap 'Get Location!' to Start"
                latitude.text = "-"
                longitude.text = "-"
                address.text = "-"
            }
        }
       
    func getAddress(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let street1 = placemark.subThoroughfare {
            line1 += street1 + " "
        }
        if let street2 = placemark.thoroughfare {
            line1 += street2
        }
        
        var line2 = ""
        if let city = placemark.locality {
            line2 += city + " "
        }
        if let stateOrProvince = placemark.administrativeArea {
            line2 += stateOrProvince + " "
        }
        if let postalCode = placemark.postalCode {
            line2 += postalCode
        }
        
        var line3 = ""
        if let country = placemark.country {
            line3 += country
        }
        
        return line1 + "\n" + line2 + "\n" + line3
    }
    
    override func viewWillAppear(_ animated: Bool) {
             self.navigationController?.setNavigationBarHidden(false, animated: true)
             self.navigationController?.setToolbarHidden(false, animated: true)
             
    }
    
    
    @IBAction func getLocationButtonTapped(_ sender: Any) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            reportLocationServicesDeniedError()
            return
        }
        
        if isUpdatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            
            placemark = nil
            lastGeocodingError = nil
            
            startLocationManager()
        }
        updateUI()
    }
    
    func reportLocationServicesDeniedError() {
        let alert = UIAlertController(title: "Oops! Location Services Disabled.", message: "Please go to Settings > Privacy to enable location services for this app.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdatingLocation = false
        }
    }
}


extension AddLocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!! locationManager-didFailWithError: \(error)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        print("GOT IT! locationManager-didUpdateLocations: \(String(describing: location))")
        stopLocationManager()
        updateUI()
        
        if location != nil {
            if !isPerformingReverseGeocoding {
                print("*** Start performing geocoding... ")
                isPerformingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
                    self.lastGeocodingError = error
                    if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
                        self.placemark = placemarks.last!
                    } else {
                        self.placemark = nil
                    }
                    
                    self.isPerformingReverseGeocoding = false
                    self.updateUI()
                }
            }
        }
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let table = segue.destination as! LocationTableViewController
        locationNameResult = locationName.text ?? "Bad Name"
        location = [CLLocation]
//        stateResult = state.text ?? "Bad State"
//        zipResult = zip.text ?? "-1"
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
    
}

// UIPickerViewDataSource was in this extension
/*
extension AddLocationController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return states.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return states[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        state.text = states[row]
//        state.resignFirstResponder()
//    }
    
}
*/
extension AddLocationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
 

