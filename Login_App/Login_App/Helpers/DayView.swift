//
//  DayView.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 25.12.21.
//

import UIKit

class DayView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var imageButton: UIButton!
    
    
    @IBAction func imageTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("functionName"), object: nil)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
