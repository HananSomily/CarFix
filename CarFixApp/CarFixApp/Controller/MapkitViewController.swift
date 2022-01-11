////
////  MapkitViewController.swift
////  CarFixApp
////
////  Created by Hanan Somily on 08/01/2022.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//class MapkitViewController: UIViewController , CLLocationManagerDelegate {
//   // var mapView : MKMapView!
//    let locationManager = CLLocationManager()
//
//    @IBOutlet weak var mapView: MKMapView!
//  //  let places = Place.getPlaces()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mapView.mapType = .hybrid
//
//        mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [.marina]))
////        [.init(rawValue: "Fix")]))
//       //view = mapView
//
//let initialLoc = CLLocation(latitude: 16.889167, longitude: 42.561111)
//     setStartingLocation(location: initialLoc, distance: 1000)
//
//
//        addAnnotations()
//
//    }
////    override func viewWillAppear(_ animated: Bool) {
////       super.viewWillAppear(animated)
////
////       //Create the pin location of your restaurant(you need the GPS coordinates for this)
////       let restaurantLocation = CLLocationCoordinate2D(latitude: 16.889167, longitude: 42.561111)
////
////       //Center the map on the place location
////       mapView.setCenter(restaurantLocation, animated: true)
////    }
//
//    func setStartingLocation(location:CLLocation , distance:CLLocationDistance){
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
//        mapView.setRegion(region, animated: true)
//    }
//    func addAnnotations() {
//        mapView?.delegate = self
//       // mapView?.addAnnotations(places)
//    }
//}
//
//extension MapkitViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        else {
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
//            annotationView.image = UIImage(named: "place icon")
//            return annotationView
//        }
//    }
//}
////extension Place: MKAnnotation { }
