//
//  ResultsTableViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/13/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData

var studentDetails:Dictionary<String, String> = Dictionary<String, String>()
var studentDetailsArray:[String] = [String]()
var currentStudentName:String = ""

class ResultsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Student Details"
        self.navigationItem.leftBarButtonItem = self.homeButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func homeButtonItem() -> UIBarButtonItem {
        
        let homeButton:UIBarButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goToHome"))
        
        return homeButton
        
        
    }
    
    func goToHome() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentDetails.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "studentCell")
        }
        
        cell!.textLabel?.text = studentDetailsArray[indexPath.row]
        cell!.detailTextLabel?.text = studentDetails[studentDetailsArray[indexPath.row]]
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.textLabel?.font = UIFont.systemFontOfSize(22.0)
        
        return cell!
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "StudentDetails")
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = ["studentName", "yourScore", "totalPoints"]
        
        do {
            let results = try context.executeFetchRequest(request)
            studentDetails = Dictionary<String, String>()
            studentDetailsArray = [String]()
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    let name:String = result.valueForKey("studentName") as! String
                    let score = result.valueForKey("yourScore") as! Int
                    let points = result.valueForKey("totalPoints") as! Int
                    
                    studentDetails[name] = "\(score) / \(points) points"
                    studentDetailsArray.append(name)
                    
                }
            }
            
        } catch {
            print("error")
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        currentStudentName = studentDetailsArray[indexPath.row]
        return indexPath
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60.0
        
    }

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studentDetail" {
            let rdvc:ResultsDetailViewController = segue.destinationViewController as! ResultsDetailViewController
            rdvc.hidesBottomBarWhenPushed = true
            
        }
    }
    

}
