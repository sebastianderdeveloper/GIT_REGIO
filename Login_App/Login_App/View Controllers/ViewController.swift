//
//  ViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    
    var date = ""

    @IBOutlet var myView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        UIView.setAnimationsEnabled(false)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            myView.addGestureRecognizer(tap)
    }

    func setUpElements(){
        Utilities.styleHollowButton(signUpButton)
       // Utilities.styleHollowButton(loginButton)
        errorLabel.alpha = 0
        
        //Style the Elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
        
       
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let _ = string.rangeOfCharacter(from: .uppercaseLetters) {
            // Do not allow upper case letters
            return false
        }

        return true
    }
    
   

    
    @IBAction func logginTabbed(_ sender: Any) {
        //print("clicked Login Button")
        
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
        }
        
    }

    @IBAction func enterTriggered(_ sender: Any) {
        
       
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
        }
        
        }
        
    
}
