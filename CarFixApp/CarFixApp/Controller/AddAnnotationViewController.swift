////
////  AddAnnotationViewController.swift
////  CarFixApp
////
////  Created by Hanan Somily on 12/01/2022.
////
//
import UIKit
import MapKit
import Firebase
import CoreLocation

class AddAnnotationViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    // ---------------- localize and Design ---------------

    @IBOutlet weak var titleLable: UILabel!{
        didSet{
            titleLable.clipsToBounds = true
            titleLable.layer.cornerRadius = 5
            titleLable.text = "title".localized
        }
    }
    
    @IBOutlet weak var latitudeLabel: UILabel!{
        didSet{
            latitudeLabel.clipsToBounds = true
            latitudeLabel.layer.cornerRadius = 5
            latitudeLabel.text = "latitude".localized
        }
    }
    
    @IBOutlet weak var longitudeLabel: UILabel!{
        didSet{
            longitudeLabel.clipsToBounds = true
            longitudeLabel.layer.cornerRadius = 5
            longitudeLabel.text = "longitude".localized
        }
    }
    
    @IBOutlet weak var designStack: UIStackView!{
        didSet{
            designStack.clipsToBounds = true
            designStack.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var desingButton: UIButton!{
        didSet{
            desingButton.clipsToBounds = true
            desingButton.layer.cornerRadius = 0
            desingButton.setTitle("ADD".localized, for: .normal)
        }
    }
//var flag = 0
    @IBOutlet weak var nameOfWorkshop: UITextField!{
        didSet{
            nameOfWorkshop.clipsToBounds = true
            nameOfWorkshop.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var latitudeTextView: UITextView!{
        didSet{
            latitudeTextView.clipsToBounds = true
            latitudeTextView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var longitudeTextView: UITextView!{
        didSet{
            longitudeTextView.clipsToBounds = true
            longitudeTextView.layer.cornerRadius = 5
        }
    }
    // ---------------- localize and Design ---------------
    var locationManager = CLLocationManager ()
    var annotation = MKPointAnnotation()
    
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.clipsToBounds = true
            mapView.layer.cornerRadius = 20
//                    mapView.isHidden = true
//                    let gestureRecognizer = UITapGestureRecognizer(
//                        target: self, action:#selector(handleTap))
//                    gestureRecognizer.delegate = self
//                    mapView.addGestureRecognizer(gestureRecognizer)
                }
    }
    
    let activityIndicator = UIActivityIndicatorView()

    var wokshops = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()
             
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //latitudeTextView.text = String(latitudeLocation)
        print("location enp")
            locationManager.startUpdatingLocation()
    }
    else {
        print("not found")
        }
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           print(currentLoc.coordinate.latitude)
            latitudeTextView.text = String(currentLoc.coordinate.latitude)
           print(currentLoc.coordinate.longitude)
            longitudeTextView.text = String(currentLoc.coordinate.longitude)
        }
//        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//        mapView.setRegion(region, animated: true)
      //  self.mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
    }
    
    var latitudeLocation = 0.0
    var longitudeLocation = 0.0
    
    @IBAction func addlocation(_ sender: Any) {
        if let  title = nameOfWorkshop.text,
           let latitude = Double(latitudeTextView.text),
           let longitude = Double(longitudeTextView.text),
           let currentUser = Auth.auth().currentUser {
            
    Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            var addLocation = [String:Any]()
            let db = Firestore.firestore()
            let ref = db.collection("WorkShop")
            addLocation = [
                    "title":title,
                    "latitude": latitude,
                    "longitude": longitude
                          ]
            ref.document().setData(addLocation) { error in
                if let error = error {
                    print("FireStore Error",error.localizedDescription)
                }
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                self.navigationController?.popViewController(animated: true)
            }
       }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let cerentLocation = locations[0] as CLLocation
                latitudeLocation = cerentLocation.coordinate.latitude
                longitudeLocation = cerentLocation.coordinate.longitude
//            latitudeTextView.text = " String\(cerentLocation.coordinate.latitude) lllll"
//            longitudeTextView.text = String(cerentLocation.coordinate.longitude )
            print("user location" , cerentLocation)
//            let cerentLocation = CLLocation(latitude: latitudeLocation, longitude: longitudeLocation)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(cerentLocation) { placemarks, error in
                if (error != nil){
                    print("error")
                }
                if let placemarks = placemarks {
                let placemark = placemarks as [CLPlacemark]
                if (placemark.count>0){
                    let place = placemarks[0]
                    let locality = place.locality ?? ""
                    let area = place.administrativeArea ?? ""
                    let country = place.country ?? ""
    //                let y = place.location?.altitude
                    print("locality **** \(locations)")
                    print("area \(area)")
                    print("country\(country)")
                    self.latitudeTextView.text = String( cerentLocation.coordinate.latitude)
                    print(self.latitudeLocation,"//")
                }
            }
        }

//
        // Add a second document with a generated ID.
//            let initialLocation = CLLocation(latitude: latitudeLocation, longitude: longitudeLocation)
//                    setStartingLocation(location: initialLocation, distance: 100)
//
//                    let pin = MKPointAnnotation()
//                    pin.coordinate = CLLocationCoordinate2DMake(latitudeLocation, longitudeLocation)
//                    pin.title = nameOfWorkshop.text
//                    mapView.addAnnotation(pin)
//            print(longitudeLocation , "+++++")
//            latitudeTextView.text = String(latitudeLocation)
    }
//        func setStartingLocation(location: CLLocation, distance: CLLocationDistance){
//            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
//            mapView.setRegion(region, animated: true)
//
//
//        }
//    //zoom
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }

        
        
//current loca
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4
            return renderer
        }
        
        
}
}
//

//extension AddAnnotationViewController:MKMapViewDelegate, UIGestureRecognizerDelegate{
//    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
//
//        let location = gestureRecognizer.location(in: mapView)
//        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
//
//        let annotation = MKPointAnnotation()
//
//        annotation.coordinate = coordinate
//        mapView.addAnnotation(annotation)
//        latitudeLocation = annotation.coordinate.latitude
//        print(latitudeLocation,".....")
//        longitudeLocation = annotation.coordinate.longitude
//        print(longitudeLocation,"////")
//
//    }
//}
