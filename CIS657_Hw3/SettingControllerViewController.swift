//
//  SettingControllerViewController.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/15/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//

import UIKit

protocol SettingControllerViewControllerDelegate{
    func indicateSelection(units: (String, String))
}

class SettingControllerViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var bearingButton: UIButton!
    @IBOutlet weak var unitsPicker: UIPickerView!
    
    // Picker data
    let unitPickerData: [String] = ["Mile","Kilometer"]
    let bearingUnitPickerData: [String] = ["Mils","Degrees"]
    var currDstUnit: String = "Kilometer"
    var currBearingUnit: String = "Mils"
    
    var senderBtnTag :Int = 0
    var delegate: SettingControllerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitsPicker.isHidden = true
        self.unitsPicker.delegate = self
        self.unitsPicker.dataSource = self
        self.distanceButton.setTitle(self.currDstUnit, for: .normal)
        self.bearingButton.setTitle(self.currBearingUnit, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.unitsPicker.isHidden = true
    }
    
    @IBAction func btnEventListener(_ sender: UIButton) {
        self.senderBtnTag = sender.tag
        self.unitsPicker.reloadAllComponents()
        self.unitsPicker.isHidden = false
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let d = self.delegate {
            d.indicateSelection(units: (currDstUnit, currBearingUnit))
        }
    }
}

extension SettingControllerViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    //to return how many UIPicker do we have on this page -we only have one picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //picker data count to return number of array in each pickerData array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if senderBtnTag == distanceButton.tag {
            return unitPickerData.count
        } else {
        return bearingUnitPickerData.count
        }
    }
    
    //func to give specific values once picker is selected
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if senderBtnTag == distanceButton.tag {
            return unitPickerData[row]
        } else {
            return bearingUnitPickerData[row]
        }
    }
    
    //when user select a row in the picker and saved that in selection model data
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if senderBtnTag == distanceButton.tag{
            //save the selected row in the current distance unit
            currDstUnit = unitPickerData[row]
            distanceButton.setTitle(currDstUnit, for: .normal)

        }else{
            //save the selected row in the current bearing unit
            currBearingUnit = bearingUnitPickerData[row]
            bearingButton.setTitle(currBearingUnit, for: .normal)
        }
    }
}


