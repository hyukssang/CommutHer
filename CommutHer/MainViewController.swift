//
//  ViewController.swift
//  CommutHer
//
//  Created by Sang Hyuk Cho on 3/27/16.
//  Copyright © 2016 si363. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class MainViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var logo: UIImageView!

    var loginController: PFLogInViewController!
    var signupController: PFSignUpViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        PFUser.logOut()
        // If the user is logged in, check for email verification
        if let user = PFUser.currentUser()
        {
            // user.fetchIfNeededInBackground()
            let userverified = (user["emailVerified"] as? Bool) ?? false
            self.dismissViewControllerAnimated(true, completion: {
                if userverified
                {
                    self.performSegueWithIdentifier("skipVerification", sender: nil)
                }
                else{
                    let alertView : UIAlertView = UIAlertView()
                    alertView.title = "Oops!"
                    alertView.message = "It seems you have not verified your identity yet!"
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            })
        } // Else, pop up Parse login page
        else
        {
            self.loginController = PFLogInViewController()
            self.loginController.delegate = self
            self.loginController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .DismissButton]
            
            self.signupController = PFSignUpViewController()
            self.signupController.delegate = self
            self.loginController.signUpController = self.signupController
            
            self.presentViewController(self.loginController, animated: true, completion: nil)
        }
    }
    
    // When User cancels the login
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // When User is logged in
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        let userverified = (user["emailVerified"] as? Bool) ?? false
        self.dismissViewControllerAnimated(true, completion: {
            if userverified
            {
                self.performSegueWithIdentifier("skipVerification", sender: nil)
            }
            else{
                let alertView : UIAlertView = UIAlertView()
                alertView.title = "Oops!"
                alertView.message = "It seems you have not verified your identity yet!"
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        })
    }
    // Check for username and password
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if !username.isEmpty{
            return true
        }
        else{
            return false
        }
    }
    // When login fails
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        let alertView : UIAlertView = UIAlertView()
        alertView.title = "Oops!"
        alertView.message = "Did you type in your username and password correctly?"
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    // When User cancels the signup
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // When User signs up
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // When sign up fails
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        let alertView : UIAlertView = UIAlertView()
        alertView.title = "Oops!"
        alertView.message = "It seems you did not fill in the fields correctly"
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }

}

