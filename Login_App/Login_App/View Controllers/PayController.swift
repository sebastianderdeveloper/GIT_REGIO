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


class PayController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    //static var artikelList = [Artikel]()
    var artikelList = [Artikel]()

 
    var a = Artikel()
    var preis = 0.00
    var anzahl = 0
    var db = Firestore.firestore()
    var selectedArtikel: Artikel!
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    
    @IBOutlet weak var openRoute: UIButton!
    
   
    @IBOutlet weak var PreisLabel: UILabel!
    
    @IBOutlet weak var shapeTableView: UITableView!
    
    @IBOutlet weak var payMoney: UIButton!
    
    
    override func viewDidLoad() {
        
        preis = 0
        fetchArticles()
        designUI()
        gesamtPreis()
        shapeTableView.reloadData()
        zahlungsMethoden()
        NotificationCenter.default.addObserver(self, selector: #selector(namePost), name: Notification.Name("imagePost"), object: nil)

    }
    
    
    @objc func namePost (notification: NSNotification){
        guard let image = notification.userInfo?["payMethod"] as? UIImage else { return }
        checkImageName(yourImage: image)
       
    }
        
    func checkImageName(yourImage: UIImage) {
        if yourImage == UIImage(named: "MastercardDeselect") {
            for subView in horizontallyScrollableStackView.subviews {
                subView.removeFromSuperview()
            }
            
            zahlungsMethoden()
        }
        else if yourImage == UIImage(named: "ApplePayDeselect") {
           
            
            for subView in horizontallyScrollableStackView.subviews {
                subView.removeFromSuperview()
            }
            
            
            for i in 0...1 {
                       if let dayView = Bundle.main.loadNibNamed("PayMethod", owner: nil, options: nil)!.first as? PayMethod {
                        if (i == 0){
                            dayView.imageButton.setImage(UIImage(named: "MastercardDeselect"), for: .normal)
                          }else if(i==1) {
                            dayView.imageButton.setImage(UIImage(named: "ApplePay"), for: .normal)
                          }
                            
                            horizontallyScrollableStackView.addArrangedSubview(dayView)
                        
                       }
            }
            
           
            
        }
     }
    
    func zahlungsMethoden(){
        for i in 0...1 {
                   if let dayView = Bundle.main.loadNibNamed("PayMethod", owner: nil, options: nil)!.first as? PayMethod {
                    if (i == 0){
                        dayView.imageButton.setImage(UIImage(named: "Mastercard"), for: .normal)
                      }else if(i==1) {
                        dayView.imageButton.setImage(UIImage(named: "ApplePayDeselect"), for: .normal)
                      }
                        
                        horizontallyScrollableStackView.addArrangedSubview(dayView)
                    
                   }
        }
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
                self.shapeTableView.reloadData()
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl)
                }
            
        }
        
        shapeTableView.reloadData()
    }
    
    func designUI(){
        Utilities.styleFilledButton(payMoney)
        Utilities.styleHollowButton(openRoute)
        scrollView.showsHorizontalScrollIndicator = false
        shapeTableView.showsVerticalScrollIndicator = false
        }
    
    func gesamtPreis(){
        for artikel in artikelList {
            preis = preis + artikel.preis.doubleValue * Double(artikel.anzahl)
            print("preis")
            print(artikel.preis.doubleValue ?? "")
        }
        print("preis")
        print(artikelList)
        
        PreisLabel.text=String(preis) + "€"
        preis = 0.00
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
        self.performSegue(withIdentifier: "detailSegue2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "detailSegue2")
        {
            let indexPath = self.shapeTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? TableViewDetailPay
            
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
        
        
        print(indexPath.row)
        thisArtikel = artikelList[indexPath.row]
        
        
        //selectedArtikel.anzahl = thisArtikel.anzahl
        
        tableViewCell.artikelPreis.text = thisArtikel.preis.stringValue + "€"
        tableViewCell.artikelOrt.text = thisArtikel.adresse
        tableViewCell.artikelName.text =  thisArtikel.name
        tableViewCell.artikelBild.image = UIImage(named: thisArtikel.imageName)
        tableViewCell.artikelAnzahl.text = "x" + String(thisArtikel.anzahl)
        
        
        return tableViewCell
    }

    
    @IBAction func buyTabbed(_ sender: Any) {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
       
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
        
        for artikel in self.artikelList {
            let docRef = db.collection("Basket " + userID).document("closedBasket").collection(dateFormatter.string(from: date)).document(artikel.name)
            
          
           
                docRef.setData(["name": artikel.name ?? "",
                                "imageName": artikel.imageName ?? "",
                                "kategorie": artikel.kategorie ?? "",
                                "preis": artikel.preis ?? 0,
                                "beschreibung": artikel.beschreibung ?? "",
                                "inhaltsstoffe": artikel.inhaltsstoffe ?? "",
                                "menge": artikel.menge ?? "",
                                "adresse": artikel.adresse ?? "",
                                "longitude": artikel.longitude ?? 0,
                                "latitude": artikel.latitude ?? 0,
                                "anzahl": anzahl,
                                "date": ""
                ])
        }
        
        
        
      /*  let docRef2 = db.collection("Basket " + userID).document("openBasketDate")
        
      
        docRef2.setData(["date": dateFormatter.string(from: date) ?? ""
        ])
        
       
      
           print("update!!!!!!")
        let selA = db.collection("Openorders: " + userID).document((artikelList.first?.name)!)

        for artikel in self.artikelList {
            let selA = db.collection("Openorders: " + userID).document(artikel.name)
            selA.updateData([
                "date": dateFormatter.string(from: date)
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        // Set the "capital" field of the city 'DC'
        
        */
    }

    
  
    @IBAction func openRoute(_ sender: Any) {
        
    }
    
}










