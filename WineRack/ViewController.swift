//
//  ViewController.swift
//  WineRack
//
//  Created by Brandon Cranmore on 5/18/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorMessageText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
   
        
        //setup elements\styles
        setUpElements()
    }
    
    //style login elements programatically
    func setUpElements(){
        //hide error message
        errorMessageText.alpha = 0
        passwordText.isSecureTextEntry = true
    }
    
    func validateFields() -> String? {
        
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        
        //check if email address is valid
        let validEmail = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmailAddr(strToValidate: validEmail) == false {
             return "Please enter a valid email address"
        }
        
        return nil
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        //validate text fields
        // Validate form fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            //sign user in
            signIn()
            
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpViewController", sender: nil)
    }
    
    func signIn() {
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if err != nil {
                //unable to sign in
                self.errorMessageText.text = err!.localizedDescription
                self.errorMessageText.alpha = 1
            } else {
                self.transitionToMain()
            }
        }
    }
    
    //move function to utilities file?
    func showError(_ message:String) {
        errorMessageText.text = message
        errorMessageText.alpha = 1
    }
    
    //move function to utilities file?
    func transitionToMain(){
        //performSegue(withIdentifier: "toLoginViewController", sender: nil)
        
        let mainViewController = storyboard?.instantiateViewController(identifier:
            Constants.Storyboard.mainViewController) as? UITabBarController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
        
    }
}

