
//
//  openBaskets.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 10.01.22.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth


class ClosedOrdersViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    //static var artikelList = [Artikel]()
    var artikelList = [Artikel]()
    var datesList = [String]()
 
    var a = Artikel()
    var preis = 0.00
    var anzahl = 0
    var db = Firestore.firestore()
    var selectedArtikel: Artikel!
    
    
    

    
    @IBOutlet weak var shapeTableView: UITableView!
    
    @IBOutlet weak var offeneBestellungen: UIButton!
    
    @IBOutlet weak var abgeschlosseneBestellungen: UIButton!
    
    
    
    
    override func viewDidLoad() {
        
        preis = 0
        
        fetchArticles()
        designUI()
        getDates()
        shapeTableView.reloadData()
    }
    
    func getDates(){
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
        
        db.collection("Dates " + userID).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    //print("No documents")
                    return
                }
                
            self.datesList = documents.map { (queryDocumentSnapshot) -> String in
                let data = queryDocumentSnapshot.data()
                let date = data["date"] as? String ?? ""
                print("date")
                print(date)
                
                self.datesList.append(date)
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return date
                }
            
        }
        
        shapeTableView.reloadData()
    }
    
    func fetchArticles(){
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
        
        db.collection("Basket " + userID).document("closedBasket").collection("17.02.2022").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    //print("No documents")
                    return
                }
                
            self.artikelList = documents.map { (queryDocumentSnapshot) -> Artikel in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let kategorie = data["kategorie"] as? String ?? ""
                let adresse = data["adresse"] as? String ?? ""
                let beschreibung = data["beschreibung"] as? String ?? ""
                let bild = data["imageName"] as? String ?? ""
                let preis = data["preis"] as? NSNumber ?? 0
                let inhaltsstoffe = data["inhaltsstoffe"] as? String ?? ""
                let menge = data["menge"] as? String ?? ""
                let longitude = data["longitude"] as? NSNumber ?? 0
                let latitude = data["latitude"] as? NSNumber ?? 0
                let anzahl = data["anzahl"] as? Int ?? 1
                    //let kategorie = data["kategorie"] as? String ?? ""
                //print("preissss")
                print(preis)
                
                
                self.artikelList.append(Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl))
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl)
                }
            
        }
        
        shapeTableView.reloadData()
    }
    
    func designUI(){
        Utilities.styleHollowButton(offeneBestellungen)
        Utilities.styleFilledButton(abgeschlosseneBestellungen)
      
        }
    
  
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration?{
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                print("deletingggg")
                
                let userID : String = (Auth.auth().currentUser?.uid)!
                   print("Current user ID is" + userID)
                
                
            
                
                
                let selectedArtikel: Artikel!
                
                selectedArtikel = self.artikelList[indexPath.row]
                
                
                self.db.collection("Openorders: " + userID).document(selectedArtikel.name).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                        
                    } else {//self.artikelList.remove(at: indexPath.row)
                       // self.shapeTableView.deleteRows(at: [indexPath], with: .automatic)
                    
                        print("Document successfully removed!")
                    }
                }
                
                self.artikelList.remove(at: indexPath.row)
                //self.shapeTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.shapeTableView.reloadData()
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
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
            
            let tableViewDetail = segue.destination as? OrderViewController2
            
            /*let selectedArtikel: Artikel!
            
            selectedArtikel = artikelList[indexPath.row]
               
            tableViewDetail!.selectedArtikel = selectedArtikel
            tableViewDetail!.entdecke = false*/
            
            self.shapeTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell3
        
        let thisDate: String!
        
        
        print(indexPath.row)
        thisDate = datesList[indexPath.row]
        
        
        //selectedArtikel.anzahl = thisArtikel.anzahl
        
        tableViewCell.orderDate.text = thisDate
        tableViewCell.basketImage.image = UIImage(named: "shoppingBasket")
        
        
        return tableViewCell
    }

    


}










