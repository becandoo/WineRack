//
//  AccountViewController.swift
//  WineRack
//
//  Created by Brandon Cranmore on 5/19/22.
//

import UIKit
import Foundation
import FirebaseAuth

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        //performSegue(withIdentifier: "toLoginViewController", sender: nil)
        do {
            try Auth.auth().signOut()
            let loginViewController =
            storyboard?.instantiateViewController(identifier:
            Constants.Storyboard.loginViewController) as? ViewController
            view.window?.rootViewController = loginViewController
            
        } catch {
            print("unable to logout, please try again.")
        }
    }
}
