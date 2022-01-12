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


class OpenOrdersViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    //static var artikelList = [Artikel]()
    var artikelList = [Artikel]()

 
    var a = Artikel()
    var preis = 0.0
    var anzahl = 0
    var db = Firestore.firestore()
    
    @IBOutlet weak var offeneBestellungen: UIButton!
    
    @IBOutlet weak var abgeschlosseneBestellungen: UIButton!
    
    @IBOutlet weak var routeÖffnen: UIButton!
    
    @IBOutlet weak var bezahlen: UIButton!
    
    @IBOutlet weak var PreisLabel: UILabel!
    
    @IBOutlet weak var shapeTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        preis = 0
        fetchArticles()
        designUI()
        gesamtPreis()
        shapeTableView.reloadData()
    }
    
    func fetchArticles(){
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
        
        db.collection("Openorders: " + userID).addSnapshotListener { (querySnapshot, error) in
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
                //print(preis)
                
                
                self.artikelList.append(Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl))
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl)
                }
            
        }
        
        shapeTableView.reloadData()
    }
    
    func designUI(){
        Utilities.styleFilledButton(offeneBestellungen)
        Utilities.styleHollowButton(abgeschlosseneBestellungen)
        Utilities.styleHollowButton(routeÖffnen)
        Utilities.styleFilledButton(bezahlen)
        }
    
    func gesamtPreis(){
        for artikel in artikelList {
            preis = preis + artikel.preis.doubleValue
            print("preis")
            print(artikel.preis ?? "")
        }
        print("preis")
        print(artikelList)
        
        PreisLabel.text=String(preis)
        preis = 0
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
            
            selectedArtikel = artikelList[indexPath.row]
               
            tableViewDetail!.selectedArtikel = selectedArtikel
            tableViewDetail!.entdecke = false
            
            self.shapeTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artikelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        gesamtPreis()
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell2
        
        let thisArtikel: Artikel!
        
        
        
        thisArtikel = artikelList[indexPath.row]
        
        
       
        tableViewCell.artikelPreis.text = thisArtikel.preis.stringValue + "€"
        tableViewCell.artikelOrt.text = thisArtikel.adresse
        tableViewCell.artikelName.text =  thisArtikel.name
        tableViewCell.artikelBild.image = UIImage(named: thisArtikel.imageName)
        tableViewCell.artikelAnzahl.text = String(thisArtikel.anzahl)
        
        return tableViewCell
    }

    


}










