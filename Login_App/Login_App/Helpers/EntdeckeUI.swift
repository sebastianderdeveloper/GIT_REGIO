//
//  entdeckeUI.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 02.01.22.
//

import UIKit

class EntdeckeUI: UIView {
   
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBAction func buttonTabbed(_ sender: Any) {
        let kat = titleLabel.text
        let userInfo = [ "text" :  kat]
        NotificationCenter.default.post(name: Notification.Name("namePost"), object: nil, userInfo: userInfo as [AnyHashable : Any])
    }
}


