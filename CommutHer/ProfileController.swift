//
//  ProfileController.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 3/27/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import Parse

class ProfileController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phonenum: UITextField!
    @IBOutlet weak var school: UITextField!
    
    @IBAction func saveProfile(sender: AnyObject) {
        
        if self.password.text != ""{
            PFUser.currentUser()?.setObject(self.password.text!, forKey: "password")
        }
        if self.email.text != ""{
            PFUser.currentUser()?.setObject(self.email.text!, forKey: "email")
        }
        if self.phonenum.text != ""{
            PFUser.currentUser()?.setObject(self.phonenum.text!, forKey: "phonenum")
        }
        if self.school.text != "" {
            PFUser.currentUser()?.setObject(self.school.text!, forKey: "school")
        }
        
        PFUser.currentUser()?.saveInBackground()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profilePic.image = UIImage(named: "profile")
        self.username.text = PFUser.currentUser()!.username
        self.password.placeholder = PFUser.currentUser()!.password
        self.email.placeholder = PFUser.currentUser()!.email
        self.phonenum.placeholder = PFUser.currentUser()!.objectForKey("phonenum") as? String
        self.school.placeholder = PFUser.currentUser()!.objectForKey("school") as? String
        
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
