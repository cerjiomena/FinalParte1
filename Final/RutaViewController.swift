//
//  RutaViewController.swift
//  Final
//
//  Created by Serch on 12/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RutaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    var posicionInicial: CLLocation!
    var punto : CLLocationCoordinate2D!
    var distanciaRecorrida : Double!
    var pin : MKPointAnnotation!
    private var origen: MKMapItem!
    private var destino: MKMapItem!
    
    private let reuseIdentifier = "miIdentificador"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manejador.delegate = self
        mapa.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        posicionInicial = nil
        punto = CLLocationCoordinate2D()
        distanciaRecorrida = 0.0
        pin = nil
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(RutaViewController.tapMap))
        tap.minimumPressDuration = 0.2
        mapa.addGestureRecognizer(tap)
       
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let posicionActual : CLLocation = locations.last!
        
        let ultimaPosicion: CLLocation = locations[locations.count - 1]
        
        if posicionInicial == nil {
            posicionInicial = ultimaPosicion
            
        }
        
            
        let inicial = MKPlacemark(coordinate: posicionInicial.coordinate, addressDictionary: nil)
        origen = MKMapItem(placemark: inicial)
            
        let final =  MKPlacemark(coordinate: ultimaPosicion.coordinate, addressDictionary: nil)
        destino = MKMapItem(placemark: final)
            
        self.obtenerRuta(self.origen!, destino: self.destino!)

        
        let center = CLLocationCoordinate2D(latitude: posicionActual.coordinate.latitude, longitude: posicionActual.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        mapa.setRegion(region, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alerta = UIAlertController(title: "Error", message: "error \(error.code)", preferredStyle: .Alert)
        
        let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {accion in
            
        })
        
        alerta.addAction(accionOK)
        
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissModalView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func obtenerRuta(origen: MKMapItem, destino: MKMapItem) {
        
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Walking
        let indicaciones = MKDirections(request: solicitud)
        
        
        
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta: MKDirectionsResponse?, error: NSError?) in
            
            if(error != nil) {
                
                print("Error al obtener la ruta")
            } else {
                self.muestraRuta(respuesta!)
            }
            
        })
    }
    
    func muestraRuta(respuesta: MKDirectionsResponse) {
        for ruta in respuesta.routes {
            
            mapa.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            
            for paso in ruta.steps {
                
                print(paso.instructions)
            }
        }
        
        /*let centro = origen.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        mapa.setRegion(region, animated: true)*/
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.tintColor = UIColor.greenColor()  // do whatever customization you want
            annotationView?.canShowCallout = true            // but turn off callout
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func tapMap(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.locationInView(self.mapa)
        let newCoord:CLLocationCoordinate2D = mapa.convertPoint(touchPoint, toCoordinateFromView: self.mapa)
        
        let newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        newAnotation.title = "Nueva Loc"
        newAnotation.subtitle = "New Subtitle"
        mapa.addAnnotation(newAnotation)
    }
    

}
