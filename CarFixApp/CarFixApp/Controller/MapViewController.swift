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
        
//        let request = MKLocalSearch.Request()
//        request.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
//        request.naturalLanguageQuery = "Fix Car"
//        request.region = mapView.region
        
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "Fix Car"
//        request.region = mapView.region
//        let pin = MKPointAnnotation()
//        pin.coordinate = CLLocationSourceInformation(request)
//            .naturalLanguageQuery = "Fix Car"
//        pin.title = "Fix Car"
//        mapView.addAnnotation(pin)
//        mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.]))
       
//        let request = MKLocalSearch.Request()
//                request.naturalLanguageQuery = "carfix"
//        request.region = mapView.region
//              let search = MKLocalSearch(request: request)

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
//extension MapViewController : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let mapView = mapView,
//            let searchBarText = searchController.searchBar.text else { return }
//
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "Fix Car"
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
////            self.locationManager = response.mapItems
//            //self.tableView.reloadData()
//        }
//    }
//}
