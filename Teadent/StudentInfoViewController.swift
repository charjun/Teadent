
//
//  StudentInfoViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/12/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData

var level:String = ""
var studentName:String = ""

class StudentInfoViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var studentNameTextField: UITextField!
    
    var points:Int = 0
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var nextViewControllerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseLevel(sender: UIButton) {
        
        level = sender.titleLabel!.text!
        
        self.setAllLevelButtonsToDefault()
        
        if level.lowercaseString == "easy" {
            self.easyButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
            self.easyButton.backgroundColor = UIColor.blackColor()
            points = 1
        } else if level.lowercaseString == "medium" {
            self.mediumButton.backgroundColor = UIColor.blackColor()
            self.mediumButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
            points = 2
        } else if level.lowercaseString == "hard" {
            self.hardButton.backgroundColor = UIColor.blackColor()
            self.hardButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
            points = 4
        } else if level.lowercaseString == "all" {
            self.allButton.backgroundColor = UIColor.blackColor()
            self.allButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        }
        
    }
    
    func setAllLevelButtonsToDefault() {
        
        self.easyButton.backgroundColor = UIColor.clearColor()
        self.easyButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        
        self.mediumButton.backgroundColor = UIColor.clearColor()
        self.mediumButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        
        self.hardButton.backgroundColor = UIColor.clearColor()
        self.hardButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        
        self.allButton.backgroundColor = UIColor.clearColor()
        self.allButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
    }
    
    
    @IBAction func startQuiz(sender: UIButton) {
        
        if self.studentNameTextField.text == "" {
            let alertController = UIAlertController(title: "Hello!", message: "Please enter your name", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        } else if level == "" {
            let alertController = UIAlertController(title: "Hello!", message: "Please select a level", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        } else {
            studentName = self.studentNameTextField.text!
            print("\(studentName) \(level)")
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext
            let request = NSFetchRequest(entityName: "Teacher")
            request.returnsObjectsAsFaults = false
            
            if level.lowercaseString == "easy" {
                request.predicate = NSPredicate(format: "points = %d", 1)
            } else if level.lowercaseString == "medium" {
                let firstPredicate = NSPredicate(format: "points = %d", 2)
                let secondPredicate = NSPredicate(format: "points = %d", 4)
                request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstPredicate, secondPredicate])
            } else if level.lowercaseString == "hard" {
                request.predicate = NSPredicate(format: "points = %d", 8)
            }
            
            var flag:Bool = false
            do {
                let results = try context.executeFetchRequest(request)
                if results.count > 0 {
                    flag = true
                }
            } catch {
                print("error")
            }
            
            if flag {
                self.performSegueWithIdentifier("StartQuiz", sender: self.nextViewControllerButton)
                
            } else {
                let alertController = UIAlertController(title: "Hello!", message: "Please choose different level as there are no questions in \(level) level", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true) { }
                
                self.setAllLevelButtonsToDefault()
            }
                
        }
    }
    
    @IBAction func nextViewController(sender: UIButton) {
        
        self.performSegueWithIdentifier("StartQuiz", sender: sender)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
   
}
