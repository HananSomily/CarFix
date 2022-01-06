//
//  MapViewViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 06/01/2022.
//

import UIKit
import MapKit
class MapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    

//
    var mapView : MKMapView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
    override func loadView() {
       mapView = MKMapView()
        mapView.mapType = .hybrid
        view = mapView
    }
    //---------------------------------- //
   // @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        locationManager.delegate = self
        self.mapView.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.startUpdatingLocation()
       // mapView.userLocation = .

        self.mapView.showsUserLocation = true
    }


    //zoom
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }

}
