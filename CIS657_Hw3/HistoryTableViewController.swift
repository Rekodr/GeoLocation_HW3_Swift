//
//  HistoryTableViewController.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/28/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//

import UIKit

protocol HistoryTableViewControllerDelegate {
    func selectEntry(entry: LocationLookup)
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    struct Formatter {
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
}

class HistoryTableViewController: UITableViewController {
    var delegate: HistoryTableViewControllerDelegate?
    var entries:[LocationLookup] = []
    
    var tableViewData: [(sectionHeader: String, entries: [LocationLookup])]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sortIntoSections(entries: entries)
    }
    
    func sortIntoSections(entries: [LocationLookup]) {
        var tmpEntries : Dictionary<String,[LocationLookup]> = [:]
        var tmpData: [(sectionHeader: String, entries: [LocationLookup])] = []
        // partition into sections
        for entry in entries {
            let shortDate = entry.timeStamp.short
            if var bucket = tmpEntries[shortDate] {
                bucket.append(entry)
                tmpEntries[shortDate] = bucket
            } else {
                tmpEntries[shortDate] = [entry]
            }
        }
        // breakout into our preferred array format
        let keys = tmpEntries.keys
        for key in keys {
            if let val = tmpEntries[key] {
                tmpData.append((sectionHeader: key, entries: val))
            }
        }
        // sort by increasing date.
        tmpData.sort { (v1, v2) -> Bool in
            if v1.sectionHeader < v2.sectionHeader {
                return true
            } else {
                return false
            }
        }
        self.tableViewData = tmpData
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let data = tableViewData {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = tableViewData?[section] {
            return sectionInfo.entries.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fancyCell", for: indexPath) as! HistoryTableViewCell
        
        if let entry = tableViewData?[indexPath.section].entries[indexPath.row] {
            cell.originPoint.text = "(\(entry.origLat.roundTo(places: 4))), (\(entry.origLng.roundTo(places: 4)))"
            cell.destPoint.text = "(\(entry.destLat.roundTo(places: 4))), (\(entry.destLng.roundTo(places: 4)))"
            cell.timestamp.text = "\(entry.timeStamp.description)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            if let selected = tableViewData?[indexPath.section].entries[indexPath.row] {
                delegate.selectEntry(entry: selected)
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewData?[section].sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = FOREGROUND_COLOR
        header.contentView.backgroundColor = BACKGROUND_COLOR
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = FOREGROUND_COLOR
        footer.contentView.backgroundColor = BACKGROUND_COLOR
    }
}
