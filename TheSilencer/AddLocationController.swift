//
//  AddLocationController.swift
//  TheSilencer
//
//  Created by Aaron Barlow on 4/11/21.
//  Copyright © 2021 Aaron Barlow. All rights reserved.
//

import UIKit

class AddLocationController: UIViewController {
    
  
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    
    
    var locationNameResult: String = ""
    var addressResult: String = ""
    var cityResult: String = ""
    var stateResult: String = ""
    var zipResult: String = ""
    var completeAddress: String = ""
    
    let states = [ "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Conneticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming" ]
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        state.inputView = pickerView
        
        locationName.delegate = self
        address.delegate = self
        city.delegate = self
        state.delegate = self
        zip.delegate = self
        
        // Do any additional setup after loading the view.
    }
 
    override func viewWillAppear(_ animated: Bool) {
             self.navigationController?.setNavigationBarHidden(false, animated: true)
             self.navigationController?.setToolbarHidden(false, animated: true)
             
         }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        zip.resignFirstResponder()
    }

    

    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        locationNameResult = locationName.text ?? "Bad Name"
        addressResult = address.text ?? "Bad Address"
        cityResult = city.text ?? "Bad City"
        stateResult = state.text ?? "Bad State"
        zipResult = zip.text ?? "-1"
        completeAddress = addressResult + ", " + cityResult + ", " + stateResult + " " + zipResult
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension AddLocationController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state.text = states[row]
        state.resignFirstResponder()
    }
    
}

extension AddLocationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

