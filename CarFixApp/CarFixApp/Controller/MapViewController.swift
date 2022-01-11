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
    let locations = [

         Location(title: "Rifai", latitude: 16.599787, longitude: 42.934036),
         Location(title: "Al Gefri Parts", latitude: 16.599555, longitude:  42.934627),
         Location(title: "Munif Alnahdi For Car Services", latitude: 16.600798, longitude: 42.934396),
         Location(title: "Al Manqari Workshop & Fabrication", latitude: 16.726253, longitude: 42.927962),
//         Location(title: "Workshop5", latitude: 16.894881, longitude: 42.603510),
//         Location(title: "Workshop6", latitude: 17.060211, longitude: 42.900323),
//         Location(title: "Workshop7", latitude: 16.584599, longitude: 42.917191),
//         Location(title: "Workshop8", latitude: 16.837594, longitude: 42.617635),
//         Location(title: "Workshop9", latitude: 16.839463, longitude: 42.620333),
         Location(title: "Bin Shihon Group Hankook",latitude: 16.897807, longitude:  42.604688),
         Location(title: "Hassan Abdullah Adani For Tire Repair", latitude: 16.903757, longitude: 42.606019),
         Location(title: "Al-MaBouj Public Publishing", latitude: 16.899574, longitude: 42.604977),
         Location(title: "Khalid Abdullah Alsafi Co Marshal", latitude: 16.896694, longitude:  42.604334),
         Location(title: "Company Ltd First Box", latitude: 16.896367, longitude:  42.604236),
         Location(title: "Ayed Al Shehri Workshop", latitude: 16.840635, longitude: 42.618866),
         Location(title: "Al - Fahad Complex For Car Maintenance", latitude: 16.840020, longitude: 42.617655),
         Location(title: "Sedana Car Workshop", latitude: 16.839349, longitude:  42.616348),
         Location(title: "Al Taj Technical Center For Cars Maintenance", latitude: 16.838017, longitude: 42.619352),
         Location(title: "Al Wefaq Rent A Car Workshop", latitude: 16.838476, longitude: 42.617973),
         Location(title: "Continents Car Maintenance Center", latitude: 16.839030, longitude: 42.615890),
         Location(title: "Golden Tools Car Maintenance Workshop", latitude: 16.837974,longitude: 42.617043),
         Location(title: "الجياد الابيض لصيانة السيارات", latitude: 16.837594 , longitude: 42.617635),
         Location(title: "Maintenance Of The Emirate Of Jazan Region", latitude: 16.928375 , longitude: 42.560939),
         Location(title: "Bela Hodood Cars Care", latitude: 16.922583 , longitude: 42.554945),
         Location(title: "Almohannad Tires Repair", latitude: 16.922135 , longitude: 42.555284),
         Location(title: "Bahadi Tires And Batteries", latitude: 16.896852 , longitude: 42.550800),
         Location(title: "Al Ati Cars Accessoriese" , latitude: 16.895299, longitude: 42.552879),
         Location(title: "Kawkab Part", latitude: 16.895253 , longitude: 42.552938)
         
     ]


    override func loadView() {
       mapView = MKMapView()
        mapView.mapType = .hybrid

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "cafe"
        request.region = mapView.region

        mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.park]))
       

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
        addAnnotation()
    }

//
    //zoom
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }

    func addAnnotation(){
     //   var w = "Fix Car"
        for location in locations {
        let annotation = MKPointAnnotation()
            annotation.title = location.title
                      annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

                      let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))

                      mapView.addAnnotation(annotation)
                      mapView.setRegion(region, animated: true)
                }
          }
    }
