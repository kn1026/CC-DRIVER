//
//  changeSchoolVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/13/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class changeSchoolVC: UIViewController {

    @IBOutlet weak var uniTxtField: UITextField!
    var campus: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createDayPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        uniTxtField.becomeFirstResponder()
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func createDayPicker() {
        
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        //Customizations
        
        
        uniTxtField.inputView = dayPicker
        
        
        
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if uniTxtField.text != ""{
            
            
            campus = uniTxtField.text
            self.performSegue(withIdentifier: "moveToChangeEmailVC2", sender: nil)
            
        } else {
            
            
            showErrorAlert("Oopps !!!", msg: "Please choose your campus")
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "moveToChangeEmailVC2"{
            if let destination = segue.destination as? changeEmailVC {
                destination.campus = campus
            }
        }
        
        
    }
    
}

extension changeSchoolVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return uniList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return uniList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        
        uniTxtField.text = uniList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.text = uniList[row]
        label.textAlignment = .center
        return label
        
        
        
        
        
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}
