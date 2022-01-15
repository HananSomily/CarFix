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

class AddAnnotationViewController: UIViewController  , CLLocationManagerDelegate {
    var locationManager = CLLocationManager ()
    var annotation = MKPointAnnotation()
var flag = 0
    @IBOutlet weak var nameOfWorkshop: UITextField!
    
    @IBOutlet weak var latitudeTextView: UITextView!
    
    @IBOutlet weak var longitudeTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
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
             
        locationManager.delegate = self
       // self.mapView.delegate = self
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
        //self.mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }
    
    var latitudeLocation = 0.0
    var longitudeLocation = 0.0
    
    @IBAction func addlocation(_ sender: Any) {
        if let  title = nameOfWorkshop.text,
           let latitude = latitudeTextView.text,
           let longitude = longitudeTextView.text ,
           let currentUser = Auth.auth().currentUser {
            
    Activity.showIndicator(parentView: self.view, childView: activityIndicator)

   // var ref: DocumentReference? = nil
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

          //  if flag == 0 {
            let cerentLocation = locations[0] as CLLocation
                latitudeLocation = cerentLocation.coordinate.latitude
                longitudeLocation = cerentLocation.coordinate.longitude
//            latitudeTextView.text = " String\(cerentLocation.coordinate.latitude) lllll"
//            longitudeTextView.text = String(cerentLocation.coordinate.longitude )

            
            print("user location" , cerentLocation)
             //   flag = 1
           // }
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
                    print(self.latitudeLocation,"//////")
                   // self.cerantLocationLabel.text = "\(locality) , \(area)"
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
        func setStartingLocation(location: CLLocation, distance: CLLocationDistance){
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
            mapView.setRegion(region, animated: true)
            
         
        }
//    //zoom
    func mapViewZoom(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20))
        mapView.setRegion(region, animated: true)
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
