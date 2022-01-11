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
   // let coordinate = CLLocationCoordinate2D(latitude: 16.889167, longitude: 42.561111)
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
    override func loadView() {
       mapView = MKMapView()
        mapView.mapType = .hybrid
       // mapView.frame = view.bounds
      //  mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
//        let request = MKLocalSearch.Request()
//        request.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
//        request.naturalLanguageQuery = "Fix Car"
//        request.region = mapView.region
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "cafe"
        request.region = mapView.region
//        let pin = MKPointAnnotation()
//        pin.coordinate = CLLocationSourceInformation(request)
//            .naturalLanguageQuery = "Fix Car"
//        pin.title = "Fix Car"
//        mapView.addAnnotation(pin)
//        mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.hotel]))
        mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.park]))
       
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
        
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        //delegates
        locationManager.delegate = self
        self.mapView.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.startUpdatingLocation()
       // mapView.userLocation = .
        self.mapView.showsUserLocation = true

//addAnnotation()
    }

//
    //zoom
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }

    func addAnnotation(){
     //   var w = "Fix Car"
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 24.693719, longitude: 46.723596)
        var pins = MKPointOfInterestFilter?.some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.hotel]))
//        pin.coordinate = CLLocationCoordinate2D.init(pins.self)
        //        pin.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.university]))


        pin.title = "car fix"
        pin.subtitle = "0000"
        mapView.addAnnotation(pin)
    }
//    func setupMap(hotelListData:[HotelListData], cityLocation:
//                   CLLocationCoordinate2D ){
//
//      let coordinateRegion = MKCoordinateRegion(center: cityLocation, latitudinalMeters: CLLocationDistance(exactly: 15000)!, longitudinalMeters: CLLocationDistance(exactly: 15000)!)
//      mapView.setRegion(coordinateRegion, animated: true)
//
//      //Set Multiple Annotation
//      for data in hotelListData {
//          let annotation = MKPointAnnotation()
//          annotation.title = data.hotel?.name
//          annotation.coordinate = CLLocationCoordinate2D(latitude: Double(data.hotel?.latitude ?? 0.0), longitude: Double(data.hotel?.longitude ?? 0.0))
//          mapView.addAnnotation(annotation)
//      }
//  }

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
