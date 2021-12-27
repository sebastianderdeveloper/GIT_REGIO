
import UIKit
import FirebaseFirestore

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating
{

	
	@IBOutlet weak var shapeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var shapeList = [Shape]()
	var filteredShapes = [Shape]()
    var articlesArray: [Article] = []
    var bool = false
    
    private var db = Firestore.firestore()
    @Published var articles = [Article]()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        initList(searchString: "")
		//initSearchController()
        searchBar.delegate = self
	}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
            initList(searchString: searchText)
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        }
	
	/*func initSearchController()
	{
		searchController.loadViewIfNeeded()
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.enablesReturnKeyAutomatically = false
		searchController.searchBar.returnKeyType = UIReturnKeyType.done
		definesPresentationContext = true
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.scopeButtonTitles = ["All", "Rect", "Square", "Oct", "Circle", "Triangle"]
		searchController.searchBar.delegate = self
	}*/
	
    func initList(searchString: String)
	{
        db.collection("articles").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
            self.shapeList.removeAll()
            
            self.shapeList = documents.map { (queryDocumentSnapshot) -> Shape in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    //let kategorie = data["kategorie"] as? String ?? ""
                    //print(name)
                self.shapeList.append(Shape(id: "9", name: name, imageName: "triangle"))
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                    return Shape(id: "9", name: name, imageName: "triangle")
                }
            if(searchString.isEmpty){
                self.shapeTableView.reloadData()
            }else{
                //let result2 = self.shapeList.filter { $0.name.starts(with: searchString) }
                var result = [Shape]()
                print("suffix")
                
                for shape in self.shapeList {
                    print(shape.name.prefix(searchString.count))
                    if (shape.name.prefix(searchString.count) == searchString||shape.name.prefix(searchString.count) == searchString.lowercased()) {
                        result.append(Shape(id: "9", name: shape.name, imageName: "triangle"))
                    }
                }
                
                print("test: ")
                print(result)
                print("test2: ")
                //print(result2)
                
                self.shapeList = result
                result.removeAll()
                self.shapeTableView.reloadData()
            }
            
            
            }
        
        //let result = shapeList.filter { $0.name.starts(with: "M") }
        
        
        
        /*let circle = Shape(id: "0", name: "Circle 1", imageName: "circle")
		shapeList.append(circle)
		
		let square = Shape(id: "1", name: "Square 1", imageName: "square")
		shapeList.append(square)
		
		let octagon = Shape(id: "2", name: "Octagon 1", imageName: "octagon")
		shapeList.append(octagon)
		
		let rectangle = Shape(id: "3", name: "Rectangle 1", imageName: "rectangle")
		shapeList.append(rectangle)
		
		let triangle = Shape(id: "4", name: "Triangle 1", imageName: "triangle")
		shapeList.append(triangle)
		
		let circle2 = Shape(id: "5", name: "Circle 2", imageName: "circle")
		shapeList.append(circle2)
		
		let square2 = Shape(id: "6", name: "Square 2", imageName: "square")
		shapeList.append(square2)
		
		let octagon2 = Shape(id: "7", name: "Octagon 2", imageName: "octagon")
		shapeList.append(octagon2)
		
		let rectangle2 = Shape(id: "8", name: "Rectangle 2", imageName: "rectangle")
		shapeList.append(rectangle2)
		
		let triangle2 = Shape(id: "9", name: "Triangle 2", imageName: "triangle")
		shapeList.append(triangle2)*/
	}

    func fetchData() {
        
        
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		
        if(bool)
        {
            return filteredShapes.count
        }
        return shapeList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell
		
		let thisShape: Shape!
		
		
        if(bool)
        {
            thisShape = filteredShapes[indexPath.row]
        }
        else
        {
            thisShape = shapeList[indexPath.row]
        }
		
		
		
		tableViewCell.shapeName.text = thisShape.id + " " + thisShape.name
		tableViewCell.shapeImage.image = UIImage(named: thisShape.imageName)
		
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
			
			let selectedShape: Shape!
			
            if(bool)
            {
                selectedShape = filteredShapes[indexPath.row]
            }
            else
            {
                selectedShape = shapeList[indexPath.row]
            }
			
			
			
			tableViewDetail!.selectedShape = selectedShape
			
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
		filteredShapes = shapeList.filter
		{
			shape in
			let scopeMatch = (scopeButton == "All" || shape.name.lowercased().contains(scopeButton.lowercased()))
			
				return scopeMatch
			
		}
		shapeTableView.reloadData()
	}
}

