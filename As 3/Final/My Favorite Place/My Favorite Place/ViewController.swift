//
//  ViewController.swift
//  My Favorite Place
//
//  Created by Xin.Yan on 2019/5/10.
//  Copyright © 2019 Yan Xin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentPlace == -1 {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()

            let lpgr = UILongPressGestureRecognizer(target: self, action:
                #selector(ViewController.longpress(gestureRecognizer:)))
            lpgr.minimumPressDuration = 2
            map.addGestureRecognizer(lpgr)
        }
        
        guard currentPlace != -1 else { return }
        guard places.count > currentPlace else { return }
        guard let name = places[currentPlace]["name"] else { return }
        guard let lat = places[currentPlace]["lat"] else { return }
        guard let lon = places[currentPlace]["lon"] else { return }
        guard let latitude = Double(lat) else { return }
        guard let longitude = Double(lon) else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        self.map.addAnnotation(annotation)
        print(currentPlace)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:
            #selector(ViewController.longpress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 2
        map.addGestureRecognizer(lpgr)
        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.004
        let lonDelta: CLLocationDegrees = 0.004
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            print("===\nLong Press\n===")
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            print(newCoordinate)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    } }
                if title == "" {
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                places.append(["name":title, "lat": String(newCoordinate.latitude), "lon":
                    String(newCoordinate.longitude)])
                let place = PlaceCD(context: PlaceCoreData.context)
                place.lat = newCoordinate.latitude
                place.long = newCoordinate.longitude
                place.location = title
                PlaceCoreData.saveContext()
            })
        }
    }

}

