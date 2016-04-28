//
//  FormTableViewController.swift
//  Formularios
//
//  Created by Adrián Rubio on 4/5/16.
//  Copyright © 2016 Adrián Rubio. All rights reserved.
//

import UIKit
import CloudKit

extension UIDatePicker
{
    func dateString() -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX")
        return dateFormatter.stringFromDate(self.date)
    }
    
    func timeString() -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX")
        return dateFormatter.stringFromDate(self.date)
    }
}

class FormTextField: UITextField
{
    @IBInspectable var cloudDataAttributeString:String? = ""
}

class FormTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    var container : CKContainer!
    var publicDB : CKDatabase!
    var privateDB : CKDatabase!
    
    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var textFields:[UITextField] = []
    
    var currentTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //CloudKit
        self.container = CKContainer.defaultContainer()
        self.publicDB = container.publicCloudDatabase
        self.privateDB = container.privateCloudDatabase
        
        let pred = NSPredicate(format: "Edad >= %d", 6)
        let query = CKQuery(recordType: "Formulario", predicate: pred)
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records, error) in
            print(records)
        }
        
        //Text delegate
        for tf in self.textFields
        {
            tf.delegate = self
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(InventoryTableViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tapOutside)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.currentTextField = textField
        
        switch textField.tag {
        case 1:
            self.datePicker.datePickerMode = .Date
            textField.inputView = self.datePicker
            textField.text = self.datePicker.dateString()
        case 2:
            self.datePicker.datePickerMode = .Time
            textField.inputView = self.datePicker
            textField.text = self.datePicker.timeString()
        default:
            break
        }

        
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        
    }
    
    
    func handleTap(sender: AnyObject)
    {
        
        self.view.endEditing(false)
    }
    
    
    

    @IBAction func cleanFields(sender: AnyObject) {
        
        let alert = UIAlertController(title: "¿Seguro?", message: "¿Está seguro que desea limpiar todos los campos del formulario actual?", preferredStyle: .ActionSheet)
        
        let action = UIAlertAction(title: "Limpiar", style: .Destructive) { (action) in
            for t in self.textFields
            {
                t.text = ""
            }
        }
        
        alert.addAction(action)
        
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel) { (action) in
        }
        
        
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true) { 
            //
        }
     
    }
    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
