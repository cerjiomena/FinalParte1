//
//  RutaPersistViewController.swift
//  Final
//
//  Created by Serch on 15/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit
import CoreData

class RutaPersistViewController: UIViewController,  UITextViewDelegate {
    
    @IBOutlet weak var nombreRuta: UITextField!
    
    @IBOutlet weak var descRuta: UITextView!
    
    @IBOutlet weak var fotoVista: UIImageView!
    
    weak var rutaViewController: RutaViewController?
    
    var contexto : NSManagedObjectContext? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        descRuta.delegate = self
        
        
       

    }
    
    /*override func viewDidAppear(animated: Bool) {
        if(rutaViewController?.puntosColeccion != nil && rutaViewController?.puntosColeccion.count > 0) {
           
            for (i,row) in (rutaViewController?.puntosColeccion.enumerate())! {
                for (j,cell) in row.enumerate() {
                    print("m[\(i),\(j)] = \(cell)")
                }
            }
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPics(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fvc: FotosViewController = storyboard.instantiateViewControllerWithIdentifier("Fotos") as! FotosViewController
        fvc.rutaPersistViewController = self
        fvc.view.backgroundColor = UIColor.darkGrayColor()
        fvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.presentViewController(fvc, animated: true, completion: nil)
    }
  
    @IBAction func dismissModalView(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveRoute(sender: AnyObject) {
        let nuevaRuta = NSEntityDescription.insertNewObjectForEntityForName("Ruta", inManagedObjectContext: self.contexto!)
        
        nuevaRuta.setValue(nombreRuta.text, forKey: "nombre")
        nuevaRuta.setValue(descRuta.text, forKey: "descripcion")
       
        nuevaRuta.setValue(UIImageJPEGRepresentation(self.fotoVista.image!, 1.0), forKey: "foto")
        
        if(rutaViewController?.puntosColeccion != nil && rutaViewController?.puntosColeccion.count > 0) {
            
            for (i,row) in (rutaViewController?.puntosColeccion.enumerate())! {
                let nuevaPosicionEntidad = NSEntityDescription.entityForName("Posicion", inManagedObjectContext: self.contexto!)
                let nuevaPosicion = NSManagedObject(entity: nuevaPosicionEntidad!, insertIntoManagedObjectContext: self.contexto)
                nuevaPosicion.setValue(rutaViewController?.puntosNombres[i], forKey: "nombre")
                for (j,cell) in row.enumerate() {


                    if(j==0) {
                        nuevaPosicion.setValue(cell, forKey: "latitud")
                    } else {
                        nuevaPosicion.setValue(cell, forKey: "longitud")
                    }
                    
                    
                }
               
                
                nuevaRuta.setValue(NSSet(objects: nuevaPosicion), forKey: "posiciones")
            }

        }
        
        do {
            try self.contexto?.save()
            
            let alerta = UIAlertController(title: "Mensaje", message: "Ruta guardada con éxito", preferredStyle: .Alert)
            
            let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {accion in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alerta.addAction(accionOK)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
            
        } catch let error as NSError {
            
            print("Save failed: \(error.localizedDescription)")
            abort()
        }

        
        //nuevaRuta.setValue(UIImageJPEGRepresentation(self.portadaImagen.image!, 1.0), forKey: "portada")
    }
    
    @IBAction func textFieldDoneEditing() {
        
        nombreRuta.resignFirstResponder()
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func backgroundTap(sender:UIControl) {
        nombreRuta.resignFirstResponder()
        descRuta.resignFirstResponder()
       
    }
    

    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let sigVista = segue.destinationViewController as! FotosViewController
        
        sigVista.rutaPersistViewController = self
        
    }*/
    

}
