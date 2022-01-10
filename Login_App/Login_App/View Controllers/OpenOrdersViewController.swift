//
//  openBaskets.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 10.01.22.
//

import Foundation
import UIKit


class OpenOrdersViewController: UIViewController {
    
    @IBOutlet weak var offeneBestellungen: UIButton!
    
    @IBOutlet weak var abgeschlosseneBestellungen: UIButton!
    
    @IBOutlet weak var routeÖffnen: UIButton!
    
    @IBOutlet weak var bezahlen: UIButton!
    
    override func viewDidLoad() {
        designUI()
    }
    
    func designUI(){
        Utilities.styleFilledButton(offeneBestellungen)
        Utilities.styleHollowButton(abgeschlosseneBestellungen)
        Utilities.styleHollowButton(routeÖffnen)
        Utilities.styleFilledButton(bezahlen)
    }
}
