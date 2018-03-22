//
//  ViewController.swift
//  TipCalculator
//
//  Created by William Yang on 3/11/18.
//  Copyright © 2018 WYApplications. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var initialTotal: UITextField!
    @IBOutlet weak var postTipAmount15: UILabel!
    @IBOutlet weak var tip15: UILabel!
    @IBOutlet weak var tipAmount15: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialTotal.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateLabel() {
        if let totalPrice = initialTotal.text, let doubleTotalPrice = Double(totalPrice), let tipPercentage = tip15.text, let doubleTipPercentage = Double(tipPercentage) {
          
            postTipAmount15.text = String(format: "%.2f", calculateTotalTip(initialTotal: doubleTotalPrice, percent: doubleTipPercentage))
            tipAmount15.text = String(format: "%.2f", calculateTipAmount(initialTotal: doubleTotalPrice, percent: doubleTipPercentage))
            print(String(format: "%.2f", calculateTotalTip(initialTotal: doubleTotalPrice, percent: doubleTipPercentage)))
            print("Tip: " + tipAmount15.text!)
        } else {
            let initialTotalPrice = initialTotal.text!
            let doubleTotalPrice = Double(initialTotalPrice)
            let tipPercentage = tip15.text!
            let doubleTipPercentage = Double(tipPercentage)
            print(doubleTotalPrice)
            print(doubleTipPercentage)
            
            print("Not a proper number: " + initialTotal.text!)
        }
        
    }
    private func calculateTotalTip(initialTotal: Double, percent: Double) -> Double {
        return initialTotal * ((percent / 100) + 1)
    }
    
    private func calculateTipAmount(initialTotal: Double, percent: Double) -> Double {
        return initialTotal * (percent / 100)
    }
    // UITextDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //print("Trying to press done")
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("Began editing, trying to update label")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        initialTotal.text = textField.text
        updateLabel()
        //print("Trying to update label")
    }
    // Custom Cell Functions
    var cellDescriptors: NSMutableArray!
    @IBOutlet weak var tblExpandable: UITableView!
    var visibleRowsPerSection = [[Int]]()
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tblExpandable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
    }
    
    func configureTableView(){
        
    }
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            if let currentSection = currentSectionCells as? [[String:AnyObject]] {
                for row in 0...(currentSection.count - 1){
                    if currentSection[row]["isVisible"] as! Bool == true {
                        visibleRows.append(row)
                        
                    }
                }
            } else {
            print("Didnt let")
            }
            visibleRowsPerSection.append(visibleRows)
        }
    }
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = cellDescriptors[indexPath.section][indexOfVisibleRow] as! [String:AnyObject]
        return cellDescriptor
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Personal"
        case 1:
            return "Prefernece"
        default:
            return "Work"
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String {
        case "idCellNormal":
            return 60.0
            
        case "idCellDatePicker":
            return 270.0
            
        default:
            return 44.0
        }
    }
}

