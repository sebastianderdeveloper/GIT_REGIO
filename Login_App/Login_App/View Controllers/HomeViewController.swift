//
//  HomeViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    @IBAction func homeTapped(_ sender: Any) {
        print("home")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
