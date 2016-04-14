//
//  VerificationViewController.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 3/27/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import MessageUI
import ParseUI
import Parse


class VerificationViewController: UIViewController {

    var schools = ["University of Michigan", "Michigan University", "Eastern Michigan University"]
    @IBOutlet weak var schoolPicker: UIPickerView!
    
    func numberOfComponentsInPickerView(schoolPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(schoolPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schools.count;
    }
    
    func pickerView(schoolPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return schools[row]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        // Do any additional setup after loading the view.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
