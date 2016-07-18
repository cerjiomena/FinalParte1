//
//  DetalleRutaViewController.swift
//  Final
//
//  Created by Serch on 18/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity
import CoreLocation

class DetalleRutaViewController: UIViewController, MKMapViewDelegate, WCSessionDelegate {

    var rutas: String?
    
    @IBOutlet weak var mapa: MKMapView!
    private var origenCentral: MKMapItem!
    var watchSession : WCSession?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapa.delegate = self
        
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
        }

        desglosarPuntos()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func anotaPunto(punto: MKMapItem) {
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapa.addAnnotation(anota)
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
        
        let centro = origenCentral.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        mapa.setRegion(region, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func desglosarPuntos() {
        
        let arreglo = self.rutas?.componentsSeparatedByString("|")
        var origen: MKMapItem!
        var destino: MKMapItem!
        
        
        for i in (0..<arreglo!.count-1) {
            
            origen = obtenerPunto(arreglo![i])

            if( arreglo!.count > 1) {
                
                destino = self.obtenerPunto(arreglo![i+1])
                
            } else {
                
                destino = origen
                
                
            }
            origenCentral = origen
            self.obtenerRuta(origen!, destino:  destino!)

        }
        
    }
    
    func obtenerPunto(row: String) -> MKMapItem {
        
        var origen: MKMapItem!
        
        var columna = row.componentsSeparatedByString(",")
        
        let puntoCoor = CLLocationCoordinate2D(latitude: Double(columna[1])!, longitude:  Double(columna[2])!)
        let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        origen = MKMapItem(placemark: puntoLugar)
        origen.name = columna[0]
        
        self.anotaPunto(origen)
        
        return origen

    }

    @IBAction func enviarW(sender: AnyObject) {
        print("entre")
        do {
            //watchSession.se
            try watchSession?.updateApplicationContext(["message" : String(rutas)])
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
