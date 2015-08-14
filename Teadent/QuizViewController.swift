//
//  QuizViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/12/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData

class QuizViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    
    var questionsWithAnswerType:Dictionary<String, String> = Dictionary<String, String>()
    var questions:[String] = [String]()
    var correctAnswerList:[String] = [String]()
    var wrongAnswerList:[String] = [String]()
    var numberOfQuestions:Int = 0
    var currentDuration:Int = 0
    var yourScore:Int = 0
    var currentQuestion:String = ""
    var totalPoints:Int = 0
    let date = NSDate()
    
    var clapImageCounter:Int = 1
    var statusViewTimer = NSTimer()
    var timer = NSTimer()
    
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statusView.hidden = true
        
        self.statusView.layer.borderWidth = 1
        self.statusView.layer.borderColor = UIColor.blackColor().CGColor

        self.nameLabel.text = studentName.componentsSeparatedByString(" ")[0]
        self.yourScoreLabel.text = "Your Score : 0"
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
//        request.propertiesToFetch = ["question", "answerType"]
        
        if level.lowercaseString == "easy" {
            request.predicate = NSPredicate(format: "points = %d", 1)
        } else if level.lowercaseString == "medium" {
            let firstPredicate = NSPredicate(format: "points = %d", 2)
            let secondPredicate = NSPredicate(format: "points = %d", 4)
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstPredicate, secondPredicate])
        } else if level.lowercaseString == "hard" {
            request.predicate = NSPredicate(format: "points = %d", 8)
        }
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    let answerType:String = result.valueForKey("answerType") as! String
                    let duration:Int = result.valueForKey("duration") as! Int
                    
                    questionsWithAnswerType[result.valueForKey("question") as! String] =  answerType + ",\(duration)"
                    questions.append(result.valueForKey("question") as! String)
                    
                }
                
            }
        } catch {
            print("inside detail view controller not able to fetch")
        }
        
        self.numberOfQuestions = questionsWithAnswerType.count
        
        if self.numberOfQuestions == 0 {
            print("no questions of this level left")
        } else {
            
            let rand:Int = Int(arc4random_uniform(UInt32(self.numberOfQuestions)))
            self.currentQuestion = questions[rand]
            
            self.questionLabel.text = self.currentQuestion
            
            let answerType:String = questionsWithAnswerType[currentQuestion]!.componentsSeparatedByString(",")[0]
            self.currentDuration = Int(questionsWithAnswerType[currentQuestion]!.componentsSeparatedByString(",")[1])!
            
            if answerType.lowercaseString == "number" {
                self.answerTextField.keyboardType = UIKeyboardType.NumberPad
            } else {
                self.answerTextField.keyboardType = UIKeyboardType.Default
            }
            
            self.questions.removeAtIndex(self.questions.indexOf(currentQuestion)!)
            self.questionsWithAnswerType.removeValueForKey(self.currentQuestion)
            self.numberOfQuestions -= 1
            
            self.validateTimer()
        }
        
    }
    
    func durationTimer() {
        self.currentDuration -= 1
        self.timerLabel.text = String(currentDuration)
        
        if currentDuration == 0 {
            timer.invalidate()
            self.getNextQuestion()
        }
        
    }
    
    func validateTimer() {
        timer.invalidate()
        self.timerLabel.text = String(self.currentDuration)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("durationTimer"), userInfo: nil, repeats: true)
    }
    
    func getNextQuestion() {
        
        print("your score : \(self.yourScore); donelist : \(self.correctAnswerList)")
        
        self.answerTextField.text = ""
        
        if self.numberOfQuestions > 0 {
            let rand:Int = Int(arc4random_uniform(UInt32(self.numberOfQuestions)))
            self.currentQuestion = questions[rand]
            
            self.questionLabel.text = self.currentQuestion
            
            let answerType:String = questionsWithAnswerType[currentQuestion]!.componentsSeparatedByString(",")[0]
            currentDuration = Int(questionsWithAnswerType[currentQuestion]!.componentsSeparatedByString(",")[1])!
            
            if answerType.lowercaseString == "number" {
                self.answerTextField.keyboardType = UIKeyboardType.NumberPad
            } else {
                self.answerTextField.keyboardType = UIKeyboardType.Default
            }
            
            self.questions.removeAtIndex(self.questions.indexOf(currentQuestion)!)
            self.questionsWithAnswerType.removeValueForKey(self.currentQuestion)
            self.numberOfQuestions -= 1
            
            self.validateTimer()
        
        } else {
            print("done with all questions")
            
            var correctQuestionsString:String = ""
            
            if self.correctAnswerList.count > 0 {
                for index in 0...(self.correctAnswerList.count - 1) {
                    correctQuestionsString = correctQuestionsString + self.correctAnswerList[index] + ","
                }
                correctQuestionsString = correctQuestionsString.substringToIndex(correctQuestionsString.endIndex.predecessor())
            }
            
            var wrongQuestionsString:String = ""
            
            if self.wrongAnswerList.count > 0 {
                for index in 0...(self.wrongAnswerList.count - 1) {
                    wrongQuestionsString = wrongQuestionsString + self.wrongAnswerList[index] + ","
                }
                wrongQuestionsString = wrongQuestionsString.substringToIndex(wrongQuestionsString.endIndex.predecessor())
            }
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext
            
            let newRecord = NSEntityDescription.insertNewObjectForEntityForName("StudentDetails", inManagedObjectContext: context)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy HH:mm"
            
            print("inside \(studentName)")
            
            
            newRecord.setValue(self.yourScore, forKey: "yourScore")
            newRecord.setValue(correctQuestionsString, forKey: "correctQuestions")
            newRecord.setValue(level, forKey: "level")
            newRecord.setValue(1, forKey: "numberOfAttempts")
            newRecord.setValue(studentName, forKey: "studentName")
            newRecord.setValue(formatter.stringFromDate(self.date), forKey: "time")
            newRecord.setValue(wrongQuestionsString, forKey: "wrongQuestions")
            newRecord.setValue(self.totalPoints, forKey: "totalPoints")
            
            do {
                try context.save()
            } catch {
                print("cannot save now")
            }
            
            self.statusViewLabel.text = "Congratulations \(studentName)! Your score is \(yourScore)"
            self.statusImageView.image = UIImage(named: "clap1.png")
            
            self.questionLabel.text = ""
            self.yourScoreLabel.text = ""
            self.timerLabel.text = ""
            self.submitButton.hidden = true
            self.answerTextField.hidden = true
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.statusView.hidden = false
            })
            self.statusViewTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("doClapAnimation"), userInfo: nil, repeats: true)
            
        }
    }
    
    @IBAction func exitOfStatusView(sender: UIButton) {
        
        self.statusViewTimer.invalidate()
        self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    func doClapAnimation() {
        
        if self.clapImageCounter == 20 {
            self.clapImageCounter = 1
        } else {
            self.clapImageCounter++
        }
        
        self.statusImageView.image = UIImage(named: "clap\(self.clapImageCounter).png")
        
    }
    
    @IBAction func submitAnswer(sender: UIButton) {
        
        timer.invalidate()
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "question = %@", currentQuestion)
        
        var isCurrentAnswer:Bool = false
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                if results[0].valueForKey("answer")?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString == self.answerTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) {

                    isCurrentAnswer = true
                    self.yourScore += results[0].valueForKey("points") as! Int
                    
                }
                self.totalPoints += results[0].valueForKey("points") as! Int
            }
            
        } catch {
            print("error")
        }
        
        if isCurrentAnswer {
            print("correctAnswer")
            self.correctAnswerList.append(self.currentQuestion)
            self.yourScoreLabel.text = "YourScore : \(self.yourScore)"
        } else {
            self.wrongAnswerList.append(self.currentQuestion)
        }
        
        self.getNextQuestion()
        
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
