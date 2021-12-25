//
//  HomeViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        scrollView.showsHorizontalScrollIndicator = false
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for _ in 0...10 {
                   if let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)!.first as? DayView {
                       dayView.titleLabel.text = "Friday"
                       dayView.detailLabel.text = "A long detail text will be shown here"
                       horizontallyScrollableStackView.addArrangedSubview(dayView)
                   }
               }
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
