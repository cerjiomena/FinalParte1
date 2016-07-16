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
    
    var contexto : NSManagedObjectContext? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        descRuta.delegate = self
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPics(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fvc: FotosViewController = storyboard.instantiateViewControllerWithIdentifier("Fotos") as! FotosViewController
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
        
        do {
            try self.contexto?.save()
            
            let alerta = UIAlertController(title: "Mensaje", message: "Ruta guardada con éxito", preferredStyle: .Alert)
            
            let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {accion in
                
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
