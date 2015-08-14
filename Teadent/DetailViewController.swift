//
//  DetailViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/11/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var question:String = detailQuestion
    var answer:String = ""
    var duration:Int = 0
    var points:Int = 0
    var answerType:String = ""
    
    var answerTypeArray:[String] = ["number", "string"]
    var pointsArray:[String] = ["1", "2", "4", "8"]
    var durationArray:[String] = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    
    var finalDuration:Int = 0
    var finalPoints:Int = 0
    var finalAnswerType:String = ""
    var edit:Int = 0
    
    @IBOutlet weak var successView: UIView!
    
    @IBOutlet weak var answerTypePickerView: UIPickerView!
    @IBOutlet weak var durationPickerView: UIPickerView!
    @IBOutlet weak var pointsPickerView: UIPickerView!
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var answerTypeTextField: UITextField!

    @IBOutlet weak var answerEditButton: UIButton!
    @IBOutlet weak var durationEditButton: UIButton!
    @IBOutlet weak var pointsEditButton: UIButton!
    @IBOutlet weak var answerTypeEditButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = question
        
        self.successView.layer.borderWidth = 1
        self.successView.layer.borderColor = UIColor.blackColor().CGColor
        self.successView.hidden = true
        
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        
        self.answerEditButton.hidden = true
        self.durationEditButton.hidden = true
        self.pointsEditButton.hidden = true
        self.answerTypeEditButton.hidden = true
        
        self.questionTextView.text = question
        self.questionTextView.editable = false
        self.questionTextView.selectable = false
        
        let flexibleSpaceBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action: nil)
        
        let durationToolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 30))
        durationToolBar.barStyle = UIBarStyle.Default
        let durationButton = UIBarButtonItem(title: "Duration (seconds)", style: UIBarButtonItemStyle.Done, target: self, action: nil)
        durationButton.tintColor = UIColor(red:1.0, green: 0.47, blue: 0.35, alpha: 1.0)
        durationToolBar.setItems([flexibleSpaceBarItem, durationButton, flexibleSpaceBarItem], animated: false)
        durationPickerView.insertSubview(durationToolBar, aboveSubview: durationPickerView)
        
        let pointsToolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 30))
        pointsToolBar.barStyle = UIBarStyle.Default
        let pointsButton = UIBarButtonItem(title: "Points", style: UIBarButtonItemStyle.Done, target: self, action: nil)
        pointsButton.tintColor = UIColor(red:1.0, green: 0.47, blue: 0.35, alpha: 1.0)
        pointsToolBar.setItems([flexibleSpaceBarItem, pointsButton, flexibleSpaceBarItem], animated: false)
        pointsPickerView.insertSubview(pointsToolBar, aboveSubview: pointsPickerView)
        
        let answerTypeToolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 30))
        answerTypeToolBar.barStyle = UIBarStyle.Default
        let answerTypeButton = UIBarButtonItem(title: "Answer Type", style: UIBarButtonItemStyle.Done, target: self, action: nil)
        answerTypeButton.tintColor = UIColor(red:1.0, green: 0.47, blue: 0.35, alpha: 1.0)
        answerTypeToolBar.setItems([flexibleSpaceBarItem, answerTypeButton, flexibleSpaceBarItem], animated: false)
        answerTypePickerView.insertSubview(answerTypeToolBar, aboveSubview: answerTypePickerView)
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "question = %@", question)
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                self.answer = results[0].valueForKey("answer") as! String
                self.answerTextField.text = self.answer
                
                self.duration = results[0].valueForKey("duration") as! Int
                self.durationTextField.text = "\(self.duration) seconds"
                
                self.points = results[0].valueForKey("points") as! Int
                self.pointsTextField.text = "\(self.points) points"
                
                self.answerType = results[0].valueForKey("answerType") as! String
                self.answerTypeTextField.text = self.answerType
                
            }
        } catch {
            print("inside detail view controller not able to fetch")
        }
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem = self.backButtonItem()
        self.answerTextField.enabled = false
        self.durationTextField.enabled = false
        self.pointsTextField.enabled = false
        self.answerTypeTextField.enabled = false
        
        self.durationPickerView.delegate = self;
        self.pointsPickerView.delegate = self;
        self.answerTypePickerView.delegate = self;
        
    }
    
    func backButtonItem() -> UIBarButtonItem {
        
        let backButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack"))
        
        return backButtonItem
        
    }
    
    func goBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func editButtonItem() -> UIBarButtonItem {
        
        let editButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("editDetails"))
        
        return editButtonItem
        
    }
    
    func editDetails() {
        
        self.navigationItem.rightBarButtonItem = self.doneButtonItem()
        self.navigationItem.leftBarButtonItem = self.cancelButtonItem()
        
        self.answerEditButton.hidden = false
        self.durationEditButton.hidden = false
        self.pointsEditButton.hidden = false
        self.answerTypeEditButton.hidden = false
        
        
    }
    
    func doneButtonItem() -> UIBarButtonItem {
        
        let doneButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneEditing"))
        
        return doneButtonItem
        
    }
    
    func doneEditing() {
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem = self.backButtonItem()

        self.answerTextField.clearButtonMode = UITextFieldViewMode.Never
        self.answerTextField.textAlignment = NSTextAlignment.Right
        self.answerTextField.borderStyle = UITextBorderStyle.None
        self.answerTextField.enabled = false
        
        self.answerEditButton.hidden = true
        self.durationEditButton.hidden = true
        self.pointsEditButton.hidden = true
        self.answerTypeEditButton.hidden = true
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "question = %@", question)
        
        var flag:Bool = false 
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                results[0].setValue(self.answerTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), forKey: "answer")
                results[0].setValue(duration, forKey: "duration")
                results[0].setValue(points, forKey: "points")
                results[0].setValue(answerType, forKey: "answerType")
                
                do {
                    try context.save()
                    
                    flag = true
                    
                } catch {
                    let alertController = UIAlertController(title: "Hello!", message: "Question is not updated. Please try after some time", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) { }
                }
            }
            
        } catch {
            let alertController = UIAlertController(title: "Hello!", message: "Question is not updated. Please try after some time", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        }
        
        if flag {
            UIView.animateWithDuration(1.0) { () -> Void in
                self.successView.hidden = false
            }
            
            _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("animationDone"), userInfo: nil, repeats: false)
            
        }
        
    }
    
    func animationDone() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.successView.hidden = true
        }
    }
    
    func cancelButtonItem() -> UIBarButtonItem {
        
        let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelEditing"))
        
        return cancelButtonItem
        
    }
    
    func cancelEditing() {
        
        self.navigationItem.leftBarButtonItem = self.backButtonItem()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.answerTextField.text = self.answer
        self.durationTextField.text = "\(self.duration) points"
        self.pointsTextField.text = "\(self.points) points"
        self.answerTypeTextField.text = self.answerType
        
        self.answerTextField.clearButtonMode = UITextFieldViewMode.Never
        self.answerTextField.textAlignment = NSTextAlignment.Right
        self.answerTextField.borderStyle = UITextBorderStyle.None
        self.answerTextField.enabled = false
        
        self.answerEditButton.hidden = true
        self.durationEditButton.hidden = true
        self.pointsEditButton.hidden = true
        self.answerTypeEditButton.hidden = true
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func editAnswer(sender: UIButton) {
        self.answerTextField.enabled = true
        self.answerTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.answerTextField.textAlignment = NSTextAlignment.Left
        self.answerTextField.clearButtonMode = UITextFieldViewMode.Always
    }
    
    @IBAction func editDuration(sender: UIButton) {
        
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        self.durationPickerView.hidden = false
    }
    
    @IBAction func editPoints(sender: UIButton) {
        
        self.answerTypePickerView.hidden = true
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = false
    }
    
    @IBAction func editAnswerType(sender: UIButton) {
        
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = false
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            return self.durationArray.count
        } else if pickerView.tag == 200 {
            return self.pointsArray.count
        } else if pickerView.tag == 300 {
            return self.answerTypeArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100 {
            return self.durationArray[row]
        } else if pickerView.tag == 200 {
            return self.pointsArray[row]
        } else if pickerView.tag == 300 {
            return self.answerTypeArray[row]
        } else {
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 100 {
            self.durationTextField.text = "\(durationArray[row]) seconds"
            finalDuration = Int(durationArray[row])!
            duration = finalDuration
            self.durationPickerView.hidden = true
        } else if pickerView.tag == 200 {
            self.pointsTextField.text = "\(pointsArray[row]) points"
            finalPoints = Int(pointsArray[row])!
            points = finalPoints
            self.pointsPickerView.hidden = true
        } else if pickerView.tag == 300 {
            self.answerTypeTextField.text = "\(answerTypeArray[row])"
            finalAnswerType = answerTypeArray[row]
            answerType = finalAnswerType
            self.answerTypePickerView.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
