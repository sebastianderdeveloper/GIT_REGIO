
import Foundation
import UIKit
import GMStepper

class TableViewDetail: UIViewController
{
	
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleName: UILabel!
	
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var preis: UILabel!
    
    @IBOutlet weak var menge: UILabel!
    
    @IBOutlet weak var beschreibung: UILabel!
    
    @IBOutlet weak var inhaltstoffe: UILabel!
    
    @IBOutlet weak var adresse: UILabel!
    
    @IBOutlet weak var zurück: UIButton!
    
    @IBOutlet weak var gmStepper: GMStepper!
    
    var selectedArtikel : Artikel!
    
    var anzahl = 0
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        gmStepper.value = Double(anzahl)
        
		articleName.text = selectedArtikel.name
		articleImage.image = UIImage(named: selectedArtikel.imageName)
        preis.text = selectedArtikel.preis.stringValue
        menge.text = selectedArtikel.menge
        beschreibung.text = selectedArtikel.beschreibung
        inhaltstoffe.text = selectedArtikel.inhaltsstoffe
        adresse.text = selectedArtikel.adresse
        Utilities.styleFilledButton(addToCartButton)
        Utilities.styleHollowButton(zurück)
	}

}
