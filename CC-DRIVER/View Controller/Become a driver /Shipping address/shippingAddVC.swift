//
//  shippingAddVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/4/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class shippingAddVC: UIViewController {
    @IBOutlet weak var add1Txt: UITextField!
    
    @IBOutlet weak var add2Txt: UITextField!
    
    @IBOutlet weak var CityTxt: UITextField!
    
    @IBOutlet weak var StateTxt: UITextField!
    @IBOutlet weak var zipcodeTxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDayPicker()
        zipcodeTxt.keyboardType = .numberPad
        
        
        if Selectedadd1Txt != "" {
            
            
            add1Txt.text = Selectedadd1Txt
            add2Txt.text = Selectedadd2Txt
            CityTxt.text = SelectedCityTxt
            StateTxt.text = SelectedStateTxt
            zipcodeTxt.text = SelectedzipcodeTxt
            
            
        }
    }
    
    func createDayPicker() {
        
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        //Customizations
        
        
        StateTxt.inputView = dayPicker
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        
        if add1Txt.text != "", CityTxt.text != "", StateTxt.text != "", zipcodeTxt.text != "" {
            
            
            Selectedadd1Txt = add1Txt.text!
            Selectedadd2Txt = add2Txt.text!
            SelectedCityTxt = CityTxt.text!
            SelectedStateTxt = StateTxt.text!
            SelectedzipcodeTxt = zipcodeTxt.text!
            
            
            isShippingDone = true
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension shippingAddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return State.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return State[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        
        StateTxt.text = State[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.text = State[row]
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
