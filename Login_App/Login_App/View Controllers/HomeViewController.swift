//
//  HomeViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit
import FirebaseFirestore







class HomeViewController: UIViewController, ObservableObject, UISearchBarDelegate {

    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @Published var articles = [Article]()
    
    private var db = Firestore.firestore()
    
    var articlesArray: [Article] = []
    
    var searchResults:[Article] = []
    
    var kategorie = ""
    
    override func viewDidLoad() {
        
        scrollView.showsHorizontalScrollIndicator = false
        
        
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        // Do any additional setup after loading the view.
       
        
        
            
        fetchData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("functionName"), object: nil)
        
        
        for i in 0...10 {
                   if let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)!.first as? DayView {
                    if i % 2 == 0 {
                        dayView.titleLabel.text = "Obst"
                        
                        dayView.imageButton.setImage(UIImage(named: "Obst"),for: .normal)
                      } else {
                        dayView.titleLabel.text = "Sweets"
                        
                        dayView.imageButton.setImage(UIImage(named: "Süßigkeiten"),for: .normal)
                      }
                        
                        horizontallyScrollableStackView.addArrangedSubview(dayView)
                   
                   }
               }
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TableVC") as! TableViewController
        newViewController.searchString = searchText
        self.present(newViewController, animated: true, completion: nil)
        
        //self.searchString = searchText
        //searchBar.showsScopeBar = true
        
        //initList(searchString: searchString, searchScopeButton: selectedScopeIndex)
        //searchBar.scopeButtonTitles = ["All", "Obst", "Sweets", "Milchprodukte"]
    }

    @objc func functionName (notification: NSNotification){
        guard let text = notification.userInfo?["text"] as? String else { return }
            //print ("text: \(text)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TableVC") as! TableViewController
        newViewController.kategorie=text
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    func fetchData() {
        
        db.collection("articles").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    //print("No documents")
                    return
                }
                
            self.articlesArray.removeAll()
            
            self.articles = documents.map { (queryDocumentSnapshot) -> Article in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    let kategorie = data["kategorie"] as? String ?? ""
                    //print(name)
                self.articlesArray.append (Article(name: name, kategorie: kategorie))
                    return Article(name: name, kategorie: kategorie)
                }
            
            }
    }
    
    
    
    //https://medium.com/nerd-for-tech/swift-dynamic-search-bar-with-multiple-criteria-and-filter-persistence-905ac05b6ae0

    
    func filterContentForSearchText(_ searchText: String) {
        searchResults = self.articlesArray.filter({ (article:Article) -> Bool in
                let nameMatch = article.name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let kategorieMatch = article.kategorie
                                                    return nameMatch != nil && kategorieMatch == "test"}
            )
        //print(searchResults)
        } // end func filterContent
    

    @IBAction func homeTapped(_ sender: Any) {
        //print("home")
        
        //print(self.articlesArray)
        
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
