//
//  MapDreamViewController.swift
//  DreamJornal
//
//  Created by Adriana Pedroza Larsson on 2019-04-14.
//  Copyright © 2019 Adriana Pedroza Larsson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

protocol LocationSelectedDelegate {
    func selectedLocation(address:String)
}

class MapDreamViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
 
     var changingData:NSManagedObject!
    
    @IBOutlet weak var addressMap: UITextField!
    
    @IBOutlet weak var mapViewDream: MKMapView!
    
    var delegate:LocationSelectedDelegate?
    
     let m = CLLocationManager()
 
    let map: [DreamDiaryCoreData] = []
    let newDiary = DreamDiaryCoreData()
    
    var lastSaveLocation:String?
    
    var latilongi = CLLocation(latitude: 59.30987960, longitude: 18.02195620)
   
    
    let locationManager = CLLocationManager()
    
    var name = "Your address"
    var address = ""
    
     var cllocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewDream.delegate = self
        if let location = lastSaveLocation{
            addressMap.text = location
            address = location
        }
        //myLocation()
        
        
       // addressMap.text = address
//
//        let location = CLLocationCoordinate2D(latitude:62.1983366 , longitude: 17.567198)
//        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        let pin = customPin(pinTitle: "\(addressMap.text)", pinsubTitle: "Du är här", location: location)
//        self.mapViewDream.addAnnotation(pin)
//
        
//        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) in
//            if let placeM = placemarks {
//                let placemark = placeM[0]
//                if let userLocation = placemark.location {
//
//
//
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = userLocation.coordinate
//
//                    annotation.title = "\(self.address)"
//                    self.mapViewDream.addAnnotation(annotation)
//
//                }
//            }
//        })
        
    }
    // point to location if location is already to current cell
    override func viewDidAppear(_ animated: Bool) {
        pointThatLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        self.addressMap.resignFirstResponder()
    }
    
    
    // catch the textfield text and show to the map with a pin, distance
    @IBAction func savedButton(_ sender: Any) {
        address = addressMap.text!
        addressSaving()
        print(address)
        pointThatLocation()
    }
    
    
    //points the searched location
    func pointThatLocation(){
        var distance = 500.0
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) in
            if let placeM = placemarks {
                let placemark = placeM[0]
                if let sweLocation = placemark.location {
                    
                    distance = 2*self.latilongi.distance(from: sweLocation)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = sweLocation.coordinate
                    let distString = String(format: "%.1f", distance/1000)
                    annotation.title = "\(self.name)\n\(distString) km"
                    self.mapViewDream.addAnnotation(annotation)
                    
                    let region = MKCoordinateRegion(center: sweLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
                    self.mapViewDream.setRegion(region, animated: false)
                    
                    self.cllocation = sweLocation
                    
                    
                    self.findMyLocation()
                    //self.addressSaving()
                    self.mapViewDream.reloadInputViews()
                }
            }
        })
    }
    
    
    //picks upp the coordinates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.longitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
            mapViewDream.setRegion(region, animated: true)
    }
    
    
    
    
    func findMyLocation(){
    
        
        // ask location, find my location
        m.delegate = self
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.requestWhenInUseAuthorization()
        m.startUpdatingLocation()
    
        
        if CLLocationManager.locationServicesEnabled() {
            
            m.startUpdatingLocation()
            MKPointAnnotation()
        }
    }
    
    
    //switch beteween satellite and standard in the map
    
    @IBAction func swapMap(_ sender:UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            mapViewDream.mapType = .satellite
        default:
            mapViewDream.mapType = .standard
            
        }
    }
    
   // saves location from coordinates
//    func saveLocation(){
//
//
//
//
//        if let latitude: Double = (m.location?.coordinate.latitude), let longitude: Double = (m.location?.coordinate.longitude) {
//            print(latitude, longitude)
//
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//            let context = appDelegate.persistentContainer.viewContext
//
//            //        let entity = NSEntityDescription.entity(forEntityName: "DreamDiaryCoreData", in: context)
//            //        let newItem = DreamDiaryCoreData(entity: entity!, insertInto: context)
//            //
//            //        newItem.savedPlaceLatitude = latitude
//            //        newItem.savedPlaceLongitude = longitude
//            //
//            //        mapViewDream.addAnnotation((newItem.savedPlaceLatitude as? MKAnnotation)!)
//            //        mapViewDream.addAnnotation((newItem.savedPlaceLongitude as? MKAnnotation)!)
//
//            changingData.setValue(latitude, forKey: "savedPlaceLatitude")
//            changingData.setValue(longitude, forKey: "savedPlaceLongitude")
//
//
//            do{
//                try context.save()
//            }catch{
//                print("error")
//            }
//
//        } else {
//            print ("no position")
//        }
//
//
//
//
//    }
    
    //saves the addres, when the user write in the textfiled and clicks on save
    
    func addressSaving(){
    
//
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//
//            let newAddress = DreamDiaryCoreData(context: appDelegate.persistentContainer.viewContext)
//
//            newAddress.address = addressMap.text ?? ""
//
//            appDelegate.saveContext()
//
//
//      addressMap.text = newAddress.address
//
//            self.mapViewDream.reloadInputViews()
//
//        }
    
          delegate?.selectedLocation(address: addressMap.text ?? "")
    }
    
    
    
    
}
