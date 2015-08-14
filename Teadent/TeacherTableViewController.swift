//
//  TeacherTableViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/10/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData


var allQuestions:Dictionary<String,String> = Dictionary<String, String>()
var questionsArray:[String] = [String]()
var detailQuestion:String = ""

class TeacherTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Questions"
        self.navigationItem.leftBarButtonItem = self.homeButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        /* let newQuestion = NSEntityDescription.insertNewObjectForEntityForName("Teacher", inManagedObjectContext: context)
        
        newQuestion.setValue("3 * 4", forKey: "question")
        newQuestion.setValue("12", forKey: "answer")
        newQuestion.setValue("number", forKey: "answerType")
        newQuestion.setValue(60, forKey: "duration")
        newQuestion.setValue(2, forKey: "points")
        
        do {
        try context.save()
        } catch {
        print("cannot save now")
        } */
        
        let request = NSFetchRequest(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            allQuestions = Dictionary<String, String>()
            questionsArray = [String]()
            
            if(results.count > 0) {
                
                for result in results as! [NSManagedObject] {
                    let question:String = result.valueForKey("question") as! String
                    let duration = result.valueForKey("duration") as! Int
                    let points = result.valueForKey("points") as! Int
                    
                    allQuestions[question] = "\(duration) seconds, \(points) points"
                    if !questionsArray.contains(question) {
                        questionsArray.append(question)
                    }
                }
            }
            
        } catch {
            print("cannot retrieve now")
        }
        
        tableView.reloadData()
    }

    func homeButtonItem() -> UIBarButtonItem {
        
        let homeButton:UIBarButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goToHome"))
        
        return homeButton

    }
    
    func goToHome() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allQuestions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = questionsArray[indexPath.row]
        cell!.detailTextLabel?.text = allQuestions[questionsArray[indexPath.row]]
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.textLabel?.font = UIFont.systemFontOfSize(22.0)
        
        return cell!

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DetailSegue" {
            let dvc:DetailViewController = segue.destinationViewController as! DetailViewController
            dvc.hidesBottomBarWhenPushed = true
        } else if segue.identifier == "AddSegue" {
            let aqvc:AddQuestionViewController = segue.destinationViewController as! AddQuestionViewController
            aqvc.hidesBottomBarWhenPushed = true
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        detailQuestion = questionsArray[indexPath.row]
        return indexPath
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let deletingQuestion = questionsArray[indexPath.row]
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext
            
            let request = NSFetchRequest(entityName: "Teacher")
            let predicate = NSPredicate(format: "question = %@", questionsArray[indexPath.row])
            
            request.predicate = predicate
            
            do {
                let result = try context.executeFetchRequest(request)
                
                if result.count > 0 {
                    
                    context.deleteObject(result[0] as! NSManagedObject)
                    
                    try context.save()
                    
                    questionsArray.removeAtIndex(questionsArray.indexOf(deletingQuestion)!)
                    allQuestions.removeValueForKey(deletingQuestion)
                    
                    tableView.reloadData()
                    
                }
                
            } catch {
                print("unable to delete data")
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60.0
        
    }

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

}
