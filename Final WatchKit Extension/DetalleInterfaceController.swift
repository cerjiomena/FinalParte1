//
//  DetalleInterfaceController.swift
//  Final
//
//  Created by Serch on 17/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import WatchKit
import Foundation


class DetalleInterfaceController: WKInterfaceController,CLLocationManagerDelegate {

    @IBOutlet var mapObject: WKInterfaceMap!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var mapLocation: CLLocationCoordinate2D?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
        
        // Configure interface objects here.
        
        /*let location = CLLocationCoordinate2D(latitude: 37, longitude: -112)
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        mapObject.addAnnotation(location, withPinColor: .Purple)
        
        mapObject.setRegion(MKCoordinateRegion(center: location, span: coordinateSpan))
    */
        
       
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegionMake(self.mapLocation!, span)
        self.mapObject.setRegion(region)
        
        self.mapObject.addAnnotation(self.mapLocation!,
                                     withPinColor: .Red)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error.description)
    }

}
