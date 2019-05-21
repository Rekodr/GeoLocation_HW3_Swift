//
//  ViewController.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/14/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, SettingViewControllerDelegate {

    @IBOutlet weak var latitude1: UITextField!
    @IBOutlet weak var latitude2: UITextField!
    @IBOutlet weak var longitude1: UITextField!
    @IBOutlet weak var longitude2: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var bearingTextField: UITextField!
    
    let kmToMiles = 0.621371
    let degToMils = 17.777777777778
    var currDstUnit: String = ""
    var currBearingUnit: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currDstUnit = "Kilometers"
        currBearingUnit = "Degrees"
        longitude1.keyboardType = UIKeyboardType.numbersAndPunctuation
    }

    @IBAction func clearBtnPush(_ sender: UIButton) {
        self.latitude1.text = "43.077366"
        self.latitude2.text = "43.077303"
        self.longitude1.text = "-85.994053"
        self.longitude2.text = "-85.993860"
        self.distanceTextField.text = "0"
        self.bearingTextField.text = "0"
    }
    func parseTextInput() -> (CLLocation, CLLocation) {
        var point1 = CLLocation()
        var point2 = CLLocation()
        if var lat1 = self.latitude1.text{
            if var long1 = self.longitude1.text{
                lat1 = lat1 == "" ? "0" : lat1
                long1 = long1 == "" ? "0" : long1
                point1 = CLLocation(latitude: Double(lat1)!, longitude: Double(long1)!)
            }
        } else {
            
        }
        
        if var lat2 = self.latitude2.text{
            if var long2 = self.longitude2.text{
                lat2 = lat2 == "" ? "0" : lat2
                long2 = long2 == "" ? "0" : long2
                point2 = CLLocation(latitude: Double(lat2)!, longitude: Double(long2)!)
            }
        }
        return (point1, point2)
    }
    
    func computeDistance() {
        var point1 = CLLocation()
        var point2 = CLLocation()
        (point1, point2) = parseTextInput()
        var distance = (point1.distance(from: point2)) / 1000.0;
        switch currDstUnit {
        case "Kilometers":
            distance *= 1.0
        case "Miles":
            distance *= kmToMiles
        default:
            distance += 1.0
        }
        self.distanceTextField.text = String(format: "%.2f \(currDstUnit)", distance)
    }
    
    func computeBearing() {
        var point1 = CLLocation()
        var point2 = CLLocation()
        (point1, point2) = parseTextInput()
        
        let lat1 = point1.coordinate.latitude
        let long1 = point1.coordinate.longitude
        let lat2 = point2.coordinate.latitude
        let long2 = point2.coordinate.longitude
        
        let degLat1 = lat1 * Double.pi / 180.0
        let degLong1 = long1 * Double.pi / 180.0
        let degLat2 = lat2 * Double.pi / 180.0
        let degLong2 = long2 * Double.pi / 180.0
        
        let dlong = degLong2 - degLong1
        
        let y = sin(dlong) * cos(degLat2)
        let x = cos(degLat1) * sin(degLat2) - sin(degLat1) * cos(degLat2) * cos(dlong)
        var bearing = atan2(y, x) * (180.0 / Double.pi)
        
        switch currBearingUnit {
        case "Mils":
            bearing *= degToMils
        case "Degrees":
            bearing *= 1.0
        default:
            bearing *= 1.0
        }
        
        self.bearingTextField.text = String(format: "%.2f \(currBearingUnit)", bearing)
    }
    
    @IBAction func calculateBtnPush(_ sender: UIButton) {
        computeDistance()
        computeBearing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let dest = nav.children[0] as? SettingControllerViewController {
                dest.delegate = self
                dest.currBearingUnit = self.currBearingUnit
                dest.currDstUnit = self.currDstUnit
            }
        }
    }
    
    @IBAction func cancelSettings(segue: UIStoryboardSegue) {
        print("cancel")
    }
    
    
    @IBAction func saveSettings(segue: UIStoryboardSegue) {
        if let src = segue.source as? SettingControllerViewController {
            src.saveSettings()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func settingChanged(units: (String, String)) {
        (self.currDstUnit, self.currBearingUnit) = units
        computeDistance()
        computeBearing()
    }
}

