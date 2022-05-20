//
//  SignUpViewController.swift
//  WineRack
//
//  Created by Brandon Cranmore on 5/19/22.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var signupEmailText: UITextField!
    @IBOutlet weak var signupPasswordText: UITextField!
    @IBOutlet weak var signupReenterPasswordText: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorMessageLabel.alpha = 0
        signupPasswordText.isSecureTextEntry = true
        signupReenterPasswordText.isSecureTextEntry = true
    }
    
    //check the fields and validate that the data is correct. If everything is correct, this method returns nil.
    //otherwise an error message will be shown.
    func validateFields() -> String? {
        
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signupEmailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signupPasswordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signupReenterPasswordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        //check if password is secure
        let cleanPassword = signupPasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let secondCleanPassword = signupReenterPasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanPassword != secondCleanPassword {
            return "Passwords do not match"
        }
        
        if Utilities.isPasswordValid(cleanPassword) == false {
            //Password isn't secure
            return "Please make suere your password is 8 characters and contains a special character and a number."
        }
        
        //check if email address is valid
        let validEmail = signupEmailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmailAddr(strToValidate: validEmail) == false {
             return "Please enter a valid email address"
        }
        
        return nil
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        // Validate form fields
        let error = validateFields()
        
        if error != nil {
            //there is something wrong with fields, show returned error
            showError(error!)
        } else {
            //create cleaned versions of account data (strip whitespaces and newlines)
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = signupEmailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = signupPasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                // check for errors
                if err != nil {
                    //there was an error creating the user
                    self.showError("Error creating account")
                } else {
                    //user created successfully, add firstname, lastname, and email to firestore database
                    let db = Firestore.firestore()
                    
                    db.collection("accounts").addDocument(data: ["firstname":firstName, "lastname":lastName,"email":email,"uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //remove in production
                            self.showError("Failed adding account details to database")
                        }
                    }
                    
                }
            }
            // Transition to main view controller
            self.transitionToMain()
        }
        
       
    }
    
    @IBAction func cancelCreateAccountClicked(_ sender: Any) {
        performSegue(withIdentifier: "toLoginViewController", sender: nil)
    }
    
    func showError(_ message:String) {
        errorMessageLabel.text = message
        errorMessageLabel.alpha = 1
    }
    
    func transitionToMain(){
        //performSegue(withIdentifier: "toLoginViewController", sender: nil)
        
        let mainViewController = storyboard?.instantiateViewController(identifier:
            Constants.Storyboard.mainViewController) as? UITabBarController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
        
    }
}
