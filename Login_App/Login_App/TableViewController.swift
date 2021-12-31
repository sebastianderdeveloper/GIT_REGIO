
import UIKit
import FirebaseFirestore

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating
{

	
	@IBOutlet weak var shapeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var artikelList = [Artikel]()
	var artikelGefiltert = [Artikel]()
    var articlesArray: [Article] = []
    var bool = false
 
    var selectedScopeIndex = 0
    var searchString = ""
    
    
    private var db = Firestore.firestore()
    @Published var articles = [Article]()
	
	override func viewDidLoad()
	{
        searchBar.selectedScopeButtonIndex = 0
        searchBar.searchBarStyle = .minimal
        
        print("Kategorie")
        //print(kategorie)
		super.viewDidLoad()
        setKategorie()
        initList(searchString: "", searchScopeButton: selectedScopeIndex)
        
        
		//initSearchController()
        searchBar.delegate = self
        //searchBar.showsScopeBar = true
        
	}
    
    func setKategorie(){
        if(kategorie=="Obst"){
            self.selectedScopeIndex = 1
            
            searchBar.selectedScopeButtonIndex = 1
            searchBar.placeholder="Obst"
            initList(searchString: "", searchScopeButton: selectedScopeIndex)
        }else if(kategorie=="Sweets"){
            self.selectedScopeIndex = 2
            
            searchBar.selectedScopeButtonIndex = 2
            searchBar.placeholder="Sweets"
            initList(searchString: "", searchScopeButton: selectedScopeIndex)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
        self.searchString = searchText
        searchBar.showsScopeBar = true
        
        initList(searchString: searchString, searchScopeButton: selectedScopeIndex)
        searchBar.scopeButtonTitles = ["All", "Obst", "Sweets", "Milchprodukte"]
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        
        }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("New scope index is now \(selectedScope)")
        self.selectedScopeIndex = selectedScope
        initList(searchString: searchString, searchScopeButton: selectedScopeIndex)
        searchBar.placeholder=""
        
    }
	
    var name = ""
    var kategorie = ""
    var adresse = ""
    var beschreibung = ""
    var bild = ""
    var preis = NSNumber()
    var inhaltsstoffe = ""
    var menge = ""
	
	
    func initList(searchString: String, searchScopeButton: Int)
	{
        
        db.collection("articles").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    //print("No documents")
                    return
                }
                
            self.artikelList.removeAll()
            
            self.artikelList = documents.map { (queryDocumentSnapshot) -> Artikel in
                let data = queryDocumentSnapshot.data()
                self.name = data["name"] as? String ?? ""
                self.kategorie = data["kategorie"] as? String ?? ""
                self.adresse = data["adresse"] as? String ?? ""
                self.beschreibung = data["beschreibung"] as? String ?? ""
                self.bild = data["bild"] as? String ?? ""
                self.preis = data["preis"] as? NSNumber ?? 0
                self.inhaltsstoffe = data["inhaltsstoffe"] as? String ?? ""
                self.menge = data["menge"] as? String ?? ""
                    //let kategorie = data["kategorie"] as? String ?? ""
                print("preissss")
                //print(preis)
                self.artikelList.append(Artikel(name: self.name, imageName: self.bild, kategorie: self.kategorie, preis: self.preis, beschreibung: self.beschreibung, inhaltsstoffe: self.inhaltsstoffe, menge: self.menge, adresse: self.adresse))
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: self.name, imageName: self.bild, kategorie: self.kategorie, preis: self.preis, beschreibung: self.beschreibung, inhaltsstoffe: self.inhaltsstoffe, menge: self.menge, adresse: self.adresse)
                }
            
            if(searchString.isEmpty){
                var result = [Artikel]()
                if(searchScopeButton==0){
                    self.shapeTableView.reloadData()
                }else if(searchScopeButton==1) {
                    for shape in self.artikelList {
                        //print(shape.name.prefix(searchString.count))
                        
                            if(shape.kategorie=="Obst"){
                                result.append(Artikel(name: self.self.name, imageName: self.self.bild, kategorie: self.self.kategorie, preis: self.self.preis, beschreibung: self.self.beschreibung, inhaltsstoffe: self.self.inhaltsstoffe, menge: self.self.menge, adresse: self.self.adresse))
                            }
                        
                    }
                    self.artikelList = result
                    result.removeAll()
                    self.shapeTableView.reloadData()
                }
                
            }else{
                //let result2 = self.shapeList.filter { $0.name.starts(with: searchString) }
                var result = [Artikel]()
                //print("suffix")
                
                if(searchScopeButton==0){
                    for shape in self.artikelList {
                        //print(shape.name.prefix(searchString.count))
                        if (shape.name.prefix(searchString.count) == searchString||shape.name.prefix(searchString.count) == searchString.lowercased()) {
                           
                            result.append(Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse))
                            
                        }
                    }
                }else if(searchScopeButton==1) {
                    for shape in self.artikelList {
                        //print(shape.name.prefix(searchString.count))
                        if (shape.name.prefix(searchString.count) == searchString||shape.name.prefix(searchString.count) == searchString.lowercased()) {
                            if(shape.kategorie=="test"){
                                result.append(Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse))
                            }
                        }
                    }
                }
                
                
                //print("test: ")
                //print(result)
                //print("test2: ")
                //print(result2)
                
                self.artikelList = result
                result.removeAll()
                self.shapeTableView.reloadData()
            }
            
            
            }
        
       
	}

    func fetchData() {
        
        
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		
        if(bool)
        {
            return artikelGefiltert.count
        }
        return artikelList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell
		
		let thisArtikel: Artikel!
		
		
        if(bool)
        {
            thisArtikel = artikelGefiltert[indexPath.row]
        }
        else
        {
            thisArtikel = artikelList[indexPath.row]
        }
		
       
        tableViewCell.artikelPreis.text = thisArtikel.preis.stringValue
        tableViewCell.artikelOrt.text = thisArtikel.adresse
        tableViewCell.artikelName.text =  thisArtikel.name
        tableViewCell.artikelBild.image = UIImage(named: thisArtikel.imageName)
		
		return tableViewCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		self.performSegue(withIdentifier: "detailSegue", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if(segue.identifier == "detailSegue")
		{
			let indexPath = self.shapeTableView.indexPathForSelectedRow!
			
			let tableViewDetail = segue.destination as? TableViewDetail
			
			let selectedArtikel: Artikel!
			
            if(bool)
            {
                selectedArtikel = artikelGefiltert[indexPath.row]
            }
            else
            {
                selectedArtikel = artikelList[indexPath.row]
            }
			
			
			
			tableViewDetail!.selectedArtikel = selectedArtikel
			
			self.shapeTableView.deselectRow(at: indexPath, animated: true)
		}
	}

	
	func updateSearchResults(for searchController: UISearchController)
	{
		let searchBar = searchController.searchBar
		let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		let searchText = searchBar.text!
		
		filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
	}
	
	func filterForSearchTextAndScopeButton(searchText: String, scopeButton : String = "All")
	{
		artikelGefiltert = artikelList.filter
		{
			shape in
			let scopeMatch = (scopeButton == "All" || shape.name.lowercased().contains(scopeButton.lowercased()))
			
				return scopeMatch
			
		}
		shapeTableView.reloadData()
	}
}

