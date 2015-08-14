//
//  ResultsDetailViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/13/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit
import CoreData

class ResultsDetailViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var correctTextView: UITextView!
    @IBOutlet weak var wrongTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = currentStudentName
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "StudentDetails")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "studentName = %@", currentStudentName)
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                
                self.nameLabel.text = results[0].valueForKey("studentName") as? String
                
                let score:Int = results[0].valueForKey("yourScore") as! Int
                self.scoreLabel.text = "Score : \(score) points"
                
                let points:Int = results[0].valueForKey("totalPoints") as! Int
                self.totalPointsLabel.text = "Total Points : \(points) points"
                
                let time:String = results[0].valueForKey("time") as! String
                self.timeLabel.text = "Time : \(time)"
                
                let correct:String = results[0].valueForKey("correctQuestions") as! String
                self.correctTextView.text = "Correct : \(correct)"
                
                let wrong:String = results[0].valueForKey("wrongQuestions") as! String
                self.wrongTextView.text = "Wrong : \(wrong)"
                
            }
            
        } catch {
            print("error")
        }

        
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
