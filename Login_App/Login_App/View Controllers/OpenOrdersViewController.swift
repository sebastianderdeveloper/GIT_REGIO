//
//  openBaskets.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 10.01.22.
//

import Foundation
import UIKit


class OpenOrdersViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    static var artikelList = [Artikel]()
    
 
    var a = Artikel()
    var preis = 0.0
    
    
    @IBOutlet weak var offeneBestellungen: UIButton!
    
    @IBOutlet weak var abgeschlosseneBestellungen: UIButton!
    
    @IBOutlet weak var routeÖffnen: UIButton!
    
    @IBOutlet weak var bezahlen: UIButton!
    
    @IBOutlet weak var PreisLabel: UILabel!
    
    @IBOutlet weak var shapeTableView: UITableView!
    
    override func viewDidLoad() {
        preis = 0
        designUI()
        gesamtPreis()
    }
    
    func designUI(){
        Utilities.styleFilledButton(offeneBestellungen)
        Utilities.styleHollowButton(abgeschlosseneBestellungen)
        Utilities.styleHollowButton(routeÖffnen)
        Utilities.styleFilledButton(bezahlen)
        }
    
    func gesamtPreis(){
        for artikel in OpenOrdersViewController.artikelList {
            preis = preis + artikel.preis.doubleValue
        }
        PreisLabel.text=String(preis)
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
            
            selectedArtikel = OpenOrdersViewController.artikelList[indexPath.row]
               
            tableViewDetail!.selectedArtikel = selectedArtikel
            tableViewDetail!.entdecke = false
            
            self.shapeTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OpenOrdersViewController.artikelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell2
        
        let thisArtikel: Artikel!
        
        
        
        thisArtikel = OpenOrdersViewController.artikelList[indexPath.row]
        
        
       
        tableViewCell.artikelPreis.text = thisArtikel.preis.stringValue + "€"
        tableViewCell.artikelOrt.text = thisArtikel.adresse
        tableViewCell.artikelName.text =  thisArtikel.name
        tableViewCell.artikelBild.image = UIImage(named: thisArtikel.imageName)
        
        return tableViewCell
    }

    


}










