//
//  PayMethod.swift
//  LOGIN_App
//
//  Created by Sebastian on 04.02.22.
//


import UIKit

class PayMethod: UIView {
    
    @IBOutlet weak var imageButton: UIButton!
    
    
    @IBAction func buttonTabbed(_ sender: Any) {
        let kat = imageButton.currentImage
        let userInfo = [ "payMethod" :  kat]
        NotificationCenter.default.post(name: Notification.Name("imagePost"), object: nil, userInfo: userInfo as [AnyHashable : Any])
    }
}
