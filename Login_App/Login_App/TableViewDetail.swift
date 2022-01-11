
import Foundation
import UIKit
import GMStepper
import MapKit
import FirebaseFirestore
import FirebaseAuth


class TableViewDetail: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
	
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleName: UILabel!
	
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var preis: UILabel!
    
    @IBOutlet weak var menge: UILabel!
    
    @IBOutlet weak var beschreibung: UILabel!
    
    @IBOutlet weak var inhaltstoffe: UILabel!
    
    @IBOutlet weak var adresse: UILabel!
    
    @IBOutlet weak var zurück: UIButton!
    
    @IBOutlet weak var gmStepper: GMStepper!
    
    @IBOutlet weak var map: MKMapView!
    
    var selectedArtikel : Artikel!
    var articleList = [Artikel]()
    var db = Firestore.firestore()
    var anzahl = 0
    var entdecke =  false
    var mapView  = false
    var exist = false
    let locationManager = CLLocationManager()
    let database = Firestore.firestore()
    
    var artikelList = [Artikel]()
    
	override func viewDidLoad()
	{
		super.viewDidLoad()
        gmStepper.value = Double(anzahl)
		articleName.text = selectedArtikel.name
		articleImage.image = UIImage(named: selectedArtikel.imageName)
        preis.text = selectedArtikel.preis.stringValue + "€"
        menge.text = selectedArtikel.menge
        beschreibung.text = selectedArtikel.beschreibung
        inhaltstoffe.text = selectedArtikel.inhaltsstoffe
        adresse.text = selectedArtikel.adresse
        Utilities.styleFilledButton(addToCartButton)
        Utilities.styleHollowButton(zurück)
        Utilities.roundCorners(map)
        
        
        
        checkLocationServices()
        
        
        
        map.delegate = self
        addAnn(article: selectedArtikel)
        
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
        
        let docRef = database.document("Openorders: " + userID+"/"+selectedArtikel.name)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            print(data)
        }
        
        
        
	}
    
   

    @IBAction func zurückTabbed(_ sender: Any) {
        if (entdecke){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            self.present(newViewController, animated: true, completion: nil)
        }else if(mapView){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MapVC") as! MapViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TableVC") as! TableViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
    
    func addAnn(article: Artikel){
        let artwork = Artwork(
            title: article.name,
            locationName: article.adresse,
          discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: article.latitude as! Double, longitude: article.longitude as! Double))
            
        
        self.map.addAnnotation(artwork)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
        let coordinate = CLLocationCoordinate2D(latitude: selectedArtikel.latitude as! CLLocationDegrees, longitude: selectedArtikel.longitude as! CLLocationDegrees)
            let region = self.map.regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200))
            self.map.setRegion(region, animated: true)
        }
       
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                map.showsUserLocation = false
                
                locationManager.startUpdatingLocation()
                break
            case .denied:
                // Show alert
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Show alert
                break
            case .authorizedAlways:
                break
            }
        }
        
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                // the user didn't turn it on
            }
        }
        
       
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
 /*   func map(_ map: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
        {
            if annotation is MKUserLocation {return nil}

            let reuseId = "pin"

            var pinView = map.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.image = UIImage(named:"pin")!
                pinView!.animatesDrop = true
                let calloutButton = UIButton(type: .detailDisclosure)
                pinView!.rightCalloutAccessoryView = calloutButton
                pinView!.sizeToFit()
            }
            else {
                pinView!.annotation = annotation
            }


            return pinView
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
              print("button tapped")
            }
        }
    */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard !(annotation is MKUserLocation) else {
        return nil
    }

     let annotationIdentifier = "Identifier"
     var annotationView: MKAnnotationView?
     if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
        annotationView = dequeuedAnnotationView
        annotationView?.annotation = annotation
    }
    else {
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

     if let annotationView = annotationView {

        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "pin")
    }
      return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
             
                openMapForPlace(lat: self.selectedArtikel.latitude as! CLLocationDegrees, long: self.selectedArtikel.longitude as! CLLocationDegrees)
            }
        }
    
    @IBAction func addToCartTabbed(_ sender: Any) {
        
        
        
        
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
       var i=0
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
                //print("1" + name)
                //print("2" + self.selectedArtikel.name ?? "")
                /*if (name == self.selectedArtikel.name ?? ""){
                    //print("yoyoyo")
                    self.exist = true
                }
                
                if(i == self.artikelList.count){
                    self.addUpdate()
                    self.exist = false
                }*/
                
                self.artikelList.append(Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl))
                i = i + 1
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude, anzahl: anzahl)
                }
        }
        
        writeData(selectedArtikel: selectedArtikel)
       //updateData()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OpenBvc") as! OpenOrdersViewController
        //OpenOrdersViewController.artikelList.append(selectedArtikel)
        self.present(newViewController, animated: true, completion: nil)
}
    
    func addUpdate(){
        
        if(self.exist == true){
            updateData()
        }else{
            writeData(selectedArtikel: selectedArtikel)
        }
    }
    
    func writeData(selectedArtikel: Artikel) {
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("Current user ID is" + userID)
        let docRef = database.document("Openorders: " + userID+"/"+selectedArtikel.name)
        docRef.setData(["name": selectedArtikel.name ?? "",
                        "imageName": selectedArtikel.imageName ?? "",
                        "kategorie": selectedArtikel.kategorie ?? "",
                        "preis": selectedArtikel.preis ?? 0,
                        "beschreibung": selectedArtikel.beschreibung ?? "",
                        "inhaltsstoffe": selectedArtikel.inhaltsstoffe ?? "",
                        "menge": selectedArtikel.menge ?? "",
                        "adresse": selectedArtikel.menge ?? "",
                        "longitude": selectedArtikel.menge ?? 0,
                        "latitude": selectedArtikel.latitude ?? 0,
                        "anzahl": selectedArtikel.anzahl
        ])
        
    }
    
    func updateData(){
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("update!!!!!!")
        let selA = db.collection("Openorders: " + userID).document(selectedArtikel.name)

        // Set the "capital" field of the city 'DC'
        selA.updateData([
            "anzahl": 2
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    func openMapForPlace(lat: CLLocationDegrees, long: CLLocationDegrees) {
            let latitude: CLLocationDegrees = lat
            let longitude: CLLocationDegrees = long
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = selectedArtikel.name + " " + selectedArtikel.adresse
       
            mapItem.openInMaps(launchOptions: options)
        }

    @IBAction func stepper_Item_Tapped(_ sender: GMStepper) {
        print(sender.value)
        
    }
    
}


