//
//  ViewController.swift
//  Teadent
//
//  Created by Arjun Reddy on 8/10/15.
//  Copyright © 2015 Arjun Reddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var teacherButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yy HH:mm"
//        formatter.timeStyle = .ShortStyle
        print(formatter.stringFromDate(date))
        
    }

    override func viewWillAppear(animated: Bool) {
        self.studentButton.layer.borderWidth = 2
        self.studentButton.layer.borderColor = UIColor.blackColor().CGColor
        
        self.teacherButton.layer.borderWidth = 2
        self.teacherButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

