//
//  LoginViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements(){
        
        //Hide the error Label
      
    }
    

    
     
    
    /*print("clicked Login Button")
     // Validate Text Fields
     
     // Create cleaned versions of the text field
     let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     
     // Signing in the user
     Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
         if error != nil {
             self.errorLabel.text = error!.localizedDescription
             self.errorLabel.alpha = 1
             
         }
         else {
             
             let homeViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
             
             self.view.window?.rootViewController = homeViewController
             self.view.window?.makeKeyAndVisible()
             
         }
     }*/
 
    
    
    
    

}
