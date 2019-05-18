//
//  ViewController.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/14/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, SettingControllerViewControllerDelegate  {

    @IBOutlet weak var latitude1: UITextField!
    @IBOutlet weak var latitude2: UITextField!
    @IBOutlet weak var longitude1: UITextField!
    @IBOutlet weak var longitude2: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clearBtnPush(_ sender: UIButton) {
        self.latitude1.text = ""
        self.latitude2.text = ""
        self.longitude1.text = ""
        self.longitude2.text = ""
        self.distanceLabel.text = ""
    }
    @IBAction func calculateBtnPush(_ sender: UIButton) {
        var point1 = CLLocation()
        var point2 = CLLocation()
        if let lat1 = self.latitude1.text{
            if let long1 = self.longitude1.text{
                point1 = CLLocation(latitude: Double(lat1)!, longitude: Double(long1)!)
            }
        } else {
            
        }
    
        if let lat2 = self.latitude2.text{
            if let long2 = self.longitude2.text{
                point2 = CLLocation(latitude: Double(lat2)!, longitude: Double(long2)!)
            }
        } else {
            
        }
        
        let distance = (point1.distance(from: point2)) / 1000;
        self.distanceLabel.text = String(distance);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SettingControllerViewController {
            dest.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func indicateSelection(units: (String, String)) {
        print(units)
    }
    
}

