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
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    let kmToMiles = 0.621371
    let degToMils = 17.777777777778
    var currDstUnit: String = ""
    var currBearingUnit: String = ""
    var entries: [LocationLookup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = BACKGROUND_COLOR
        currDstUnit = "Kilometers"
        currBearingUnit = "Degrees"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func clearBtnPush(_ sender: UIButton) {
//        self.latitude1.text = "43.077366"
//        self.latitude2.text = "43.077303"
//        self.longitude1.text = "-85.994053"
//        self.longitude2.text = "-85.993860"
        
        self.latitude1.text = ""
        self.latitude2.text = ""
        self.longitude1.text = ""
        self.longitude2.text = ""
        self.distanceLabel.text = "Distance:"
        self.bearingLabel.text = "Bearing:"
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
    
    func computeDistance(point1: CLLocation, point2: CLLocation) {
        var distance = (point1.distance(from: point2)) / 1000.0;
        switch currDstUnit {
        case "Kilometers":
            distance *= 1.0
        case "Miles":
            distance *= kmToMiles
        default:
            distance += 1.0
        }
        self.distanceLabel.text = String(format: "Distance: %.2f \(currDstUnit)", distance)
    }
    
    func computeBearing(point1: CLLocation, point2: CLLocation) {
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
        
        self.bearingLabel.text = String(format: "Bearing: %.2f \(currBearingUnit)", bearing)
    }
    
    @IBAction func calculateBtnPush(_ sender: UIButton) {
        var point1 = CLLocation()
        var point2 = CLLocation()
        (point1, point2) = parseTextInput()

        computeDistance(point1: point1, point2: point2)
        computeBearing(point1: point1, point2: point2)
        entries.append(LocationLookup(origLat: point1.coordinate.latitude, origLng: point1.coordinate.longitude, destLat: point2.coordinate.latitude, destLng: point2.coordinate.longitude, timeStamp: Date()))
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
        
        var point1 = CLLocation()
        var point2 = CLLocation()
        (point1, point2) = parseTextInput()
        computeDistance(point1: point1, point2: point2)
        computeBearing(point1: point1, point2: point2)

    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

