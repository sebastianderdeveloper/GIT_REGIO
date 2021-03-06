//
//  HomeViewController.swift
//  Login_App
//
//  Created by Sebastian Steiner on 04.11.21.
//

import UIKit
import FirebaseFirestore
import MapKit
import CoreLocation

class HomeViewController: UIViewController, ObservableObject, UISearchBarDelegate {

    @IBOutlet var myView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var scrollView2: UIScrollView!
    
    @IBOutlet weak var horizontallyScrollableStackView2: UIStackView!
    
    @IBOutlet weak var map: MKMapView!
    
    @Published var articles = [Article]()
    
    private var db = Firestore.firestore()
    
    var articlesArray: [Article] = []
    
    var searchResults:[Article] = []
    
    var kategorie = ""
    
    var entdeckeList = [Artikel]()
    var entdeckeListGefiltert = [Artikel]()
    var artikelList = [Artikel]()
    
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView2.showsHorizontalScrollIndicator = false
        
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        map.showsUserLocation = true
        
        
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        Utilities.roundCorners(map)
        
            
        fetchData()
        fetchEntdeckeArtikel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            myView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kategoriePost), name: Notification.Name("kategoriePost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(namePost), name: Notification.Name("namePost"), object: nil)

        
        for i in 0...6 {
                   if let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)!.first as? DayView {
                    if (i == 0){
                        dayView.titleLabel.text = "Obst"
                        dayView.imageButton.setImage(UIImage(named: "Obst"),for: .normal)
                      }else if(i==1) {
                        dayView.titleLabel.text = "Gem??se"
                        dayView.imageButton.setImage(UIImage(named: "Gem??se"),for: .normal)
                      }else if(i==2){
                        dayView.titleLabel.text = "Milchprod."
                        dayView.imageButton.setImage(UIImage(named: "Milchprodukte"),for: .normal)
                      }else if(i==3){
                        dayView.titleLabel.text = "Fleisch"
                        dayView.imageButton.setImage(UIImage(named: "Fleisch"),for: .normal)
                      }else if(i==4){
                        dayView.titleLabel.text = "S????waren"
                        dayView.imageButton.setImage(UIImage(named: "S????waren"),for: .normal)
                      }else if(i==5){
                        dayView.titleLabel.text = "Backwaren"
                        dayView.imageButton.setImage(UIImage(named: "Backwaren"),for: .normal)
                      }else if(i==6){
                        dayView.titleLabel.text = "Getr??nke"
                        dayView.imageButton.setImage(UIImage(named: "Getr??nke"),for: .normal)
                      }
                        
                        horizontallyScrollableStackView.addArrangedSubview(dayView)
                   
                   }
        }
        
        
        
        
        
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

    @objc func kategoriePost (notification: NSNotification){
        guard let text = notification.userInfo?["text"] as? String else { return }
            //print ("text: \(text)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TableVC") as! TableViewController
        newViewController.kategorie=text
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @objc func namePost (notification: NSNotification){
        guard let text = notification.userInfo?["text"] as? String else { return }
            print ("text: \(text)")
        var artikel = Artikel()
        for shape in self.entdeckeListGefiltert {
                if(shape.name==text){
                    artikel = Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse,longitude: shape.longitude, latitude: shape.latitude)
            }
        }
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! TableViewDetail
        newViewController.selectedArtikel = artikel
        newViewController.entdecke = true
        //newViewController.kategorie=text
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
    
    func fetchEntdeckeArtikel() {
        
        db.collection("articles").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    //print("No documents")
                    return
                }
                
            self.entdeckeList = documents.map { (queryDocumentSnapshot) -> Artikel in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let kategorie = data["kategorie"] as? String ?? ""
                let adresse = data["adresse"] as? String ?? ""
                let beschreibung = data["beschreibung"] as? String ?? ""
                let bild = data["bild"] as? String ?? ""
                let preis = data["preis"] as? NSNumber ?? 0
                let inhaltsstoffe = data["inhaltsstoffe"] as? String ?? ""
                let menge = data["menge"] as? String ?? ""
                let longitude = data["longitude"] as? NSNumber ?? 0
                let latitude = data["latitude"] as? NSNumber ?? 0
                    //let kategorie = data["kategorie"] as? String ?? ""
                //print("preissss")
                //print(preis)
                
                
                self.entdeckeList.append(Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude))
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude)
                }
            
            
                for shape in self.entdeckeList {
                    
                        if(shape.name=="NOMOO MANGOEIS"){
                            if let entdeckeUI = Bundle.main.loadNibNamed("EntdeckeUI", owner: nil, options: nil)!.first as? EntdeckeUI {
                                self.entdeckeListGefiltert.append(Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse, longitude: shape.longitude, latitude: shape.latitude))
                                entdeckeUI.titleLabel.text = shape.name
                                entdeckeUI.imageButton.setImage(UIImage(named: shape.imageName),for: .normal)
                                self.horizontallyScrollableStackView2.addArrangedSubview(entdeckeUI)
                            }
                    }else if(shape.name=="BIO-Leichtmilch"){
                        if let entdeckeUI = Bundle.main.loadNibNamed("EntdeckeUI", owner: nil, options: nil)!.first as? EntdeckeUI {
                            self.entdeckeListGefiltert.append(Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse, longitude: shape.longitude, latitude: shape.latitude))
                            entdeckeUI.titleLabel.text = shape.name
                            entdeckeUI.imageButton.setImage(UIImage(named: shape.imageName),for: .normal)
                            self.horizontallyScrollableStackView2.addArrangedSubview(entdeckeUI)
                        }
                    }else if(shape.name=="Honest Bio Tee"){
                        if let entdeckeUI = Bundle.main.loadNibNamed("EntdeckeUI", owner: nil, options: nil)!.first as? EntdeckeUI {
                            self.entdeckeListGefiltert.append(Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse, longitude: shape.longitude, latitude: shape.latitude))
                            entdeckeUI.titleLabel.text = shape.name
                            entdeckeUI.imageButton.setImage(UIImage(named: shape.imageName),for: .normal)
                            self.horizontallyScrollableStackView2.addArrangedSubview(entdeckeUI)
                        }
                    }
                    
                }
                
            }
        
        /*for i in 0...2 {
                   if let entdeckeUI = Bundle.main.loadNibNamed("EntdeckeUI", owner: nil, options: nil)!.first as? EntdeckeUI {
                    if (i==0) {
                        entdeckeUI.titleLabel.text = "BIO Leichtmilch"
                        entdeckeUI.imageButton.setImage(UIImage(named: "entdecke_milch"),for: .normal)
                      }else if(i==1){
                        entdeckeUI.titleLabel.text = "Bio Tee"
                        entdeckeUI.imageButton.setImage(UIImage(named: "entdecke_tee"),for: .normal)
                      }else if(i==2){
                        entdeckeUI.titleLabel.text = "Mango Eis"
                        entdeckeUI.imageButton.setImage(UIImage(named: "entdecke_eis"),for: .normal)
                      }
                        horizontallyScrollableStackView2.addArrangedSubview(entdeckeUI)
                   }
        }*/
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

extension ViewController: CLLocationManagerDelegate {
    
    // iOS 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("Not determined")
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")
            case .authorizedAlways:
                print("Authorized Always")
            case .authorizedWhenInUse:
                print("Authorized When in Use")
            @unknown default:
                print("Unknown status")
            }
        }
    }
    
    // iOS 13 and below
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("Authorized Always")
        case .authorizedWhenInUse:
            print("Authorized When in Use")
        @unknown default:
            print("Unknown status")
        }
    }
}
