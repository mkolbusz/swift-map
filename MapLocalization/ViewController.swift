//
//  ViewController.swift
//  MapLocalization
//
//  Created by Użytkownik Gość on 26.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    var locationManager : CLLocationManager!
    var myLocations : [CLLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.enabled = false
        startButton.enabled = true
        clearButton.enabled = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        
        mapView.delegate = self
        mapView.mapType = MKMapType.Satellite
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startFollow(sender: UIButton) {
        stopButton.enabled = true;
        startButton.enabled = false;
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopFollow(sender: UIButton) {
        startButton.enabled = true;
        stopButton.enabled = false;
        clearButton.enabled = true;
        locationManager.stopUpdatingLocation();
        mapView.showsUserLocation = false;
    }

    @IBAction func clear(sender: UIButton) {
        clearButton.enabled = false;
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocations.append(locations[0] as CLLocation)
        
        let speed : CLLocationSpeed = locationManager.location!.speed;

        let newRegion = MKCoordinateRegionMakeWithDistance(locationManager.location!.coordinate, 10 + 40*speed, 10 + 40*speed)
        mapView.setRegion(newRegion, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = (myLocations.last?.coordinate)!
        annotation.title = String(format: "%.0f km/h", speed * 3.6)
        mapView.addAnnotation(annotation)
    }

}

