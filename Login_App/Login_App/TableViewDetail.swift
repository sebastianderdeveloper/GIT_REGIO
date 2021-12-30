
import Foundation
import UIKit

class TableViewDetail: UIViewController
{
	
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleName: UILabel!
	
    @IBOutlet weak var addToCartButton: UIButton!
    
	var selectedShape : Shape!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		articleName.text = selectedShape.name
		articleImage.image = UIImage(named: selectedShape.imageName)
        Utilities.styleFilledButton(addToCartButton)
	}
}
