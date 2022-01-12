
import Foundation
import UIKit
import GMStepper
import MapKit
import FirebaseFirestore
import FirebaseAuth


class TableViewDetailOrder: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
   /* @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleName: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var preis: UILabel!
    
    @IBOutlet weak var menge: UILabel!
    
    @IBOutlet weak var beschreibung: UILabel!
    
    @IBOutlet weak var inhaltstoffe: UILabel!
    
    @IBOutlet weak var adresse: UILabel!
    
    @IBOutlet weak var zurück: UIButton!
    
    @IBOutlet weak var gmStepper: GMStepper!
    
    @IBOutlet weak var map: MKMapView!*/
    
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
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedArtikel : Artikel!
    var articleList = [Artikel]()
    var db = Firestore.firestore()
    var anzahl = 1
    var entdecke =  false
    var mapView  = false
    var exist = false
    let locationManager = CLLocationManager()
    let database = Firestore.firestore()
    
    @Published var artikelList = [Artikel]()
    
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
        Utilities.styleHollowButton(deleteButton)
        
        
        
        checkLocationServices()
        
        
        
        map.delegate = self
        addAnn(article: selectedArtikel)
        
        
        
        
        
    }
    
   

    @IBAction func zurückTabbed(_ sender: Any) {
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "OpenBvc") as! OpenOrdersViewController
            self.present(newViewController, animated: true, completion: nil)
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
       
        db.collection("Openorders: " + userID).getDocuments { snapshot, error in
                   
                   // Check for errors
                   if error == nil {
                       // No errors
                       
                       if let snapshot = snapshot {
                           
                           // Update the list property in the main thread
                           DispatchQueue.main.async {
                               
                               // Get all the documents and create Todos
                               self.artikelList = snapshot.documents.map { d in
                                   print("list")
                                print(d["name"])
                                if (d["name"] as! String == self.selectedArtikel.name ?? ""){
                                   print("yoyoyo")
                                   self.updateData()
                                   self.exist = true
                               }
                                   // Create a Todo item for each document returned
                                   return Artikel(
                                               name: d["name"] as? String ?? "",
                                               kategorie: d["kategorie"] as? String ?? "")
                               }
                           }
                           
                           
                       }
                   }
                   else {
               print("fehlerrr")
               }
        }
       
       
        if (self.exist==false){
            self.writeData(selectedArtikel: self.selectedArtikel)
        }
        print("artikelList GGGGG")
            print(self.artikelList.count)
        self.exist = false
        
        
       //updateData()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OpenBvc") as! OpenOrdersViewController
        
        //OpenOrdersViewController.artikelList.append(selectedArtikel)
        self.present(newViewController, animated: true, completion: nil)
        
        
        
    }
    
   /* func addUpdate(){
        
        if(self.exist == true){
            updateData()
        }else{
            writeData(selectedArtikel: selectedArtikel)
        }
    }*/
    
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
                        "adresse": selectedArtikel.adresse ?? "",
                        "longitude": selectedArtikel.longitude ?? 0,
                        "latitude": selectedArtikel.latitude ?? 0,
                        "anzahl": anzahl
        ])
        
    }
    
    func updateData(){
        let userID : String = (Auth.auth().currentUser?.uid)!
           print("update!!!!!!")
        let selA = db.collection("Openorders: " + userID).document(selectedArtikel.name)

        // Set the "capital" field of the city 'DC'
        selA.updateData([
            "anzahl": selectedArtikel.anzahl + 1
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

    /*@IBAction func stepper_Item_Tapped(_ sender: GMStepper) {
        print(sender.value)
        anzahl = Int(sender.value)
        
    }*/
    
    @IBAction func stepper_Item_Tapped(_ sender: GMStepper) {
        print(sender.value)
        anzahl = Int(sender.value)
    }
    
    
}



