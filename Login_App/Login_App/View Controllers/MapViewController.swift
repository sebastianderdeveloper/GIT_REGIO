//
//  MapViewController.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 07.01.22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

class MapViewController:UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
  
    
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    let locationManager = CLLocationManager()
    var articleList = [Artikel]()
    
    private var db = Firestore.firestore()
    
    override func viewDidLoad() {
        Utilities.roundCorners(mapView)
        fetchData()
        checkLocationServices()
        
     
        
        mapView.delegate = self
        
        
    }
    
    func fetchData(){
        db.collection("articles").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    //print("No documents")
                    return
                }
                
            self.articleList = documents.map { (queryDocumentSnapshot) -> Artikel in
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
                
                self.addAnn(article: Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude))
                
                self.articleList.append(Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude))
                //self.articlesArray.append (Article(name: name, kategorie: kategorie))
                return Artikel(name: name, imageName: bild, kategorie: kategorie, preis: preis, beschreibung: beschreibung, inhaltsstoffe: inhaltsstoffe, menge: menge, adresse: adresse, longitude: longitude, latitude: latitude)
                }
            
    }
    }
    
    func addAnn(article: Artikel){
        let artwork = Artwork(
            title: article.name,
            locationName: article.adresse,
          discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: article.latitude as! Double, longitude: article.longitude as! Double))
            
        
        self.mapView.addAnnotation(artwork)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
       
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                followUserLocation()
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
        
        func followUserLocation() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
                mapView.setRegion(region, animated: true)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
        
    func locationSearch(){
        let coordinate = CLLocationCoordinate2D(latitude: 48.056740, longitude: 15.130471)
            let region = self.mapView.regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200))
            self.mapView.setRegion(region, animated: true)
    }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
 /*   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
        {
            if annotation is MKUserLocation {return nil}

            let reuseId = "pin"

            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
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
             
                var artikel = Artikel()
                for shape in self.articleList {
                    print(shape.imageName ?? "uff")
                    if(shape.name==view.annotation?.title){
                            
                        artikel = Artikel(name: shape.name, imageName: shape.imageName, kategorie: shape.kategorie, preis: shape.preis, beschreibung: shape.beschreibung, inhaltsstoffe: shape.inhaltsstoffe, menge: shape.menge, adresse: shape.adresse, longitude: shape.longitude, latitude: shape.latitude)
                    }
                }
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! TableViewDetail
                newViewController.selectedArtikel = artikel
                newViewController.mapView = true
                //newViewController.kategorie=text
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    @IBAction func card(_ sender: Any) {
        locationSearch()
    }
    
}

