//
//  AddQuestionViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/10/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData

class AddQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var durationPickerView: UIPickerView!
    @IBOutlet weak var pointsPickerView: UIPickerView!
    @IBOutlet weak var answerTypePickerView: UIPickerView!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var answerTypeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
 
    @IBOutlet weak var successView: UIView!
    
    var answerTypeArray:[String] = ["number", "string"]
    var pointsArray:[String] = ["1", "2", "4", "8"]
    var durationArray:[String] = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    
    var finalDuration:Int = 0
    var finalPoints:Int = 0
    var finalAnswerType:String = ""
    var edit:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.successView.hidden = true;
        
        self.successView.layer.borderWidth = 1
        self.successView.layer.borderColor = UIColor.blackColor().CGColor

        self.durationPickerView.delegate = self;
        self.pointsPickerView.delegate = self;
        self.answerTypePickerView.delegate = self;
        
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
        
        
        
//        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        self.submitButton.hidden = true
        
        print("add question")

       
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func editDuration(sender: UIButton) {
        
        edit = 1
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        self.durationPickerView.hidden = false
        self.submitButton.hidden = true
        
    }
    
    @IBAction func editPoints(sender: UIButton) {
        
        edit = 1
        self.answerTypePickerView.hidden = true
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = false
        self.submitButton.hidden = true
        
    }
    
    @IBAction func editAnswerType(sender: UIButton) {
    
        edit = 1
        self.durationPickerView.hidden = true
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = false
        self.submitButton.hidden = true
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
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 100 {
            self.durationLabel.text = "\(durationArray[row]) seconds"
            finalDuration = Int(durationArray[row])!
            self.durationPickerView.hidden = true
            if(edit == 0) {
                self.pointsPickerView.hidden = false
            } else {
                self.submitButton.hidden = true
            }
            
            if edit == 1 {
                self.submitButton.hidden = false
            }
            
            edit = 0
            
        } else if pickerView.tag == 200 {
            self.pointsLabel.text = "\(pointsArray[row]) points"
            finalPoints = Int(pointsArray[row])!
            self.pointsPickerView.hidden = true
            if edit == 0 {
                self.answerTypePickerView.hidden = false
            } else {
                self.submitButton.hidden = true
            }
            
            if edit == 1 {
                self.submitButton.hidden = false
            }
            edit = 0
            
        } else if pickerView.tag == 300 {
            self.answerTypeLabel.text = "\(answerTypeArray[row])"
            finalAnswerType = answerTypeArray[row]
            self.answerTypePickerView.hidden = true
            self.submitButton.hidden = false
        }
        
    }
    
    @IBAction func addQuestion(sender: UIButton) {
        
        if questionTextField.text == "" || answerTextField.text == "" || finalDuration == 0 || finalPoints == 0 || finalAnswerType == "" {
            
            let alertController = UIAlertController(title: "Hello!", message: "Please provide all detials of the question", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
            

        } else if (questionsArray.contains((questionTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!)) {
            
            let alertController = UIAlertController(title: "Hello!", message: "This question is already added. Please add new question", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
            
        } else {
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext
            
            let newQuestion = NSEntityDescription.insertNewObjectForEntityForName("Teacher", inManagedObjectContext: context)
            
            let question = questionTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            newQuestion.setValue(question, forKey: "question")
            newQuestion.setValue(answerTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), forKey: "answer")
            newQuestion.setValue(finalAnswerType, forKey: "answerType")
            newQuestion.setValue(finalDuration, forKey: "duration")
            newQuestion.setValue(finalPoints, forKey: "points")
            
            do {
                try context.save()
                
                allQuestions[question!] = "\(finalDuration) seconds, \(finalPoints) points"
                questionsArray.append(question!)
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.successView.center = CGPointMake(self.successView.center.x - 1000, self.successView.center.y - 1000)
                })
                
                _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("hideSuccessView"), userInfo: nil, repeats: false)
                
                
            } catch {
                print("cannot save now")
            }
        }
    }
    
    func hideSuccessView() {
        
        
        self.questionTextField.text = ""
        self.answerTextField.text = ""
        self.durationLabel.text = ""
        self.finalDuration = 0
        self.pointsLabel.text = ""
        self.finalPoints = 0
        self.answerTypeLabel.text = ""
        self.finalAnswerType = ""
        
        self.submitButton.hidden = true;
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.successView.center = CGPointMake(self.successView.center.x + 1000, self.successView.center.y + 1000)
        })
        
        self.durationPickerView.hidden = false
        self.pointsPickerView.hidden = true
        self.answerTypePickerView.hidden = true
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        self.answerTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLayoutSubviews() {
        
        self.successView.center = CGPointMake(self.successView.center.x + 1000, self.successView.center.y + 1000)
        
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
