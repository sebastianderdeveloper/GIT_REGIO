//
//  HomeViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit
import FirebaseFirestore







class HomeViewController: UIViewController, ObservableObject {

    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @Published var articles = [Article]()
    
    private var db = Firestore.firestore()
    
    var articlesArray: [Article] = []
    
    var searchResults:[Article] = []
    
    override func viewDidLoad() {
        
        scrollView.showsHorizontalScrollIndicator = false
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchData()
        
       
        
        
        for i in 0...10 {
                   if let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)!.first as? DayView {
                    if i % 2 == 0 {
                        dayView.titleLabel.text = "Obst"
                        dayView.imageCategory.image = UIImage(named: "Obst")
                      } else {
                        dayView.titleLabel.text = "Sweets"
                        dayView.imageCategory.image = UIImage(named: "Süßigkeiten")
                      }
                        
                        horizontallyScrollableStackView.addArrangedSubview(dayView)
                   }
               }
        
        
        
    }

    
    func fetchData() {
        
        db.collection("articles").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
            self.articlesArray.removeAll()
            
            self.articles = documents.map { (queryDocumentSnapshot) -> Article in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    //print(name)
                    self.articlesArray.append (Article(name: name))
                    return Article(name: name)
                }
            
            }
        }
    
    
    func filterContentForSearchText(_ searchText: String) {
        searchResults = self.articlesArray.filter({ (article:Article) -> Bool in
                let nameMatch = article.name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                                
                return nameMatch != nil }
            )
        print(searchResults)
        } // end func filterContent
    

    @IBAction func homeTapped(_ sender: Any) {
        print("home")
        
        //print(self.articlesArray[0].name)
        
        filterContentForSearchText("mi")
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
