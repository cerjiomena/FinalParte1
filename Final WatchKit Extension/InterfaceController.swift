//
//  InterfaceController.swift
//  Final WatchKit Extension
//
//  Created by Serch on 10/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import WatchKit
import Foundation
import CoreData


class InterfaceController: WKInterfaceController {

    @IBOutlet var itemPicker: WKInterfacePicker!
    
    var foodList: [(String, String)] = [
        ("Broccoli", "Gross"),
        ("Brussel Sprouts", "Gross"),
        ("Soup", "Delicious"),
        ("Steak", "Delicious"),
        ("Ramen", "Delicious"),
        ("Pizza", "Delicious") ]
    
     var contexto : NSManagedObjectContext? = nil

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
       //NSManagedObjectContext * managedContext = [[CoreDataHelper, sharedHelper], context];

    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let fetchRequest = NSFetchRequest(entityName: "Ruta")
        
        //var rutas = try contexto!.executeFetchRequest(fetchRequest)
        
        
        do {
            let rutas =  try contexto!.executeFetchRequest(fetchRequest)
            print("*********")
            print(rutas.count)

            
        } catch let error as NSError {
            
            print("retrieve failed: \(error.localizedDescription)")
            abort()
        }

        
        
        
        
       
        
        let pickerItems: [WKPickerItem] = foodList.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.0
            pickerItem.caption = $0.1
            return pickerItem
        }
        itemPicker.setItems(pickerItems)
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func pickerSelectedItemChanged(value: Int) {
        
        NSLog("List Picker: \(foodList[value].0) selected")
        pushControllerWithName("detalleWK", context: nil)
    }
    

}
